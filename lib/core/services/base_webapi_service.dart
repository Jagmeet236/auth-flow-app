import 'package:auth_flow_app/core/env/env_config.dart';
import 'package:dio/dio.dart';
import 'package:hive/hive.dart';

class BaseWebApiService {
  late final Dio _dio;

  BaseWebApiService._internal() {
    _dio = Dio(BaseOptions(
      baseUrl: EnvConfig.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ));

    _dio.interceptors.add(LogInterceptor(
      request: true,
      requestHeader: true,
      requestBody: true,
      responseHeader: true,
      responseBody: true,
      error: true,
    ));

    // Attach access token to every request
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final box = await Hive.openBox('authBox');
        final String? token = box.get('accessToken');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
    ));
  }

  static final BaseWebApiService _instance = BaseWebApiService._internal();
  factory BaseWebApiService() => _instance;

  Dio get dio => _dio;
}