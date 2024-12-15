import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../models/user_profile.dart';
import '../utils/token_manager.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _authService = AuthService();
  UserProfile? _userProfile;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  // Load user profile from local storage, then fetch latest from server
  void _loadUserProfile() async {
    final localProfile = await TokenManager.getUserInfo();
    setState(() {
      _userProfile = localProfile;
    });

    try {
      final updatedProfile = await _authService.getUserProfile();
      setState(() {
        _userProfile = updatedProfile;
      });
    } catch (e) {
      print("Error fetching user profile: $e");
    }
  }

  void _logout() async {
    await TokenManager.clearToken();
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
            tooltip: "Logout",
          ),
        ],
      ),
      body: _userProfile != null
          ? Center(
              child: Card(
                margin: EdgeInsets.all(16.0),
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(_userProfile?.avatar ??
                            'https://via.placeholder.com/150'),
                      ),
                      SizedBox(height: 10),
                      Text(
                        _userProfile?.nickname ?? "No Name",
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 5),
                      Text("Email: ${_userProfile?.email ?? "Not Provided"}"),
                      SizedBox(height: 5),
                      Text(
                          "Phone: ${_userProfile?.phoneNumber ?? "Not Provided"}"),
                    ],
                  ),
                ),
              ),
            )
          : Center(child: Text("No user profile data available")),
    );
  }
}
