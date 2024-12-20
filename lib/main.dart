import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'core/app_routes.dart';
import 'views/login_screen.dart';
import 'views/navigation_screen.dart';
import 'views/product_details_screen.dart';
import 'views/order_details_screen.dart'; // Import OrderDetailsScreen
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
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.checkLoginStatus();
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

      // Add deep link support
      onGenerateRoute: (settings) {
        Uri uri = Uri.parse(settings.name ?? '/');

        // Log for debugging
        print("Deep Link URI: ${uri.path}");

        // Product Details Route
        if (uri.pathSegments.length == 2 && uri.pathSegments[0] == 'product') {
          final productId = uri.pathSegments[1];
          return MaterialPageRoute(
            builder: (context) => ProductDetailsScreen(productId: productId),
          );
        }

        // Order Details Route
        if (uri.pathSegments.length == 2 &&
            uri.pathSegments[0] == 'order-details') {
          final orderId = uri.pathSegments[1];
          return MaterialPageRoute(
            builder: (context) => OrderDetailsScreen(orderId: orderId),
          );
        }

        // Default fallback for unknown routes
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            body: Center(child: Text('404: Page Not Found')),
          ),
        );
      },

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
          : const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
    );
  }
}
