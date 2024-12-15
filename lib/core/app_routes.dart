import 'package:flutter/material.dart';
import '../views/home_screen.dart';
import '../views/login_screen.dart';
import '../views/signup_screen.dart';
import '../views/forgot_password_screen.dart';
import '../views/navigation_screen.dart';
import '../views/product_details_screen.dart';

class AppRoutes {
  static const String login = '/login';
  static const String signup = '/signup';
  static const String forgotPassword = '/forgot-password';
  static const String home = '/home';
  static const String navigation = '/navigation';
  static const String productDetails = '/product';

  static Map<String, WidgetBuilder> routes = {
    login: (context) => LoginScreen(),
    signup: (context) => SignupScreen(),
    forgotPassword: (context) => ForgotPasswordScreen(),
    home: (context) => HomeScreen(),
    navigation: (context) => NavigationScreen(),
  };
}
