import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'home_screen.dart';
import 'card_screen.dart';
import 'profile_screen.dart';
import '../providers/auth_provider.dart';

class NavigationScreen extends StatefulWidget {
  @override
  _NavigationScreenState createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
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

  // Load the user profile using AuthProvider
  void _loadUserProfile() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.checkLoginStatus(); // Fetch profile and validate token
  }

  // Updates the current index
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

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
