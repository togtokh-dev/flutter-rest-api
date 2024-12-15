import '../core/api_client.dart';
import '../core/api_constants.dart';
import '../models/api_response.dart';

class AuthService {
  final ApiClient _apiClient = ApiClient();

  // Login API
  Future<ApiResponse<void>> login(String email, String password) async {
    final response = await _apiClient.post(ApiConstants.loginEndpoint, {
      "email": email,
      "password": password,
    });

    return ApiResponse.fromJson(response.data, (data) => null);
  }

  // Verify Token API
  Future<bool> verifyToken() async {
    try {
      final response = await _apiClient.get(ApiConstants.verifyTokenEndpoint);
      return response.data['success'];
    } catch (e) {
      print(e);
      return false;
    }
  }

  // Step 1: Signup
  Future<ApiResponse<void>> signupStep1(
      String email, String password, String username) async {
    final response = await _apiClient.post(ApiConstants.signupStep1Endpoint, {
      "email": email,
      "password": password,
      "user_name": username,
    });

    return ApiResponse.fromJson(response.data, (data) => null);
  }

  // Step 2: Verify OTP Code
  Future<ApiResponse<void>> signupStep2(String code, String token) async {
    final response = await _apiClient.post(ApiConstants.signupStep2Endpoint, {
      "code": code,
      "token": token,
    });

    return ApiResponse.fromJson(response.data, (data) => null);
  }

  // Step 1: Send Forgot Password Request
  Future<ApiResponse<void>> forgotPasswordRequest(String email) async {
    final response =
        await _apiClient.post(ApiConstants.forgotPasswordRequestEndpoint, {
      "email": email,
    });

    return ApiResponse.fromJson(response.data, (data) => null);
  }

  // Step 2: Verify OTP Code
  Future<ApiResponse<void>> verifyForgotPasswordCode(
      String code, String forgotToken) async {
    final response =
        await _apiClient.post(ApiConstants.verifyForgotPasswordEndpoint, {
      "code": code,
      "forgot_token": forgotToken,
    });

    return ApiResponse.fromJson(response.data, (data) => null);
  }

  // Step 3: Reset Password
  Future<ApiResponse<void>> resetPassword(
      String password, String code, String forgotToken) async {
    final response = await _apiClient.post(ApiConstants.resetPasswordEndpoint, {
      "password": password,
      "code": code,
      "forgot_token": forgotToken,
    });

    return ApiResponse.fromJson(response.data, (data) => null);
  }
}
