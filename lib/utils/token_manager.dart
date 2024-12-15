import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_profile.dart';

class TokenManager {
  static const _tokenKey = "auth_token";
  static const _userInfoKey = "user_info";

  // Save Token
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  // Get Token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  // Clear Token
  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userInfoKey); // Clear user info too
  }

  // Save User Info
  static Future<void> saveUserInfo(UserProfile userProfile) async {
    final prefs = await SharedPreferences.getInstance();
    final userInfoJson = jsonEncode(userProfile.toJson());
    await prefs.setString(_userInfoKey, userInfoJson);
  }

  // Get User Info
  static Future<UserProfile?> getUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final userInfoJson = prefs.getString(_userInfoKey);
    if (userInfoJson != null) {
      return UserProfile.fromJson(jsonDecode(userInfoJson));
    }
    return null;
  }
}
