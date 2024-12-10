import 'package:dio/dio.dart';
import '../utils/token_manager.dart';
import 'api_constants.dart';

class ApiClient {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: Duration(seconds: 10),
      receiveTimeout: Duration(seconds: 10),
    ),
  );

  // ANSI Color Codes
  final String reset = '\x1B[0m';
  final String green = '\x1B[32m';
  final String yellow = '\x1B[33m';
  final String red = '\x1B[31m';
  final String cyan = '\x1B[36m';

  ApiClient() {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        String? token = await TokenManager.getToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }

        // Colored Request Log
        print("${cyan}REQUEST [${options.method}] => PATH: ${options.path}${reset}");
        print("${yellow}HEADERS: ${options.headers}${reset}");
        print("${yellow}DATA: ${options.data}${reset}");

        return handler.next(options);
      },
      onResponse: (response, handler) {
        // Colored Response Log
        print("${green}RESPONSE [${response.statusCode}] => PATH: ${response.requestOptions.path}${reset}");
        print("${green}DATA: ${response.data}${reset}");

        return handler.next(response);
      },
      onError: (error, handler) {
        // Colored Error Log
        print("${red}ERROR [${error.response?.statusCode}] => PATH: ${error.requestOptions.path}${reset}");
        print("${red}MESSAGE: ${error.message}${reset}");
        print("${red}RESPONSE DATA: ${error.response?.data}${reset}");

        return handler.next(error);
      },
    ));
  }

  Future<Response> post(String endpoint, dynamic data) async {
    return await _dio.post(endpoint, data: data);
  }

  Future<Response> get(String endpoint) async {
    return await _dio.get(endpoint);
  }
}
