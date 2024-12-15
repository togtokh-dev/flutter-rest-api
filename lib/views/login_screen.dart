import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../core/app_routes.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  void _login() async {
    setState(() => _isLoading = true);

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      // Call the updated login method
      final result = await authProvider.login(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      // Show dynamic message based on result
      Fluttertoast.showToast(
        msg: result['message'],
        toastLength: Toast.LENGTH_LONG,
      );

      if (result['success']) {
        // Navigate to the navigation screen
        Navigator.pushReplacementNamed(context, AppRoutes.navigation);
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "An error occurred: $e",
        toastLength: Toast.LENGTH_LONG,
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Welcome Back!",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _login,
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Login"),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.forgotPassword);
                  },
                  child: const Text("Forgot Password?"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.signup);
                  },
                  child: const Text("Sign Up"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
