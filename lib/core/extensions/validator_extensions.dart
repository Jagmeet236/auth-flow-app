extension ValidatorExt on String {
  bool isValidEmail() {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(this);
  }

  bool isValidPassword({int minLength = 6}) {
    return length >= minLength;
  }
}
