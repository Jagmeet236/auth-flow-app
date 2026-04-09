class SignUpResponse {
  final String message;
  final String uid;

  SignUpResponse({
    required this.message,
    required this.uid,
  });

  factory SignUpResponse.fromJson(Map<String, dynamic> json) {
    return SignUpResponse(
      message: json['message'] ?? '',
      uid: json['uid'] ?? '',
    );
  }
}
