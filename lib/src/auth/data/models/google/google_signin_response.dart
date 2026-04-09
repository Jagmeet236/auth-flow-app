class GoogleSignInResponse {
  final String accessToken;
  final String refreshToken;
  final int expiresIn;
  final String uid;
  final String role;
  final String provider;
  final String message;

  GoogleSignInResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
    required this.uid,
    required this.role,
    required this.provider,
    required this.message,
  });

  factory GoogleSignInResponse.fromJson(Map<String, dynamic> json) =>
      GoogleSignInResponse(
        accessToken: json['access_token'],
        refreshToken: json['refresh_token'],
        expiresIn: json['expires_in'],
        uid: json['uid'],
        role: json['role'],
        provider: json['provider'],
        message: json['message'],
      );
}