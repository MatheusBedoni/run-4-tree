import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../network/dio_client.dart';
import '../utils/env.dart';
import 'models/plant_tree_request.dart';
import 'models/plant_tree_response.dart';
import 'models/tree_nation_exception.dart';

class TreeNationService {
  final Dio _dio;

  TreeNationService({Dio? dio}) : _dio = dio ?? DioClient.instance;

  Future<PlantTreeResponse> plantTree(PlantTreeRequest request) async {
    final payload = request.toJson();
    debugPrint(
      '[TreeNation] POST ${_dio.options.baseUrl}/api/plant '
      'token=${_hasToken ? 'presente' : 'AUSENTE'} payload=$payload',
    );

    try {
      final response = await _dio.post('/api/plant', data: payload);

      debugPrint(
        '[TreeNation] status=${response.statusCode} '
        'tipo=${response.data.runtimeType} body=${response.data}',
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final json = _asJsonMap(response.data);
        if (json == null) {
          throw Exception(
            'Tree-Nation retornou um corpo não-JSON (${response.data.runtimeType}): ${response.data}',
          );
        }

        // A API sinaliza erro de negócio dentro de um HTTP 200, e nesse caso
        // o corpo não traz `trees`. Precisa ser checado ANTES do parse, senão
        // o cast estoura escondendo o errorCode real.
        if (json['status'] != 'ok') {
          throw TreeNationException(
            errorCode: json['errorCode'] as String?,
            errorMessage: json['errorMessage'] as String?,
            raw: json,
          );
        }

        final PlantTreeResponse result;
        try {
          result = PlantTreeResponse.fromJson(json);
        } catch (e) {
          // Campo faltando/nulo no JSON derruba o parse — a árvore pode ter
          // sido plantada de verdade mesmo assim, então o corpo cru importa.
          debugPrint('[TreeNation] FALHA ao desserializar resposta: $e');
          debugPrint('[TreeNation] chaves recebidas: ${json.keys.toList()}');
          rethrow;
        }

        if (result.trees.isEmpty) {
          throw Exception('Tree-Nation API returned no trees: ${response.data}');
        }

        debugPrint(
          '[TreeNation] OK: ${result.trees.length} árvore(s), '
          'ids=${result.trees.map((t) => t.id).toList()} '
          'paymentId=${result.paymentId}',
        );
        return result;
      } else {
        throw Exception('Failed to plant tree: ${response.statusCode} - ${response.data}');
      }
    } on DioException catch (e) {
      debugPrint(
        '[TreeNation] DioException tipo=${e.type} '
        'status=${e.response?.statusCode} body=${e.response?.data} msg=${e.message}',
      );
      if (e.response != null) {
         throw Exception('Tree-Nation API error: ${e.response?.statusCode} - ${e.response?.data}');
      } else {
         throw Exception('Network error: ${e.message}');
      }
    } on TreeNationException catch (e) {
      debugPrint('[TreeNation] erro de negócio: $e');
      rethrow;
    } catch (e) {
      debugPrint('[TreeNation] erro inesperado: $e');
      throw Exception('Unexpected error: $e');
    }
  }

  /// O token é injetado por interceptor a cada request (não fica em
  /// `options.headers`), então checa a fonte: o `.env`.
  bool get _hasToken => envOrNull('TREE_NATION_API_TOKEN') != null;

  /// A API pode responder com `Content-Type` não-JSON (ex: `text/html` numa
  /// página de erro), caso em que o Dio entrega uma `String` e o `fromJson`
  /// estouraria com um cast obscuro.
  Map<String, dynamic>? _asJsonMap(dynamic data) {
    if (data is Map<String, dynamic>) return data;
    if (data is Map) return Map<String, dynamic>.from(data);
    if (data is String && data.trim().isNotEmpty) {
      try {
        final decoded = jsonDecode(data);
        if (decoded is Map<String, dynamic>) return decoded;
      } catch (_) {
        return null;
      }
    }
    return null;
  }
}
