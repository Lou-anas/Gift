import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gift/auth/login.dart';

class DisconnectButton extends StatelessWidget {
  const DisconnectButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.logout, color: Colors.white),
      onPressed: () async {
        await FirebaseAuth.instance.signOut();
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginScreen()),
          (Route<dynamic> route) => false,
        );
      },
    );
  }
}
