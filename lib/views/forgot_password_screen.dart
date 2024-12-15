import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../services/auth_service.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final AuthService _authService = AuthService();

  // Controllers for the input fields
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _step1Success = false;
  bool _otpSuccess = false;
  String _forgotToken = "";

  // Step 1: Send Forgot Password Request
  void _sendResetRequest() async {
    try {
      final result = await _authService.forgotPasswordRequest(
        _emailController.text.trim(),
      );

      Fluttertoast.showToast(msg: result.message);
      setState(() {
        _step1Success = true;
        _forgotToken = result.token ?? ""; // Store token for Step 2
      });
    } catch (e) {
      Fluttertoast.showToast(msg: "Error: $e");
    }
  }

  // Step 2: Verify OTP Code
  void _verifyOtp() async {
    try {
      final result = await _authService.verifyForgotPasswordCode(
        _otpController.text.trim(),
        _forgotToken,
      );

      Fluttertoast.showToast(msg: result.message);
      setState(() {
        _otpSuccess = true;
      });
    } catch (e) {
      Fluttertoast.showToast(msg: "Error: $e");
    }
  }

  // Step 3: Reset Password
  void _resetPassword() async {
    try {
      final result = await _authService.resetPassword(
        _passwordController.text.trim(),
        _otpController.text.trim(),
        _forgotToken,
      );

      Fluttertoast.showToast(msg: result.message);
      Navigator.pop(context); // Navigate back to login screen
    } catch (e) {
      Fluttertoast.showToast(msg: "Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Forgot Password')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!_step1Success) ...[
              // Step 1: Email Input
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Enter Email',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _sendResetRequest,
                child: Text("Send Reset Request"),
              ),
            ] else if (!_otpSuccess) ...[
              // Step 2: OTP Input
              TextField(
                controller: _otpController,
                decoration: InputDecoration(
                  labelText: 'Enter OTP Code',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _verifyOtp,
                child: Text("Verify OTP"),
              ),
            ] else ...[
              // Step 3: New Password Input
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Enter New Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _resetPassword,
                child: Text("Reset Password"),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
