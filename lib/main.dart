import 'package:flutter/material.dart';
import 'core/app_routes.dart';
import 'utils/token_manager.dart';
import 'views/login_screen.dart';
import 'views/navigation_screen.dart';
import 'services/auth_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // Updated _checkLoginStatus
  Future<bool> _checkLoginStatus() async {
    final authService = AuthService();
    final token = await TokenManager.getToken();

    if (token == null || token.isEmpty) {
      return false; // No token
    }

    return await authService.verifyToken(); // Validate token with API
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter REST API Boilerplate',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: AppRoutes.routes, // Centralized routing
      home: FutureBuilder<bool>(
        future: _checkLoginStatus(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else if (snapshot.hasData && snapshot.data == true) {
            return NavigationScreen(); // Logged-in navigation
          } else {
            return LoginScreen(); // Non-logged-in screen
          }
        },
      ),
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            body: Center(child: Text("404: Page not found")),
          ),
        );
      },
    );
  }
}
