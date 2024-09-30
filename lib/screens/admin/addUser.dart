import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gift/controllers/controllers.dart';
// import 'package:gift/operations/user_operations.dart'; // Adjust import path

class AddUserTab extends StatefulWidget {
  @override
  _AddUserTabState createState() => _AddUserTabState();
}

class _AddUserTabState extends State<AddUserTab> {
  final AdminControllers _controllers = AdminControllers();
  String _selectedStatus = 'normal'; // Default status

  @override
  void dispose() {
    _controllers.dispose(); // Dispose of controllers
    super.dispose();
  }

  void _addUser() async {
    final phone = _controllers.userPhoneController.text;
    final nom = _controllers.nomController.text;
    final prenom = _controllers.prenomController.text;

    if (phone.isEmpty || nom.isEmpty || prenom.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter all fields."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('users').add({
        'phone': phone,
        'nom': nom,
        'prenom': prenom,
        'status': _selectedStatus,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("User added successfully!"),
          backgroundColor: Colors.green,
        ),
      );

      _controllers.userPhoneController.clear();
      _controllers.nomController.clear();
      _controllers.prenomController.clear();
      setState(() {
        _selectedStatus = 'normal'; // Reset status
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to add user: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Add New User'),
          TextField(
            controller: _controllers.userPhoneController,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(labelText: 'phone'),
          ),
          TextField(
            controller: _controllers.prenomController,
            decoration: const InputDecoration(labelText: 'First Name'),
          ),
          TextField(
            controller: _controllers.nomController,
            decoration: const InputDecoration(labelText: 'Last Name'),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: RadioListTile<String>(
                  title: const Text('VIP'),
                  value: 'vip',
                  groupValue: _selectedStatus,
                  onChanged: (value) {
                    setState(() {
                      _selectedStatus = value!;
                    });
                  },
                ),
              ),
              Expanded(
                child: RadioListTile<String>(
                  title: const Text('Normal'),
                  value: 'normal',
                  groupValue: _selectedStatus,
                  onChanged: (value) {
                    setState(() {
                      _selectedStatus = value!;
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: _addUser,
            child: const Text('Add User'),
          ),
        ],
      ),
    );
  }
}
