import '../core/api_client.dart';

class ExampleService {
  final ApiClient _apiClient = ApiClient();

  Future<Map<String, dynamic>> fetchUserProfile() async {
    try {
      final response = await _apiClient.get('/main/auth/v1/user/verify_token');
      return response.data["data"];
    } catch (e) {
      throw Exception("Failed to fetch user profile: $e");
    }
  }
}
