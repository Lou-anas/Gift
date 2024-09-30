import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../controllers/controllers.dart';
import 'package:gift/operations/gift_operations.dart';
import 'package:gift/services/manage_gifts_service.dart';

class ManageGiftsTab extends StatefulWidget {
  @override
  _ManageGiftsTabState createState() => _ManageGiftsTabState();
}

class _ManageGiftsTabState extends State<ManageGiftsTab> {
  final AdminControllers _controllers = AdminControllers();
  String? _selectedGiftType;

  @override
  void dispose() {
    _controllers.dispose();
    super.dispose();
  }

  void _showUpdateDialog(
      String docId, int stock, String? type, String oldImageUrl) {
    _controllers.typeController.text = type ?? '';
    _controllers.stockController.text = stock.toString();
    _selectedGiftType = type;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Update Stock'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _controllers.stockController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'New Stock',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              Column(
                children: [
                  const Text(
                    'Select Gift Type',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  RadioListTile<String>(
                    title: const Text('VIP'),
                    value: 'vip',
                    groupValue: _selectedGiftType,
                    onChanged: (value) {
                      setState(() {
                        _selectedGiftType = value!;
                      });
                    },
                  ),
                  RadioListTile<String>(
                    title: const Text('Normal'),
                    value: 'normal',
                    groupValue: _selectedGiftType,
                    onChanged: (value) {
                      setState(() {
                        _selectedGiftType = value!;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                final newStock =
                    int.tryParse(_controllers.stockController.text);
                if (newStock != null && _selectedGiftType != null) {
                  // Call the update method
                  ManageGiftsService.updateGiftStock(
                      context, docId, newStock, _selectedGiftType!);
                  Navigator.of(context).pop();
                } else {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content:
                            Text("Please enter valid stock and gift type."),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
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
      ),
    );
  }

  Future<void> _modifyImage(String docId, String oldImageUrl) async {
    final newImage = await GiftOperations.pickImage();
    if (newImage != null) {
      // Ensure an image is selected
      await GiftOperations.updateGiftImage(
          context, docId, oldImageUrl, newImage);
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
            'Manage Gifts',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('giftlist').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text(
                      'No gifts available.',
                      style: TextStyle(fontSize: 16),
                    ),
                  );
                }

                return ListView.separated(
                  itemCount: snapshot.data!.docs.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    final gift = snapshot.data!.docs[index];
                    final docId = gift.id;
                    final name = gift['name'] ?? 'No name';
                    final stock = gift['stock'] ?? 0;
                    final imageUrl = gift['image'] ?? '';

                    return Card(
                      elevation: 3,
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(
                            imageUrl,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.image_not_supported,
                                  size: 50);
                            },
                          ),
                        ),
                        title: Text(
                          name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text('Stock: $stock'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                _showUpdateDialog(
                                    docId, stock, gift['type'], imageUrl);
                              },
                            ),
                            IconButton(
                              icon: const Icon(
                                  Icons.image), // Icon for modifying the image
                              onPressed: () {
                                _modifyImage(docId,
                                    imageUrl); // Call method to modify the image
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Delete Gift'),
                                    content: const Text(
                                        'Are you sure you want to delete this gift?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          ManageGiftsService.deleteGift(
                                              docId, imageUrl, gift['name']);
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
