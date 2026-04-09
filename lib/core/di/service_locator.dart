import 'package:get_it/get_it.dart';
import '../../src/auth/data/repository/auth_repository_impl.dart';
import '../../src/auth/domain/repository/auth_repository.dart';
import '../../src/auth/presentation/viewmodel/auth_viewmodel.dart';
import '../services/base_webapi_service.dart';

final GetIt locator = GetIt.instance;

void setupLocator() {
  // Core service
  locator.registerLazySingleton<BaseWebApiService>(() => BaseWebApiService());

  // Repositories
  locator.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl());

  // ViewModels
  locator.registerFactory<AuthViewModel>(() {
    final vm = AuthViewModel();
    vm.setRepository(locator<AuthRepository>());
    return vm;
  });
}
