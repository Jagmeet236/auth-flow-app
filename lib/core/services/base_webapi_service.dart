import 'package:auth_flow_app/core/env/env_config.dart';
import 'package:auth_flow_app/core/helpers/token_storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class BaseWebApiService with TokenStorage {
  late final Dio _dio;

  BaseWebApiService._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: EnvConfig.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );

    _dio.interceptors.add(
      LogInterceptor(requestBody: true, responseBody: true),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        // ✅ Attach token
        onRequest: (options, handler) async {
          final token = await getAccessToken();

          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          return handler.next(options);
        },

        // 🔥 HANDLE 401 HERE
        onError: (error, handler) async {
          if (error.response?.statusCode == 401) {
            // 🚨 No refresh API yet → logout behavior
            await clearAllTokens();
            // Optional: You can trigger global logout event here
            if (kDebugMode) {
              print("Session expired → user logged out");
            }

            return handler.reject(error);
          }

          return handler.next(error);
        },
      ),
    );
  }

  static final BaseWebApiService _instance = BaseWebApiService._internal();
  factory BaseWebApiService() => _instance;

  Dio get dio => _dio;
}
