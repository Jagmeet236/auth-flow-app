class SignInResponse {
  final String accessToken;
  final String refreshToken;
  final String uid;
  final String role;

  SignInResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.uid,
    required this.role,
  });

  factory SignInResponse.fromJson(Map<String, dynamic> json) {
    return SignInResponse(
      accessToken: json['access_token'] ?? '',
      refreshToken: json['refresh_token'] ?? '',
      uid: json['uid'] ?? '',
      role: json['role'] ?? '',
    );
  }
}