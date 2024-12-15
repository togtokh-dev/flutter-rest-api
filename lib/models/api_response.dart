class ApiResponse<T> {
  final bool success;
  final String message;
  final T? data;
  final String? token;

  ApiResponse({
    required this.success,
    required this.message,
    this.data,
    this.token,
  });

  factory ApiResponse.fromJson(
      Map<String, dynamic> json, T Function(dynamic) dataParser) {
    return ApiResponse<T>(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? dataParser(json['data']) : null,
      token: json['token'],
    );
  }
}
