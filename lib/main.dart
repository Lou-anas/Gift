import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gift/auth/login.dart';
import 'package:gift/screens/infopage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AuthGate(), // Use the AuthGate widget
      routes: const {
        // Define any other routes you may need here
        // 'signup': (context) => Signup(),
        // 'login': (context) => Login(),
      },
    );
  }
}

class AuthGate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasData) {
          // User is logged in
          final user = snapshot.data!;
          return FutureBuilder<bool>(
            future: _isAdmin(user.email!),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasData && snapshot.data!) {
                // User is admin
                return InfoScreen(uid: user.uid);
              } else {
                // User is not admin
                return InfoScreen(uid: user.uid);
              }
            },
          );
        } else {
          // User is not logged in, show the login screen
          return LoginScreen();
        }
      },
    );
  }

  Future<bool> _isAdmin(String email) async {
    final admin = FirebaseFirestore.instance.collection('admin');
    final querySnapshot = await admin.where('email', isEqualTo: email).get();
    return querySnapshot.docs.isNotEmpty;
  }
}
