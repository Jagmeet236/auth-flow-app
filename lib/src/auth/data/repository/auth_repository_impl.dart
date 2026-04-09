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

      final data = SignInResponse.fromJson(response.data);

      await saveTokens(
        accessToken: data.accessToken,
        refreshToken: data.refreshToken,
      );

      return data;
    });
  }

  @override
  Future<SignUpResponse> signup(SignUpRequest request) async {
    return safeApiCall(() async {
      final response = await dio.post(
        '/v1/auth/signup',
        data: request.toJson(),
      );
      final data = SignUpResponse.fromJson(response.data);

      await saveTokens(
        accessToken: data.accessToken,
        refreshToken: data.refreshToken,
      );
      return data;
    });
  }
}
