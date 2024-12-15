import 'package:flutter/material.dart';
import '../utils/token_manager.dart';
import '../core/app_routes.dart';

class ProfileScreen extends StatelessWidget {
  void _logout(BuildContext context) async {
    await TokenManager.clearToken();
    Navigator.pushNamed(context, AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: Center(child: Text("Profile Screen")),
    );
  }
}
