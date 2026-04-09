import 'package:dio/dio.dart';
import '../helpers/token_storage.dart';
import '../network/api_exception.dart';
import '../services/base_webapi_service.dart';
import 'package:get_it/get_it.dart';

abstract class BaseRepository with TokenStorage {
  Dio get dio => GetIt.instance<BaseWebApiService>().dio;

  Future<T> safeApiCall<T>(Future<T> Function() apiCall) async {
    try {
      return await apiCall();
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ApiException('Unexpected error: $e');
    }
  }

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await saveAccessToken(accessToken);
    await saveRefreshToken(refreshToken);
  }

  Future<void> clearTokens() async {
    await clearAllTokens();
  }

  Future<bool> isLoggedIn() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }

  ApiException _handleDioError(DioException error) {
    final statusCode = error.response?.statusCode;

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiException('Connection timeout', statusCode: statusCode);

      case DioExceptionType.badResponse:
        final data = error.response?.data;

        if (data is Map<String, dynamic>) {
          // 🔹 Handle "detail"
          if (data.containsKey('detail') && data['detail'] != null) {
            final detail = data['detail'];

            if (detail is String) {
              return ApiException(detail, statusCode: statusCode);
            } else if (detail is List && detail.isNotEmpty) {
              final firstError = detail.first;

              if (firstError is Map && firstError.containsKey('msg')) {
                return ApiException(
                  firstError['msg'].toString(),
                  statusCode: statusCode,
                );
              }

              return ApiException(
                detail.first.toString(),
                statusCode: statusCode,
              );
            }

            return ApiException(detail.toString(), statusCode: statusCode);
          }

          // 🔹 Handle "message"
          if (data.containsKey('message') && data['message'] != null) {
            return ApiException(
              data['message'].toString(),
              statusCode: statusCode,
            );
          }
        }

        return ApiException(
          'Invalid response: $statusCode',
          statusCode: statusCode,
        );

      case DioExceptionType.cancel:
        return ApiException('Request cancelled', statusCode: statusCode);

      case DioExceptionType.connectionError:
        return ApiException('No internet connection', statusCode: statusCode);

      default:
        return ApiException('Network error occurred', statusCode: statusCode);
    }
  }
}
