import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserOperations {
  static Future<void> addUser(
    BuildContext context,
    String email,
    String nom,
    String prenom,
    String status
  ) async {
    if (nom.isEmpty || email.isEmpty || prenom.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter valid information."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('contact').add({
        'email': email,
        'nom': nom,
        'prenom': prenom,
        'status': status,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("User added successfully!"),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to add user: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  static Future<void> updateUser(
    BuildContext context,
    String docId,
    String email,
    String nom,
    String prenom,
    String status
  ) async {
    try {
      await FirebaseFirestore.instance.collection('contact').doc(docId).update({
        'email': email,
        'nom': nom,
        'prenom': prenom,
        'status': status,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User updated successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update user: $e'),
        ),
      );
    }
  }

  static Future<void> deleteUser(
    BuildContext context,
    String docId
  ) async {
    try {
      await FirebaseFirestore.instance.collection('contact').doc(docId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User deleted successfully!'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete user: $e'),
        ),
      );
    }
  }
}
