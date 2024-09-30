import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gift/screens/tombola.dart';

class InfoPageService {
  static Future<String?> fetchRandomGift({required bool isVip}) async {
    CollectionReference giftlist =
        FirebaseFirestore.instance.collection('giftlist');
    QuerySnapshot querySnapshot = await giftlist.get();

    List<DocumentSnapshot> availableGifts = querySnapshot.docs.where((doc) {
      return isVip
          ? (doc['type'] == 'vip' && doc['stock'] > 0)
          : (doc['type'] != 'vip' && doc['stock'] > 0);
    }).toList();

    if (availableGifts.isNotEmpty) {
      int randomIndex = Random().nextInt(availableGifts.length);
      DocumentSnapshot giftDoc = availableGifts[randomIndex];
      String imagePath = giftDoc['image'];
      return imagePath.isNotEmpty ? imagePath : 'assets/gift.png';
    } else {
      return null;
    }
  }

  // Add BuildContext as a parameter to methods that need it
  static Future<void> saveToFirestore(
      BuildContext context,
      TextEditingController phoneController,
      TextEditingController nomController,
      TextEditingController prenomController,
      bool acceptedTerms,
      bool isAdult, // Add isAdult as a parameter
      FocusNode phoneFocusNode) async {
    // Check if the user is 18 or older
    if (!isAdult) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Vous devez avoir 18 ans ou plus pour participer."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Check if the terms are accepted
    if (!acceptedTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Veuillez accepter les conditions d'utilisation."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final phone = phoneController.text;
    final nom = nomController.text.trim(); // Trim leading/trailing spaces
    final prenom = prenomController.text.trim(); // Trim leading/trailing spaces

    // Validate the phone number
    if (phone.isEmpty ||
        phone.length != 10 ||
        !(phone.startsWith('06') || phone.startsWith('07'))) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Veuillez entrer un numéro de téléphone valide."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Validate names
    if (nom.isEmpty ||
        prenom.isEmpty ||
        !RegExp(r'^[a-zA-Z]+$').hasMatch(nom) ||
        !RegExp(r'^[a-zA-Z]+$').hasMatch(prenom)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Veuillez entrer un nom et un prénom valides."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final contacts = FirebaseFirestore.instance.collection('contact');
    final querySnapshot = await contacts.where('phone', isEqualTo: phone).get();

    if (querySnapshot.docs.isNotEmpty) {
      final existingDoc = querySnapshot.docs.first;
      final status = existingDoc['status'];

      if (status == 'normal') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Le numéro de téléphone existe déjà !"),
              backgroundColor: Colors.red),
        );
        return;
      }

      if (status == 'vip') {
        final vipGift = await fetchRandomGift(isVip: true);
        if (vipGift == null) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Aucun cadeau disponible"),
                content: const Text(
                    "Aucun cadeau VIP disponible pour le moment. Veuillez réessayer plus tard."),
                actions: <Widget>[
                  TextButton(
                      child: const Text("OK"),
                      onPressed: () => Navigator.of(context).pop())
                ],
              );
            },
          );
          return;
        }

        try {
          await existingDoc.reference.update({
            'gift': vipGift,
            'status': 'normal',
          });

          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => EcranLoterie(docId: existingDoc.id)),
          ).then((_) {
            // Clear fields and request focus
            phoneController.clear();
            nomController.clear();
            prenomController.clear();
            phoneFocusNode.requestFocus();
          });
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text("Échec de la mise à jour des données : $e"),
                backgroundColor: Colors.red),
          );
        }
      }
    } else {
      final randomGift = await fetchRandomGift(isVip: false);
      if (randomGift == null) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Aucun cadeau disponible"),
              content: const Text(
                  "Tous les cadeaux sont en rupture de stock. Veuillez réessayer plus tard."),
              actions: <Widget>[
                TextButton(
                    child: const Text("OK"),
                    onPressed: () => Navigator.of(context).pop())
              ],
            );
          },
        );
        return;
      }

      try {
        DocumentReference docRef = await contacts.add({
          'phone': phone,
          'nom': nom,
          'prenom': prenom,
          'gift': randomGift,
          'status': 'normal',
        });

        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => EcranLoterie(docId: docRef.id)),
        ).then((_) {
          // Clear fields and request focus
          phoneController.clear();
          nomController.clear();
          prenomController.clear();
          phoneFocusNode.requestFocus();
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("Échec de l'enregistrement des données : $e"),
              backgroundColor: Colors.red),
        );
      }
    }
  }
}
