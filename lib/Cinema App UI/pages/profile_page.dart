import 'package:flutter/material.dart';
import 'package:flutter_ui_design/Cinema%20App%20UI/consts.dart'; // Import file consts.dart nếu cần

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              // Avatar Section
              CircleAvatar(
                radius: 70,
                backgroundImage: NetworkImage('https://www.example.com/avatar.jpg'), // Placeholder URL for avatar
              ),
              const SizedBox(height: 16),
              const Text(
                'Nicolas Adams',  // Change this to dynamic user name
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.lightBlue,
                  fontFamily: 'Roboto',  // Change the font here
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'nicolasadams@gmail.com',  // Change this to dynamic user email
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  fontFamily: 'Roboto',  // Change the font here
                ),
              ),
              const SizedBox(height: 24),

              // Upgrade to PRO Button
              ElevatedButton(
                onPressed: () {
                  // Add functionality for upgrading to PRO
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow, // Yellow background color
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Upgrade to PRO',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Roboto',
                    color: Colors.black, // Black text color
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Profile Options - Inside a Container
              Container(
                decoration: BoxDecoration(
                  color: Colors.transparent, // Set to transparent to merge with the page background
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [],
                ),
                child: Column(
                  children: <Widget>[
                    ProfileOption(
                      title: 'Personal Information',
                      icon: Icons.person,
                      onTap: () {
                        // Handle tap for personal information
                      },
                    ),
                    const SizedBox(height: 16),
                    ProfileOption(
                      icon: Icons.settings,
                      title: 'Settings',
                      onTap: () {
                        // Handle tap for settings
                      },
                    ),
                    const SizedBox(height: 16),
                    ProfileOption(
                      icon: Icons.edit,
                      title: 'Edit Profile',
                      onTap: () {
                        // Handle tap for edit profile
                      },
                    ),
                    const SizedBox(height: 16),
                    ProfileOption(
                      icon: Icons.logout,
                      title: 'Logout',
                      onTap: () {
                        // Handle tap for logout
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      backgroundColor: appBackgroundColor, // Set the background color here
    );
  }
}

class ProfileOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const ProfileOption({
    required this.icon,
    required this.title,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue), // Icon color
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w500,
          color: Colors.white, // Change this color to whatever you like
        ),
      ),
      onTap: onTap,
    );
  }
}
