import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../core/app_routes.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // Controllers for user input
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  bool _isStep1Complete = false;
  bool _isLoading = false;

  // Step 1: Signup and Request OTP
  void _handleSignupStep1() async {
    setState(() => _isLoading = true);

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      final result = await authProvider.signupStep1(
        _emailController.text.trim(),
        _passwordController.text.trim(),
        _usernameController.text.trim(),
      );

      // Show toast based on result
      if (result['success'] == true) {
        setState(() => _isStep1Complete = true);
        Fluttertoast.showToast(msg: result['message']);
      } else {
        Fluttertoast.showToast(msg: "Step 1 Failed: ${result['message']}");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Step 2: Submit OTP
  void _handleSignupStep2() async {
    setState(() => _isLoading = true);

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      final result = await authProvider.signupStep2(
        _otpController.text.trim(),
      );

      // Show toast based on result
      if (result['success'] == true) {
        Fluttertoast.showToast(msg: result['message']);
        Navigator.pushReplacementNamed(context, AppRoutes.navigation);
      } else {
        Fluttertoast.showToast(msg: "Step 2 Failed: ${result['message']}");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Step 1 UI: Email, Password, Username Input
  Widget _buildStep1Form() {
    return Column(
      children: [
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
        const SizedBox(height: 10),
        TextField(
          controller: _usernameController,
          decoration: const InputDecoration(
            labelText: 'Username',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: _isLoading ? null : _handleSignupStep1,
          child: _isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text("Sign Up (Step 1)"),
        ),
      ],
    );
  }

  // Step 2 UI: OTP Input
  Widget _buildStep2Form() {
    return Column(
      children: [
        TextField(
          controller: _otpController,
          decoration: const InputDecoration(
            labelText: 'Enter OTP',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: _isLoading ? null : _handleSignupStep2,
          child: _isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text("Submit OTP (Step 2)"),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isStep1Complete ? _buildStep2Form() : _buildStep1Form(),
      ),
    );
  }
}
