import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gift/operations/gift_operations.dart';
import 'package:image_picker/image_picker.dart';

class ManageGiftsService {
  // Update gift stock in both the 'giftlist' collection and workers' 'giftlistworker' collection
  static Future<void> updateGiftStock(BuildContext context, String docId,
      int newStock, String selectedGiftType) async {
    try {
      await FirebaseFirestore.instance
          .collection('giftlist')
          .doc(docId)
          .update({
        'stock': newStock,
        'type': selectedGiftType,
      });

      // Update all workers' giftlists as well
      final giftDoc = await FirebaseFirestore.instance
          .collection('giftlist')
          .doc(docId)
          .get();
      await updateGiftInWorkers(
          docId, giftDoc['name'], selectedGiftType, newStock);

      // Use a local function to show the SnackBar
      if (context.mounted) {
        // Check if context is still valid
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Gift updated successfully!"),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      // Again check if context is still valid before using it
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to update gift: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Modify the gift image
  static Future<void> modifyImage(
      BuildContext context, String docId, String oldImageUrl) async {
    final newImage = await GiftOperations.pickImage();
    if (newImage != null) {
      // Ensure an image is selected
      await GiftOperations.updateGiftImage(
          context, docId, oldImageUrl, newImage);
    }
  }

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

  // Update gift in each worker's 'giftlistworker' collection
  static Future<void> updateGiftInWorkers(String giftId, String updatedName,
      String updatedType, int newStock) async {
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
          'name': updatedName,
          'stock': newStock,
          'type': updatedType,
        });
      }
    }
  }

  static Future<void> deleteGift(
      String docId, String imageUrl, String giftName) async {
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

      // Step 3: Delete the gift from each worker's 'giftlistworker' by gift name
      final workersCollection =
          await FirebaseFirestore.instance.collection('workers').get();

      for (var workerDoc in workersCollection.docs) {
        final workerId = workerDoc.id;

        // Query the worker's giftlistworker for the gift by name
        final workerGiftsQuery = await FirebaseFirestore.instance
            .collection('workers')
            .doc(workerId)
            .collection('giftlistworker')
            .where('name',
                isEqualTo:
                    giftName) // Assuming 'name' field stores the gift name
            .get();

        // If gifts exist for this worker, delete them
        for (var giftDoc in workerGiftsQuery.docs) {
          await giftDoc.reference.delete(); // Delete the document
        }
      }

      // Optionally, show a success message
    } catch (e) {
      // Optionally, show an error message
      print('Failed to delete gift: $e');
    }
  }
}
