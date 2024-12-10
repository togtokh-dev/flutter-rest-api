import 'package:flutter/material.dart';
import '../services/example_service.dart';
import '../utils/token_manager.dart';

class ExampleScreen extends StatefulWidget {
  @override
  _ExampleScreenState createState() => _ExampleScreenState();
}

class _ExampleScreenState extends State<ExampleScreen> {
  final ExampleService _service = ExampleService();
  late Future<Map<String, dynamic>> _userProfileData;

  @override
  void initState() {
    super.initState();
    _userProfileData = _service.fetchUserProfile();
  }

  void _logout() async {
    await TokenManager.clearToken(); // Clear token
    Navigator.pushReplacementNamed(context, '/login'); // Navigate back to login
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User Profile"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
            tooltip: "Logout",
          ),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _userProfileData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.hasData) {
            final data = snapshot.data!;
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(data['user_avatar'] ?? ''),
                  ),
                  SizedBox(height: 10),
                  Text(
                    data['user_nickname'] ?? 'Unknown',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text("Phone: ${data['phone_number'] ?? 'N/A'}"),
                  SizedBox(height: 5),
                  Text("Role: ${data['user_role'] ?? 'N/A'}"),
                ],
              ),
            );
          } else {
            return Center(child: Text("No user data available"));
          }
        },
      ),
    );
  }
}
