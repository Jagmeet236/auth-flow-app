import '../../../../../core/base/base_repository.dart';
import '../../domain/repository/auth_repository.dart';
import '../models/signin/signin_request.dart';
import '../models/signin/signin_response.dart';
import '../models/signup/signup_request.dart';
import '../models/signup/signup_response.dart';

class AuthRepositoryImpl extends BaseRepository implements AuthRepository {
  @override
  Future<SignInResponse> login(SignInRequest request) async {
    return safeApiCall(() async {
      final response = await dio.post(
        '/v1/auth/signin',
        data: request.toJson(),
      );
      return SignInResponse.fromJson(response.data);
    });
  }

  @override
  Future<SignUpResponse> signup(SignUpRequest request) async {
    return safeApiCall(() async {
      final response = await dio.post(
        '/v1/auth/signup',
        data: request.toJson(),
      );
      return SignUpResponse.fromJson(response.data);
    });
  }
}
