import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../utils/env.dart';

class DioClient {
  static Dio? _dio;

  static Dio get instance {
    if (_dio != null) return _dio!;

    final baseUrl = envOrNull('TREE_NATION_BASE_URL') ?? 'https://tree-nation.com';
    debugPrint('[Dio] baseUrl da Tree-Nation: $baseUrl');
    
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
        final token = envOrNull('TREE_NATION_API_TOKEN');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        } else {
          debugPrint('[Dio] TREE_NATION_API_TOKEN ausente — request irá sem Authorization');
        }
        debugPrint('[Dio] -> ${options.method} ${options.uri}');
        return handler.next(options);
      },
      onResponse: (response, handler) {
        debugPrint('[Dio] <- ${response.statusCode} ${response.requestOptions.uri}');
        return handler.next(response);
      },
      onError: (DioException e, handler) {
        debugPrint(
          '[Dio] xx ${e.requestOptions.method} ${e.requestOptions.uri} '
          'tipo=${e.type} status=${e.response?.statusCode} body=${e.response?.data}',
        );
        return handler.next(e);
      },
    ));

    return _dio!;
  }
}
