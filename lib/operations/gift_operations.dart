import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class GiftOperations {
  // Method to add a new gift
  static Future<void> addGift({
    required BuildContext context,
    required String name,
    required int stock,
    required String type,
    required File image,
  }) async {
    try {
      // Upload the image
      final fileName =
          '${DateTime.now().millisecondsSinceEpoch}.png'; // Unique file name
      final storageRef =
          FirebaseStorage.instance.ref().child('gifts/$fileName');
      await storageRef.putFile(image);
      final imageUrl = await storageRef.getDownloadURL();

      // Add gift to Firestore
      await FirebaseFirestore.instance.collection('giftlist').add({
        'name': name,
        'stock': stock,
        'type': type,
        'image': imageUrl,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gift added successfully!'),
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
  }

  // Method to update an existing gift's image
  static Future<void> updateGiftImage(BuildContext context, String docId,
      String oldImageUrl, XFile? newImage) async {
    if (newImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select a new image."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      final fileName = '$docId-${DateTime.now().millisecondsSinceEpoch}.png';
      final storageRef =
          FirebaseStorage.instance.ref().child('gifts/$fileName');
      final file = File(newImage.path);

      // Debugging: Check file properties
      print('Uploading file: ${newImage.path}');

      // Upload the new image to Firebase Storage
      await storageRef.putFile(file);
      print('File uploaded successfully!');

      // Get the new image URL
      final newImageUrl = await storageRef.getDownloadURL();
      print('New image URL: $newImageUrl');

      // Delete the old image from Firebase Storage
      if (oldImageUrl.isNotEmpty) {
        final oldImageRef = FirebaseStorage.instance.refFromURL(oldImageUrl);
        await oldImageRef.delete();
        print('Old image deleted from Firebase');
      }

      // Update Firestore with the new image URL
      await FirebaseFirestore.instance
          .collection('giftlist')
          .doc(docId)
          .update({
        'image': newImageUrl,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Image updated successfully!"),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to update image: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Method to delete a gift
  static Future<void> deleteGift(String docId, String imageUrl) async {
    try {
      // Step 1: Delete the gift from the main 'giftlist'
      await FirebaseFirestore.instance
          .collection('giftlist')
          .doc(docId)
          .delete();

      // Step 2: Delete the corresponding image from Firebase Storage
      if (imageUrl.isNotEmpty) {
        final storageRef = FirebaseStorage.instance.refFromURL(imageUrl);
        await storageRef.delete();
      }

      // Step 3: Delete the gift from each worker's 'giftlistworker'
      final workersCollection =
          await FirebaseFirestore.instance.collection('workers').get();

      for (var workerDoc in workersCollection.docs) {
        final workerId = workerDoc.id;

        // Check if the worker has the gift in their 'giftlistworker' subcollection
        final workerGiftDoc = await FirebaseFirestore.instance
            .collection('workers')
            .doc(workerId)
            .collection('giftlistworker')
            .doc(docId)
            .get();

        if (workerGiftDoc.exists) {
          // If the gift exists in this worker's giftlistworker, delete it
          await FirebaseFirestore.instance
              .collection('workers')
              .doc(workerId)
              .collection('giftlistworker')
              .doc(docId)
              .delete();
        }
      }

      // Optionally, show a success message
    } catch (e) {
      // Optionally, show an error message
      print('Failed to delete gift: $e');
    }
  }

  // Method to pick an image from the gallery
  static Future<XFile?> pickImage() async {
    final picker = ImagePicker();
    return await picker.pickImage(source: ImageSource.gallery);
  }

  Future<void> _updateGiftInWorkers(
      String giftId, String updatedName, String updatedType) async {
    final workersCollection = FirebaseFirestore.instance.collection('workers');

    // Get all workers
    final workersSnapshot = await workersCollection.get();

    // Loop through each worker
    for (var workerDoc in workersSnapshot.docs) {
      final workerGiftlist =
          workersCollection.doc(workerDoc.id).collection('giftlistworker');

      // Find the corresponding gift in the worker's giftlist and update it
      final workerGiftSnapshot = await workerGiftlist
          .where('name', isEqualTo: updatedName) // Assuming name is unique
          .get();

      for (var workerGiftDoc in workerGiftSnapshot.docs) {
        await workerGiftDoc.reference.update({
          'type': updatedType,
        });
      }
    }
  }

  Future<void> _addGiftToWorkers(
      String giftId, String name, String imageUrl, String type) async {
    final workersCollection = FirebaseFirestore.instance.collection('workers');

    // Get all workers
    final workersSnapshot = await workersCollection.get();

    // Loop through each worker
    for (var workerDoc in workersSnapshot.docs) {
      final workerGiftlist =
          workersCollection.doc(workerDoc.id).collection('giftlistworker');

      // Add the new gift to each worker's giftlist
      await workerGiftlist.add({
        'name': name,
        'image': imageUrl,
        'type': type,
      });
    }
  }
}
