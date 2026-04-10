import 'package:auth_flow_app/core/network/api_exception.dart';
import 'package:auth_flow_app/core/services/base_webapi_service.dart';
import 'package:auth_flow_app/src/home/data/models/lesson.dart';
import 'package:auth_flow_app/src/home/data/models/lesson_detail.dart';
import 'package:auth_flow_app/src/home/domain/repository/lesson_repository.dart';
import 'package:dio/dio.dart';

class LessonRepositoryImpl implements LessonRepository {
  final BaseWebApiService _apiService = BaseWebApiService();

  @override
  Future<List<Lesson>> fetchLessons() async {
    try {
      final response = await _apiService.dio.get('/v1/content/lessons');
      return LessonResponse.fromJson(response.data).lessons;
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  @override
  Future<LessonDetail> fetchLessonDetail(String lessonId) async {
    try {
      final response = await _apiService.dio.get('/v1/content/lesson/$lessonId');
      return LessonDetail.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  @override
  Future<List<Lesson>> fetchLessonActivities(String lessonId) async {
    try {
      final response =
          await _apiService.dio.get('/v1/content/lesson/$lessonId/activities');
      return LessonResponse.fromJson(response.data).lessons;
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    } catch (e) {
      throw ApiException(e.toString());
    }
  }
}
