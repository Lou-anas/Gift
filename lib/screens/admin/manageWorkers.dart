import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../controllers/controllers.dart'; // Ensure this import is correct

class ManageWorkersTab extends StatefulWidget {
  @override
  _ManageWorkersTabState createState() => _ManageWorkersTabState();
}

class _ManageWorkersTabState extends State<ManageWorkersTab> {
  final AdminControllers _controllers = AdminControllers();
  
  @override
  void dispose() {
    _controllers.dispose(); // Dispose of controllers
    super.dispose();
  }

  Future<void> _updateWorker(String docId, String phone, String fullname,
      String email, String city) async {
    try {
      await FirebaseFirestore.instance.collection('workers').doc(docId).update({
        'phone': phone,
        'fullname': fullname,
        'email': email,
        'city': city,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Agent updated successfully!"),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to update Agent: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _deleteWorker(String docId) async {
    try {
      await FirebaseFirestore.instance
          .collection('workers')
          .doc(docId)
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Agent deleted successfully!"),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to delete Agent: $e"),
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
            'Manage Agents',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('workers').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text(
                      'No Agents available.',
                      style: TextStyle(fontSize: 16),
                    ),
                  );
                }

                return ListView.separated(
                  itemCount: snapshot.data!.docs.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    final worker = snapshot.data!.docs[index];
                    final docId = worker.id;
                    final phone = worker['phone'] ?? 'No phone';
                    final fullname = worker['fullname'] ?? 'No fullname';
                    final email = worker['email'] ?? 'No email';
                    final city = worker['city'] ?? 'No city';

                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
                      leading: CircleAvatar(
                        backgroundColor: Colors.blueAccent,
                        child: Text(
                          fullname.isNotEmpty
                              ? fullname[0].toUpperCase()
                              : '?', // Fallback to '?' if fullname is empty
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(
                        fullname,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text('Phone Number: $phone\nEmail: $email\nCity: $city'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              _controllers.userPhoneController.text = phone;
                              _controllers.fullnameController.text = fullname;
                              _controllers.emailController.text = email;
                              _controllers.cityController.text = city;

                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Update Agent'),
                                  content: StatefulBuilder(
                                    builder: (context, setState) {
                                      return Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          TextField(
                                            controller: _controllers.userPhoneController,
                                            keyboardType: TextInputType.phone,
                                            decoration: const InputDecoration(
                                              labelText: 'Phone',
                                            ),
                                          ),
                                          TextField(
                                            controller: _controllers.fullnameController,
                                            decoration: const InputDecoration(
                                              labelText: 'Full Name',
                                            ),
                                          ),
                                          TextField(
                                            controller: _controllers.emailController,
                                            decoration: const InputDecoration(
                                              labelText: 'Email',
                                            ),
                                          ),
                                          TextField(
                                            controller: _controllers.cityController,
                                            decoration: const InputDecoration(
                                              labelText: 'City',
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        _updateWorker(
                                          docId,
                                          _controllers.userPhoneController.text,
                                          _controllers.fullnameController.text,
                                          _controllers.emailController.text,
                                          _controllers.cityController.text,
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
                                  title: const Text('Delete Agent'),
                                  content: const Text(
                                      'Are you sure you want to delete this worker?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        _deleteWorker(docId);
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
