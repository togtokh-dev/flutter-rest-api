import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../services/auth_service.dart';
import '../utils/token_manager.dart';
import 'example_screen.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final AuthService _authService = AuthService();

  // Step 1 controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  // Step 2 controller
  final TextEditingController _otpController = TextEditingController();

  // State tracking
  bool _isStep1Complete = false;
  bool _isLoading = false;
  String _forgotToken = ""; // Token received from Step 1

  // Step 1: Sign Up - Collect email, password, and username
  void _handleSignupStep1() async {
    setState(() => _isLoading = true);
    try {
      final result = await _authService.signupStep1(
        _emailController.text.trim(),
        _passwordController.text.trim(),
        _usernameController.text.trim(),
      );

      if (result.success) {
        setState(() {
          _isStep1Complete = true;
          _forgotToken = result.token ?? "";
        });
        Fluttertoast.showToast(msg: result.message);
      } else {
        Fluttertoast.showToast(msg: "Step 1 Failed: ${result.message}");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Step 2: Verify OTP - Collect OTP input
  void _handleSignupStep2() async {
    setState(() => _isLoading = true);
    try {
      final result = await _authService.signupStep2(
        _otpController.text.trim(),
        _forgotToken,
      );

      if (result.success) {
        // Save the token and navigate to ExampleScreen
        await TokenManager.saveToken(result.token ?? "");
        Fluttertoast.showToast(msg: result.message);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ExampleScreen()),
        );
      } else {
        Fluttertoast.showToast(msg: "OTP Failed: ${result.message}");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // UI for Step 1: Signup form
  Widget _buildStep1Form() {
    return Column(
      children: [
        TextField(
          controller: _emailController,
          decoration:
              InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
        ),
        SizedBox(height: 10),
        TextField(
          controller: _passwordController,
          decoration: InputDecoration(
              labelText: 'Password', border: OutlineInputBorder()),
          obscureText: true,
        ),
        SizedBox(height: 10),
        TextField(
          controller: _usernameController,
          decoration: InputDecoration(
              labelText: 'Username', border: OutlineInputBorder()),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: _handleSignupStep1,
          child: _isLoading
              ? CircularProgressIndicator(color: Colors.white)
              : Text("Sign Up (Step 1)"),
        ),
      ],
    );
  }

  // UI for Step 2: OTP Input form
  Widget _buildStep2Form() {
    return Column(
      children: [
        TextField(
          controller: _otpController,
          decoration: InputDecoration(
              labelText: 'Enter OTP', border: OutlineInputBorder()),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: _handleSignupStep2,
          child: _isLoading
              ? CircularProgressIndicator(color: Colors.white)
              : Text("Submit OTP (Step 2)"),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isStep1Complete ? _buildStep2Form() : _buildStep1Form(),
      ),
    );
  }
}
