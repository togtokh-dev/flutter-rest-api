import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../utils/token_manager.dart';
import '../models/user_profile.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  UserProfile? _userProfile;
  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;
  UserProfile? get userProfile => _userProfile;
  String _signupToken = '';
  // Check login status
  Future<void> checkLoginStatus() async {
    final token = await TokenManager.getToken();
    if (token == null || token.isEmpty) {
      _isLoggedIn = false;
      notifyListeners();
      return;
    }

    final isValid = await _authService.verifyToken();
    if (isValid) {
      // Retrieve cached user profile if available
      final cachedProfile = await TokenManager.getUserInfo();
      if (cachedProfile != null) {
        _userProfile = cachedProfile;
      } else {
        _userProfile = await _authService.fetchUserProfile();
        await TokenManager.saveUserInfo(_userProfile!);
      }
      _isLoggedIn = true;
    } else {
      await TokenManager.clearToken();
      _isLoggedIn = false;
      _userProfile = null;
    }
    notifyListeners();
  }

  // Login method
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _authService.login(email, password);
      if (response.success) {
        await TokenManager.saveToken(response.data!);
        await checkLoginStatus(); // Refresh user profile
      }
      return {'success': response.success, 'message': response.message};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // Logout method
  Future<void> logout() async {
    await TokenManager.clearToken();
    _isLoggedIn = false;
    _userProfile = null;
    notifyListeners();
  }

  // Send Forgot Password Request
  Future<Map<String, dynamic>> sendForgotPasswordRequest(String email) async {
    try {
      final result = await _authService.forgotPasswordRequest(email);
      return {
        'message': result.message,
        'token': result.token,
      };
    } catch (e) {
      throw Exception("Failed to send reset request: $e");
    }
  }

// Verify Forgot Password OTP
  Future<Map<String, dynamic>> verifyForgotPasswordCode(
      String code, String forgotToken) async {
    try {
      final result =
          await _authService.verifyForgotPasswordCode(code, forgotToken);
      return {
        'message': result.message,
        'token': result.token,
      };
    } catch (e) {
      throw Exception("Failed to verify OTP: $e");
    }
  }

// Reset Password
  Future<Map<String, dynamic>> resetForgotPassword(
      String password, String code, String forgotToken) async {
    try {
      final result =
          await _authService.resetPassword(password, code, forgotToken);
      return {'message': result.message};
    } catch (e) {
      throw Exception("Failed to reset password: $e");
    }
  }

  // AuthProvider - Signup Step 1
  Future<Map<String, dynamic>> signupStep1(
      String email, String password, String username) async {
    try {
      final result = await _authService.signupStep1(email, password, username);
      _signupToken = result.token ?? ''; // Store token for Step 2
      notifyListeners();
      return {'success': result.success, 'message': result.message};
    } catch (e) {
      throw Exception("Signup Step 1 Failed: $e");
    }
  }

// AuthProvider - Signup Step 2
  Future<Map<String, dynamic>> signupStep2(String otp) async {
    try {
      final result = await _authService.signupStep2(otp, _signupToken);
      if (result.success) {
        await TokenManager.saveToken(result.token ?? '');
        notifyListeners();
      }
      return {'success': result.success, 'message': result.message};
    } catch (e) {
      throw Exception("Signup Step 2 Failed: $e");
    }
  }
}
