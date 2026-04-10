import 'package:get_it/get_it.dart';
import '../../src/auth/data/repository/auth_repository_impl.dart';
import '../../src/auth/domain/repository/auth_repository.dart';
import '../../src/auth/presentation/viewmodel/auth_viewmodel.dart';
import '../../src/splash/data/repository/splash_repository_impl.dart';
import '../../src/splash/domain/repository/splash_repository.dart';
import '../../src/splash/presentation/viewmodel/splash_viewmodel.dart';
import '../../src/home/data/repository/lesson_repository_impl.dart';
import '../../src/home/domain/repository/lesson_repository.dart';
import '../../src/home/presentation/viewmodel/home_viewmodel.dart';
import '../services/base_webapi_service.dart';

final GetIt locator = GetIt.instance;

void setupLocator() {
  // Core service
  locator.registerLazySingleton<BaseWebApiService>(() => BaseWebApiService());

  // Repositories
  locator.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl());
  locator.registerLazySingleton<SplashRepository>(() => SplashRepositoryImpl());
  locator.registerLazySingleton<LessonRepository>(() => LessonRepositoryImpl());

  // ViewModels
  locator.registerFactory<AuthViewModel>(() {
    final vm = AuthViewModel();
    vm.setRepository(locator<AuthRepository>());
    return vm;
  });

  locator.registerFactory<SplashViewModel>(() {
    final vm = SplashViewModel();
    vm.setRepository(locator<SplashRepository>());
    return vm;
  });

  locator.registerFactory<HomeViewModel>(() {
    final vm = HomeViewModel();
    vm.setRepository(locator<LessonRepository>());
    return vm;
  });
}
