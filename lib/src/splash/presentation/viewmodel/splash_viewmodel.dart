import '../../../../core/base/base_viewmodel.dart';
import '../../domain/repository/splash_repository.dart';
import '../navigator/splash_navigator.dart';

class SplashViewModel extends BaseViewModel<SplashNavigator, SplashRepository> {
  Future<void> init() async {
    // Add a slight delay so the splash screen is visible momentarily
    await Future.delayed(const Duration(milliseconds: 1500));
    final isLoggedIn = await repository.checkAuthStatus();
    
    if (isLoggedIn) {
      navigator?.navigateToHomeScreen();
    } else {
      navigator?.navigateToAuthScreen();
    }
  }
}
