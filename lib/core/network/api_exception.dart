class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, {this.statusCode});

  @override
  String toString() {
    return message;
  }

  factory ApiException.fromDioError(dynamic e) {
    if (e.response != null) {
      final statusCode = e.response?.statusCode;
      String message = "Something went wrong";
      
      if (statusCode == 404) {
        message = "Data not found";
      } else if (statusCode == 401) {
        message = "Session expired. Please login again.";
      } else if (statusCode != null && statusCode >= 500) {
        message = "Server error. Please try again later.";
      } else {
        message = e.response?.data?['detail'] ?? e.response?.data?['message'] ?? e.message ?? "Unknown error";
      }

      return ApiException(
        message,
        statusCode: statusCode,
      );
    }
    return ApiException("Network error. Please check your connection.");
  }
}
