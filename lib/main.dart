import 'package:flutter/material.dart';
import 'services/auth_service.dart';
import 'views/login_screen.dart';
import 'views/example_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  Future<bool> _checkLoginStatus() async {
    final authService = AuthService();
    return await authService.verifyToken();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter REST API Boilerplate',
      initialRoute: '/',
      routes: {
        '/': (context) => FutureBuilder<bool>(
          future: _checkLoginStatus(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            } else if (snapshot.data == true) {
              return ExampleScreen();
            } else {
              return LoginScreen();
            }
          },
        ),
        '/login': (context) => LoginScreen(),
        '/home': (context) => ExampleScreen(),
      },
      onUnknownRoute: (settings) {
        // Handles undefined routes
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            body: Center(child: Text("404: Page not found")),
          ),
        );
      },
    );
  }
}
