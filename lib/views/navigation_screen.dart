import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'card_screen.dart';
import 'profile_screen.dart';
import '../services/auth_service.dart';
import '../models/user_profile.dart';
import '../utils/token_manager.dart';

class NavigationScreen extends StatefulWidget {
  @override
  _NavigationScreenState createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  final AuthService _authService = AuthService();
  UserProfile? _userProfile;
  int _selectedIndex = 0;

  // Screens for navigation
  final List<Widget> _screens = [
    HomeScreen(),
    CardScreen(),
    ProfileScreen(),
  ];
  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  // Updates the current index
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex], // Display the current screen
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.credit_card),
            label: 'Card',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
