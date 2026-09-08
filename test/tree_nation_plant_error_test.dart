import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:run_4_tree/core/services/models/plant_tree_request.dart';
import 'package:run_4_tree/core/services/models/plant_tree_response.dart';
import 'package:run_4_tree/core/services/models/tree_nation_exception.dart';
import 'package:run_4_tree/core/services/tree_nation_service.dart';

/// Interceptor que devolve um corpo fixo sem tocar na rede.
Dio _dioRespondingWith(Map<String, dynamic> body) {
  final dio = Dio(BaseOptions(baseUrl: 'https://fake.tree-nation.test'));
  dio.httpClientAdapter = _StubAdapter(body);
  return dio;
}

void main() {
  group('PlantTreeRequest', () {
    test('não envia campos opcionais nulos no payload', () {
      final json = PlantTreeRequest(quantity: 1).toJson();

      expect(json['quantity'], 1);
      expect(json.containsKey('species_id'), isFalse);
      expect(json.containsKey('planter_id'), isFalse);
      expect(json.containsKey('order_id'), isFalse);
      expect(json.containsKey('message'), isFalse);
    });

    test('envia species_id quando informado', () {
      final json = PlantTreeRequest(quantity: 1, speciesId: 42).toJson();
      expect(json['species_id'], 42);
    });
  });

  group('PlantTreeResponse', () {
    test('tolera corpo de erro sem a chave trees', () {
      final response = PlantTreeResponse.fromJson({
        'status': 'error',
        'errorCode': 'tree_template',
        'errorMessage': 'no tree template',
      });

      expect(response.isOk, isFalse);
      expect(response.trees, isEmpty);
      expect(response.errorCode, 'tree_template');
    });
  });

  group('TreeNationService.plantTree', () {
    test(
      'HTTP 200 com status:error vira TreeNationException com o código real',
      () async {
        final service = TreeNationService(
          dio: _dioRespondingWith({
            'status': 'error',
            'errorCode': 'tree_template',
            'errorMessage': 'no tree template',
          }),
        );

        await expectLater(
          service.plantTree(PlantTreeRequest(quantity: 1)),
          throwsA(
            isA<TreeNationException>()
                .having((e) => e.errorCode, 'errorCode', 'tree_template')
                .having((e) => e.errorMessage, 'errorMessage', 'no tree template')
                .having((e) => e.isAccountConfigError, 'isAccountConfigError', isTrue)
                .having((e) => e.hint, 'hint', contains('tree template')),
          ),
        );
      },
    );

    test('resposta ok desserializa as árvores', () async {
      final service = TreeNationService(
        dio: _dioRespondingWith({
          'status': 'ok',
          'payment_id': 99,
          'trees': [
            {
              'id': 1,
              'token': 'tok',
              'collect_url': 'https://c',
              'certificate_url': 'https://cert',
              'country': 'BR',
              'project_id': 7,
              'project_name': 'Projeto',
              'project_url': 'https://p',
              'species_id': 3,
              'species_name': 'Ipê',
              'species_life_time_CO2': 12.5,
            },
          ],
        }),
      );

      final result = await service.plantTree(PlantTreeRequest(quantity: 1));

      expect(result.isOk, isTrue);
      expect(result.trees.single.id, 1);
      expect(result.paymentId, 99);
    });
  });
}

class _StubAdapter implements HttpClientAdapter {
  final Map<String, dynamic> body;

  _StubAdapter(this.body);

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) async => ResponseBody.fromString(
    jsonEncode(body),
    200,
    headers: {
      Headers.contentTypeHeader: [Headers.jsonContentType],
    },
  );

  @override
  void close({bool force = false}) {}
}
