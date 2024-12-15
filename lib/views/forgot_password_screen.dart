import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  // Controllers for the input fields
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _step1Success = false;
  bool _otpSuccess = false;

  String _forgotToken = ""; // Token returned after step 1

  // Step 1: Send Forgot Password Request
  void _sendResetRequest() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    try {
      final result = await authProvider.sendForgotPasswordRequest(
        _emailController.text.trim(),
      );

      Fluttertoast.showToast(msg: result['message']);
      setState(() {
        _step1Success = true;
        _forgotToken = result['token'] ?? "";
      });
    } catch (e) {
      Fluttertoast.showToast(msg: "Error: $e");
    }
  }

  // Step 2: Verify OTP
  void _verifyOtp() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    try {
      final result = await authProvider.verifyForgotPasswordCode(
        _otpController.text.trim(),
        _forgotToken,
      );

      Fluttertoast.showToast(msg: result['message']);
      setState(() {
        _otpSuccess = true;
      });
    } catch (e) {
      Fluttertoast.showToast(msg: "Error: $e");
    }
  }

  // Step 3: Reset Password
  void _resetPassword() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    try {
      final result = await authProvider.resetForgotPassword(
        _passwordController.text.trim(),
        _otpController.text.trim(),
        _forgotToken,
      );

      Fluttertoast.showToast(msg: result['message']);
      Navigator.pop(context); // Go back to Login screen
    } catch (e) {
      Fluttertoast.showToast(msg: "Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Forgot Password')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!_step1Success) ...[
              // Step 1: Email Input
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Enter Email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _sendResetRequest,
                child: const Text("Send Reset Request"),
              ),
            ] else if (!_otpSuccess) ...[
              // Step 2: OTP Input
              TextField(
                controller: _otpController,
                decoration: const InputDecoration(
                  labelText: 'Enter OTP Code',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _verifyOtp,
                child: const Text("Verify OTP"),
              ),
            ] else ...[
              // Step 3: New Password Input
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Enter New Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _resetPassword,
                child: const Text("Reset Password"),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
