import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../core/app_routes.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final userProfile = authProvider.userProfile;

    // Function to refresh profile
    Future<void> _refreshProfile() async {
      try {
        await authProvider.checkLoginStatus();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile refreshed successfully!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to refresh profile: $e')),
        );
      }
    }

    // Function to logout
    Future<void> _logout() async {
      await authProvider.logout();
      Navigator.pushNamedAndRemoveUntil(
          context, AppRoutes.login, (route) => false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Logged out successfully!')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshProfile,
            tooltip: "Refresh Profile",
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.red),
            onPressed: _logout,
            tooltip: "Logout",
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshProfile, // Pull-to-refresh feature
        child: authProvider.isLoggedIn && userProfile != null
            ? ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: 60,
                      backgroundImage: userProfile.avatar != null
                          ? NetworkImage(userProfile.avatar!)
                          : const AssetImage('assets/default_avatar.png')
                              as ImageProvider,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // User Name
                  Center(
                    child: Text(
                      userProfile.nickname ?? "No Name",
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // User Email
                  ListTile(
                    leading: const Icon(Icons.email, color: Colors.blue),
                    title: Text(
                      userProfile.email ?? "Email not available",
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),

                  // User Phone
                  ListTile(
                    leading: const Icon(Icons.phone, color: Colors.green),
                    title: Text(
                      userProfile.phoneNumber ?? "Phone not available",
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Orders Button
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.orders);
                    },
                    icon: const Icon(Icons.list_alt),
                    label: const Text(
                      "Orders",
                      style: TextStyle(fontSize: 16),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(16.0),
                    ),
                  ),
                ],
              )
            : const Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}
