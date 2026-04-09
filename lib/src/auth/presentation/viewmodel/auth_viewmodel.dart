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
      final response = await repository.login(request);

      await saveAccessToken(response.accessToken);

      setSuccess('Welcome back!');
      navigator?.navigateToHomeScreen();
    } catch (e) {
      setError(e.toString());
    } finally {
      setLoading(false);
    }
  }

  Future<void> signup(String email, String password) async {
    setLoading(true);
    setError(null);

    try {
      final request = SignUpRequest(email: email, password: password);
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