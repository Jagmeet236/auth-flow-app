import 'package:auth_flow_app/src/auth/data/models/signin/signin_request.dart';
import 'package:auth_flow_app/src/auth/data/models/signup/signup_request.dart';
import '../../../../../core/base/base_viewmodel.dart';
import '../../domain/repository/auth_repository.dart';
import '../navigator/auth_navigator.dart';

class AuthViewModel extends BaseViewModel<AuthNavigator, AuthRepository> {
  Future<void> login(String username, String password) async {
    setLoading(true);
    setError(null);

    try {
      final request = SignInRequest(username: username, password: password);
      await repository.login(request);

      setSuccess('Welcome back!');
      navigator?.navigateToHomeScreen();
    } catch (e) {
      setError(e.toString());
    } finally {
      setLoading(false);
    }
  }

  Future<void> signup(String username, String password) async {
    setLoading(true);
    setError(null);

    try {
      final request = SignUpRequest(password: password, username: username);
      await repository.signup(request);

      setSuccess('Account created successfully!');
      navigator?.navigateToHomeScreen();
    } catch (e) {
      setError(e.toString());
    } finally {
      setLoading(false);
    }
  }
}
