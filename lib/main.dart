import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'core/app_routes.dart';
import 'views/login_screen.dart';
import 'views/navigation_screen.dart';
import 'core/theme.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isInitialized) {
      _initializeAuth();
    }
  }

  void _initializeAuth() async {
    print("_initializeAuth start");
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.checkLoginStatus();

      print("_initializeAuth end");
    } catch (e) {
      print("Error in _initializeAuth: $e");
    } finally {
      setState(() {
        _isInitialized = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter REST API Boilerplate',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routes: AppRoutes.routes,
      home: _isInitialized
          ? Consumer<AuthProvider>(
              builder: (context, authProvider, child) {
                if (authProvider.isLoggedIn) {
                  return NavigationScreen(); // Logged-in screen
                } else {
                  return LoginScreen(); // Login screen
                }
              },
            )
          : Scaffold(
              body:
                  Center(child: CircularProgressIndicator()), // Loading screen
            ),
    );
  }
}
