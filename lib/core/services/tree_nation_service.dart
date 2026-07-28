import 'package:dio/dio.dart';
import '../network/dio_client.dart';
import 'models/plant_tree_request.dart';
import 'models/plant_tree_response.dart';

class TreeNationService {
  final Dio _dio;

  TreeNationService({Dio? dio}) : _dio = dio ?? DioClient.instance;

  Future<PlantTreeResponse> plantTree(PlantTreeRequest request) async {
    try {
      final response = await _dio.post(
        '/api/plant',
        data: request.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return PlantTreeResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to plant tree: ${response.statusCode} - ${response.data}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
         throw Exception('Tree-Nation API error: ${e.response?.statusCode} - ${e.response?.data}');
      } else {
         throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
