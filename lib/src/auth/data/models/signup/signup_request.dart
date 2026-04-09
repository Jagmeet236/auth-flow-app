class SignUpRequest {
  final String username;
  final String password;

  SignUpRequest({required this.username, required this.password});

  Map<String, dynamic> toJson() => {
        'username': username,
        'password': password,
      };
}

