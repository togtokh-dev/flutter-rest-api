import 'package:flutter/material.dart';
import '../views/home_screen.dart';
import '../views/login_screen.dart';
import '../views/signup_screen.dart';
import '../views/forgot_password_screen.dart';
import '../views/navigation_screen.dart';
import '../views/product_details_screen.dart';
import '../views/order_list_screen.dart';
import '../views/order_details_screen.dart';

class AppRoutes {
  static const String login = '/login';
  static const String signup = '/signup';
  static const String forgotPassword = '/forgot-password';
  static const String home = '/home';
  static const String navigation = '/navigation';
  static const String productDetails = '/product';
  static const String orders = '/order-list';
  static const String orderDetails = '/order-details';

  static Map<String, WidgetBuilder> routes = {
    login: (context) => LoginScreen(),
    signup: (context) => SignupScreen(),
    forgotPassword: (context) => ForgotPasswordScreen(),
    home: (context) => HomeScreen(),
    navigation: (context) => NavigationScreen(),
    orders: (context) => const OrderListScreen(),
    productDetails: (context) {
      final args = ModalRoute.of(context)?.settings.arguments;

      // Log for debugging
      print("Route Arguments: $args");

      if (args is Map<String, dynamic>) {
        // Change to dynamic
        final productId = args['productId'];
        print("Product ID: $productId");

        if (productId != null && productId.isNotEmpty) {
          return ProductDetailsScreen(productId: productId);
        }
      }

      // Fallback: Error Screen
      return const Scaffold(
        body: Center(
          child: Text(
            "Error: Missing or Invalid Product ID",
            style: TextStyle(color: Colors.red, fontSize: 18),
          ),
        ),
      );
    },
    orderDetails: (context) {
      final args = ModalRoute.of(context)?.settings.arguments;

      // Log for debugging
      print("Route Arguments: $args");

      if (args is Map<String, dynamic>) {
        // Change to dynamic
        final orderId = args['orderId'];
        print("orderId ID: $orderId");

        if (orderId != null && orderId.isNotEmpty) {
          return OrderDetailsScreen(orderId: orderId);
        }
      }

      // Fallback: Error Screen
      return const Scaffold(
        body: Center(
          child: Text(
            "Error: Missing or Invalid Product ID",
            style: TextStyle(color: Colors.red, fontSize: 18),
          ),
        ),
      );
    },
  };
}
