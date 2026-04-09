class SignUpResponse {
  final String accessToken;
  final String refreshToken;
  final String uid;
  final String role;

  SignUpResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.uid,
    required this.role,
  });

  factory SignUpResponse.fromJson(Map<String, dynamic> json) {
    return SignUpResponse(
      accessToken: json['access_token'] ?? '',
      refreshToken: json['refresh_token'] ?? '',
      uid: json['uid'] ?? '',
      role: json['role'] ?? '',
    );
  }
}

