import 'package:google_sign_in/google_sign_in.dart';

import '../../../../../core/base/base_repository.dart';
import '../../domain/repository/auth_repository.dart';
import '../models/signin/signin_request.dart';
import '../models/signin/signin_response.dart';
import '../models/signup/signup_request.dart';
import '../models/signup/signup_response.dart';
import '../models/google/google_signin_request.dart';
import '../models/google/google_signin_response.dart';

class AuthRepositoryImpl extends BaseRepository implements AuthRepository {
  final _googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);
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

  @override
  Future<GoogleSignInResponse> googleLogin() async {
    return safeApiCall(() async {
      // Step 1️⃣ — Show native Google account picker
      final account = await _googleSignIn.signIn();
      if (account == null) {
        throw Exception('Google sign-in was cancelled by the user');
      }

      // Step 2️⃣ — Get the ID token from Google
      final googleAuth = await account.authentication;
      final idToken = googleAuth.idToken;
      if (idToken == null) {
        throw Exception('Failed to retrieve Google ID token');
      }

      // Step 3️⃣ — Send token to your backend
      final request = GoogleSignInRequest(token: idToken);
      final response = await dio.post(
        '/v1/auth/google',
        data: request.toJson(),
      );

      // Step 4️⃣ — Parse response and save tokens securely
      final data = GoogleSignInResponse.fromJson(response.data);
      await saveTokens(
        accessToken: data.accessToken,
        refreshToken: data.refreshToken,
      );

      return data;
    });
  }

  // ─── Logout ─────────────────────────────────────────────────────────────────

  @override
  Future<void> logout() async {
    await _googleSignIn.signOut(); // also sign out from Google
    await clearTokens();
  }
}
