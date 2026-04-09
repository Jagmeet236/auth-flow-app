class SignInResponse {
  final String accessToken;
  final int expiresIn;
  final String uid;
  final String role;
  final String provider;
  final String message;

  SignInResponse({
    required this.accessToken,
    required this.expiresIn,
    required this.uid,
    required this.role,
    required this.provider,
    required this.message,
  });

  factory SignInResponse.fromJson(Map<String, dynamic> json) {
    return SignInResponse(
      accessToken: json['access_token'] ?? '',
      expiresIn: json['expires_in'] ?? 0,
      uid: json['uid'] ?? '',
      role: json['role'] ?? '',
      provider: json['provider'] ?? '',
      message: json['message'] ?? '',
    );
  }
}