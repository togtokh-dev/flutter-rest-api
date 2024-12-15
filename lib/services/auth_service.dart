import '../core/api_client.dart';
import '../core/api_constants.dart';
import '../models/api_response.dart';
import '../models/user_profile.dart';
import '../utils/token_manager.dart';

class AuthService {
  final ApiClient _apiClient = ApiClient();

  // Login API
  Future<ApiResponse<String>> login(String email, String password) async {
    final response = await _apiClient.post(ApiConstants.loginEndpoint, {
      "email": email,
      "password": password,
    });

    return ApiResponse.fromJson(
        response.data, (data) => response.data['token']);
  }

  // Verify Token API
  Future<bool> verifyToken() async {
    try {
      final response = await _apiClient.get(ApiConstants.verifyTokenEndpoint);
      return response.data['success'];
    } catch (e) {
      print("Error verifying token: $e");
      return false;
    }
  }

  // Fetch User Profile (from Server)
  Future<UserProfile> fetchUserProfile() async {
    final response = await _apiClient.get(ApiConstants.verifyTokenEndpoint);
    if (response.data['success']) {
      return UserProfile.fromJson(response.data['data']);
    } else {
      throw Exception("Failed to fetch user profile");
    }
  }

  // Signup Step 1
  Future<ApiResponse<void>> signupStep1(
      String email, String password, String username) async {
    final response = await _apiClient.post(ApiConstants.signupStep1Endpoint, {
      "email": email,
      "password": password,
      "user_name": username,
    });

    return ApiResponse.fromJson(response.data, (data) => null);
  }

  // Signup Step 2 (Verify OTP)
  Future<ApiResponse<void>> signupStep2(String code, String token) async {
    final response = await _apiClient.post(ApiConstants.signupStep2Endpoint, {
      "code": code,
      "token": token,
    });

    return ApiResponse.fromJson(response.data, (data) => null);
  }

  // Forgot Password Steps
  Future<ApiResponse<void>> forgotPasswordRequest(String email) async {
    final response =
        await _apiClient.post(ApiConstants.forgotPasswordRequestEndpoint, {
      "email": email,
    });
    return ApiResponse.fromJson(response.data, (data) => null);
  }

  Future<ApiResponse<void>> verifyForgotPasswordCode(
      String code, String forgotToken) async {
    final response =
        await _apiClient.post(ApiConstants.verifyForgotPasswordEndpoint, {
      "code": code,
      "forgot_token": forgotToken,
    });
    return ApiResponse.fromJson(response.data, (data) => null);
  }

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
