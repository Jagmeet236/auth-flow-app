import 'package:auth_flow_app/core/base/base_navigator.dart';

abstract class LessonNavigator extends BaseNavigator {
  void navigateToLessonDetail(String lessonId);
  void navigateToAuthScreen();
}
