// controllers.dart
import 'package:flutter/material.dart';

class AdminControllers {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController stockController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController newStockController = TextEditingController();
  final TextEditingController userPhoneController = TextEditingController();
  final TextEditingController nomController = TextEditingController();
  final TextEditingController prenomController = TextEditingController();
  final TextEditingController fullnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController cityController = TextEditingController();

  void dispose() {
    nameController.dispose();
    stockController.dispose();
    typeController.dispose();
    newStockController.dispose();
    userPhoneController.dispose();
    nomController.dispose();
    prenomController.dispose();
    fullnameController.dispose();
    emailController.dispose();
    cityController.dispose();
  }
}
