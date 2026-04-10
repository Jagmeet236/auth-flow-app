import 'package:auth_flow_app/src/home/data/models/lesson.dart';
import 'package:auth_flow_app/src/home/data/models/lesson_detail.dart';

abstract class LessonRepository {
  /// Fetches a paginated/full list of lessons.
  Future<List<Lesson>> fetchLessons();

  /// Fetches details for a specific lesson.
  Future<LessonDetail> fetchLessonDetail(String lessonId);

  /// Fetches activities related to a specific lesson.
  /// (The prompt specified the response is an array of models identical to a standard lesson)
  Future<List<Lesson>> fetchLessonActivities(String lessonId);
}
