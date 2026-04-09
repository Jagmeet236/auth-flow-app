import 'package:dio/dio.dart';
import '../helpers/token_storage.dart';
import '../services/base_webapi_service.dart';
import 'package:get_it/get_it.dart';

abstract class BaseRepository with TokenStorage {
  Dio get dio => GetIt.instance<BaseWebApiService>().dio;

  Future<T> safeApiCall<T>(Future<T> Function() apiCall) async {
    try {
      return await apiCall();
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  String _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connection timeout';
      case DioExceptionType.badResponse:
        return 'Invalid response: ${error.response?.statusCode}';
      case DioExceptionType.cancel:
        return 'Request cancelled';
      case DioExceptionType.connectionError:
        return 'No internet connection';
      default:
        return 'Network error occurred';
    }
  }
}