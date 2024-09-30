import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:gift/operations/gift_operations.dart'; // Adjust import path

class AddGiftTab extends StatefulWidget {
  @override
  _AddGiftTabState createState() => _AddGiftTabState();
}

class _AddGiftTabState extends State<AddGiftTab> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  String _selectedType = 'normal'; // Default value
  File? _selectedImage;

  @override
  void dispose() {
    _nameController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await GiftOperations.pickImage();

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _addGift() async {
    final String name = _nameController.text;
    final String stockStr = _stockController.text;
    final int stock = int.tryParse(stockStr) ?? 0;

    // Validate input fields
    if (name.isEmpty || stockStr.isEmpty || _selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all fields and select an image.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      // Step 1: Check if the gift name already exists in the 'giftlist' collection
      final giftQuery = await FirebaseFirestore.instance
          .collection('giftlist')
          .where('name', isEqualTo: name)
          .get();

      if (giftQuery.docs.isNotEmpty) {
        // Gift name already exists
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('A gift with this name already exists.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Step 2: Add gift to the 'giftlist' collection
      final docRef = await GiftOperations.addGift(
        context: context,
        name: name,
        stock: stock,
        type: _selectedType,
        image: _selectedImage!,
      );

      // Step 3: Retrieve all workers and add the gift to their giftlistworker
      final workersCollection =
          FirebaseFirestore.instance.collection('workers');
      final workersSnapshot = await workersCollection.get();

      for (var workerDoc in workersSnapshot.docs) {
        final workerGiftlist =
            workersCollection.doc(workerDoc.id).collection('giftlistworker');

        // Add the new gift to each worker's 'giftlist'
        await workerGiftlist.add({
          'name': name,
          'image': _selectedImage!
              .path, // Update this based on how you store image URL
          'type': _selectedType,
          'stock': stock,
        });
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gift added and propagated to all workers!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add gift: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }

    // Clear input fields after adding gift
    _nameController.clear();
    _stockController.clear();
    setState(() {
      _selectedImage = null;
      _selectedType = 'normal'; // Reset to default value
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Add New Gift',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Gift Name'),
          ),
          TextField(
            controller: _stockController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Stock'),
          ),
          const SizedBox(height: 10),
          // Radio buttons for type
          Row(
            children: [
              Expanded(
                child: RadioListTile<String>(
                  title: const Text('VIP'),
                  value: 'vip',
                  groupValue: _selectedType,
                  onChanged: (String? value) {
                    setState(() {
                      _selectedType = value ?? 'normal';
                    });
                  },
                ),
              ),
              Expanded(
                child: RadioListTile<String>(
                  title: const Text('Normal'),
                  value: 'normal',
                  groupValue: _selectedType,
                  onChanged: (String? value) {
                    setState(() {
                      _selectedType = value ?? 'normal';
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _selectedImage == null
                  ? const Text('No image selected.')
                  : Image.file(
                      _selectedImage!,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: _pickImage,
                child: const Text('Select Image'),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: _addGift,
            child: const Text('Add Gift'),
          ),
        ],
      ),
    );
  }
}
