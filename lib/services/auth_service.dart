
import '../core/api_client.dart';
import '../models/login_response.dart';
import '../core/api_constants.dart';

class AuthService {
  final ApiClient _apiClient = ApiClient();

  Future<String> login(String email, String password) async {
    print(ApiConstants.loginEndpoint);
    final response = await _apiClient.post(ApiConstants.loginEndpoint, {
      "email": email,
      "password": password,
    });
print(response);
    final loginResponse = LoginResponse.fromJson(response.data);
    return loginResponse.token;
  }

  Future<bool> verifyToken() async {
    try {
      await _apiClient.get(ApiConstants.verifyTokenEndpoint);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
    