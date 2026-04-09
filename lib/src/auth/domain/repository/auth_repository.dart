import '../../data/models/signin/signin_request.dart';
import '../../data/models/signin/signin_response.dart';
import '../../data/models/signup/signup_request.dart';
import '../../data/models/signup/signup_response.dart';

abstract class AuthRepository {
  Future<SignInResponse> login(SignInRequest request);
  Future<SignUpResponse> signup(SignUpRequest request);
  Future<void> logout();
}
