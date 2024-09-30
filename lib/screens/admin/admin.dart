import 'package:flutter/material.dart';
import 'package:gift/screens/admin/addGift.dart';
import 'package:gift/screens/admin/addUser.dart';
import 'package:gift/screens/admin/manageGifts.dart';
import 'package:gift/screens/admin/manageUsers.dart';
import 'package:gift/screens/admin/manageWorkers.dart';
import '../../controllers/controllers.dart'; // Ensure the correct import path
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth for disconnect functionality
import 'package:gift/auth/login.dart'; // Import your login screen
import 'package:flutter/services.dart'; // Import for SystemChrome

class AdminScreen extends StatefulWidget {
  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final AdminControllers _controllers = AdminControllers();
  int _selectedIndex = 0; // Index for the currently selected screen

  // List of screens
  final List<Widget> _screens = [
    ManageGiftsTab(),
    AddGiftTab(),
    ManageUsersTab(),
    AddUserTab(),
    ManageWorkersTab(),
  ];

  @override
  void initState() {
    super.initState();
    // Set the status bar color and content style
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.black, // Set the status bar color to black
        statusBarIconBrightness: Brightness.light, // Icons to be white
        statusBarBrightness: Brightness.dark, // Status bar to be dark
      ),
    );
  }

  @override
  void dispose() {
    _controllers.dispose();
    super.dispose();
  }

  // Function to disconnect the user
  Future<void> _disconnect() async {
    await FirebaseAuth.instance.signOut();
    // Navigate back to the login screen
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  // Function to handle navigation
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.of(context).pop(); // Close the drawer
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout), // Logout icon
            onPressed: _disconnect,
            tooltip: 'Disconnect', // Tooltip for accessibility
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                'Admin Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.card_giftcard),
              title: const Text('Manage Gifts'),
              onTap: () => _onItemTapped(0),
            ),
            ListTile(
              leading: const Icon(Icons.add_circle_outline),
              title: const Text('Add New Gift'),
              onTap: () => _onItemTapped(1),
            ),
            ListTile(
              leading: const Icon(Icons.supervised_user_circle),
              title: const Text('Manage Users'),
              onTap: () => _onItemTapped(2),
            ),
            ListTile(
              leading: const Icon(Icons.person_add),
              title: const Text('Add New User'),
              onTap: () => _onItemTapped(3),
            ),
            ListTile(
              leading: const Icon(Icons.group),
              title: const Text('Manage Workers'),
              onTap: () => _onItemTapped(4),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 16.0), // Add top padding
          child: _screens[_selectedIndex],
        ),
      ),
    );
  }
}
