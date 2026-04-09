import '../../../../core/base/base_repository.dart';
import '../../domain/repository/splash_repository.dart';

class SplashRepositoryImpl extends BaseRepository implements SplashRepository {
  @override
  Future<bool> checkAuthStatus() async {
    return await isLoggedIn();
  }
}
