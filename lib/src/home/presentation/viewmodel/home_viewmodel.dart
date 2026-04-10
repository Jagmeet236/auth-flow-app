import 'package:auth_flow_app/core/base/base_viewmodel.dart';
import 'package:auth_flow_app/src/home/data/models/lesson.dart';
import 'package:auth_flow_app/src/home/data/models/lesson_detail.dart';
import 'package:auth_flow_app/src/home/domain/repository/lesson_repository.dart';
import 'package:auth_flow_app/src/home/presentation/navigator/lesson_navigator.dart';

class HomeViewModel extends BaseViewModel<LessonNavigator, LessonRepository> {
  List<Lesson> _allLessons = [];
  List<Lesson> _displayedLessons = [];

  List<Lesson> get displayedLessons => _displayedLessons;

  LessonDetail? _currentLessonDetail;
  LessonDetail? get currentLessonDetail => _currentLessonDetail;

  List<Lesson> _currentActivities = [];
  List<Lesson> get currentActivities => _currentActivities;

  Future<void> fetchLessons() async {
    setLoading(true);
    setError(null);
    try {
      _allLessons = await repository.fetchLessons();
      _displayedLessons = List.from(_allLessons);
    } catch (e) {
      setError(e.toString());
      _allLessons = [];
      _displayedLessons = [];
    } finally {
      setLoading(false);
    }
  }

  void searchLessons(String query) {
    if (query.isEmpty) {
      _displayedLessons = List.from(_allLessons);
    } else {
      final q = query.toLowerCase();
      _displayedLessons = _allLessons.where((lesson) {
        return lesson.title.toLowerCase().contains(q) ||
            lesson.shortDescription.toLowerCase().contains(q);
      }).toList();
    }
    notifyListeners();
  }

  Future<void> fetchLessonDetailAndActivities(String lessonId) async {
    setLoading(true);
    setError(null);
    _currentLessonDetail = null;
    _currentActivities = [];
    notifyListeners();
    try {
      // Fetch detail first — required for the page to show anything meaningful
      _currentLessonDetail = await repository.fetchLessonDetail(lessonId);
      notifyListeners();

      // Fetch activities independently — failure here should not break the whole page
      try {
        _currentActivities = await repository.fetchLessonActivities(lessonId);
      } catch (_) {
        _currentActivities = [];
      }
    } catch (e) {
      setError(e.toString());
    } finally {
      setLoading(false);
    }
  }
}
