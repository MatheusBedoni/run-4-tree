import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DioClient {
  static Dio? _dio;

  static Dio get instance {
    if (_dio != null) return _dio!;

    final baseUrl = dotenv.env['TREE_NATION_BASE_URL'] ?? 'https://tree-nation.com';
    
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ));

    _dio!.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        final token = dotenv.env['TREE_NATION_API_TOKEN'];
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onResponse: (response, handler) {
        // Você pode adicionar logs ou tratamentos globais de sucesso aqui
        return handler.next(response);
      },
      onError: (DioException e, handler) {
        // Você pode adicionar logs ou tratamentos globais de erro aqui
        return handler.next(e);
      },
    ));

    return _dio!;
  }
}
