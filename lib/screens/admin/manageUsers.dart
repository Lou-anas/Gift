import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../controllers/controllers.dart'; // Ensure this import is correct

class ManageUsersTab extends StatefulWidget {
  @override
  _ManageUsersTabState createState() => _ManageUsersTabState();
}

class _ManageUsersTabState extends State<ManageUsersTab> {
  final AdminControllers _controllers = AdminControllers();
  String _selectedStatus = 'normal'; // Default status

  @override
  void dispose() {
    _controllers.dispose(); // Dispose of controllers
    super.dispose();
  }

  Future<void> _updateUser(String docId, String phone, String nom,
      String prenom, String status) async {
    try {
      await FirebaseFirestore.instance.collection('contact').doc(docId).update({
        'phone': phone,
        'nom': nom,
        'prenom': prenom,
        'status': status,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("User updated successfully!"),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to update user: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _deleteUser(String docId) async {
    try {
      await FirebaseFirestore.instance
          .collection('contact')
          .doc(docId)
          .delete();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to delete user: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Manage Users',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('contact').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text(
                      'No users available.',
                      style: TextStyle(fontSize: 16),
                    ),
                  );
                }

                return ListView.separated(
                  itemCount: snapshot.data!.docs.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    final user = snapshot.data!.docs[index];
                    final docId = user.id;
                    final phone = user['phone'] ?? 'No phone';
                    final nom = user['nom'] ?? 'No nom';
                    final prenom = user['prenom'] ?? 'No prenom';
                    final status = user['status'];

                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
                      leading: CircleAvatar(
                        backgroundColor:
                            status == 'vip' ? Colors.orangeAccent : Colors.grey,
                        child: Text(
                          nom.isNotEmpty
                              ? nom[0].toUpperCase()
                              : '?', // Fallback to '?' if nom is empty
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(
                        nom + " " + prenom,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text('Phone Number: $phone\nStatus: $status'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              _controllers.userPhoneController.text = phone;
                              _controllers.nomController.text = nom;
                              _controllers.prenomController.text = prenom;
                              _selectedStatus = status;

                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Update User'),
                                  content: StatefulBuilder(
                                    builder: (context, setState) {
                                      return Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          TextField(
                                            controller: _controllers
                                                .userPhoneController,
                                            keyboardType: TextInputType.phone,
                                            decoration: const InputDecoration(
                                              labelText: 'Phone',
                                            ),
                                          ),
                                          TextField(
                                            controller:
                                                _controllers.nomController,
                                            decoration: const InputDecoration(
                                              labelText: 'Nom',
                                            ),
                                          ),
                                          TextField(
                                            controller:
                                                _controllers.prenomController,
                                            decoration: const InputDecoration(
                                              labelText: 'Prenom',
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
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
                                        ],
                                      );
                                    },
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        _updateUser(
                                          docId,
                                          _controllers.userPhoneController.text,
                                          _controllers.nomController.text,
                                          _controllers.prenomController.text,
                                          _selectedStatus,
                                        );
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Update'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Cancel'),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Delete User'),
                                  content: const Text(
                                      'Are you sure you want to delete this user?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        _deleteUser(docId);
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Delete'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Cancel'),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
