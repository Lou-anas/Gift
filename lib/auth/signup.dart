import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:gift/auth/login.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _telController = TextEditingController();
  final TextEditingController _villeController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();

  bool _isLoading = false; // State for loading indicator

  void _register() async {
    final email = _emailController.text;
    final fullname = _fullNameController.text;
    final tel = _telController.text;
    final ville = _villeController.text;
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (!EmailValidator.validate(email)) {
      _showErrorSnackBar("Please enter a valid email address.");
      return;
    }

    if (password.isEmpty || confirmPassword.isEmpty) {
      _showErrorSnackBar("Password fields cannot be empty.");
      return;
    }

    if (password != confirmPassword) {
      _showErrorSnackBar("Passwords do not match.");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Register the user with Firebase Auth
      final userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Get the user ID (UID) of the newly created user
      final userId = userCredential.user?.uid;

      if (userId != null) {
        final workers = FirebaseFirestore.instance.collection('workers');

        // Add worker details to Firestore
        await workers.doc(userId).set({
          'uid': userId,
          'email': email,
          'fullname': fullname,
          'phone': tel,
          'city': ville,
          'created_at': FieldValue.serverTimestamp(),
        });

        // Retrieve all gifts from the 'giftlist' collection
        final giftlistSnapshot =
            await FirebaseFirestore.instance.collection('giftlist').get();

        // Copy each gift from 'giftlist' to the worker's 'giftlist' sub-collection
        for (var gift in giftlistSnapshot.docs) {
          await workers.doc(userId).collection('giftlistworker').add({
            'name': gift['name'],
            'image': gift['image'],
            'stock': gift['stock'],
            'type': gift['type'],
          });
        }

        // Navigate to the login screen after successful registration
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      }

      // Clear input fields and reset focus
      _fullNameController.clear();
      _emailController.clear();
      _telController.clear();
      _villeController.clear();
      _passwordController.clear();
      _confirmPasswordController.clear();
      _emailFocusNode.requestFocus();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        _showErrorSnackBar('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        _showErrorSnackBar('The account already exists for that email.');
      } else {
        _showErrorSnackBar('Registration failed. Please try again.');
      }
    } catch (e) {
      _showErrorSnackBar("An error occurred. Please try again.");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 220, 0, 25), // Bright Scarlet
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 200,
                  child: Image.asset('assets/logo1.png'),
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  controller: _fullNameController,
                  label: "Full Name",
                  icon: Icons.person,
                  isPassword: false,
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  controller: _emailController,
                  label: "Email",
                  icon: Icons.email,
                  isPassword: false,
                  focusNode: _emailFocusNode,
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  controller: _telController,
                  label: "Phone",
                  icon: Icons.phone,
                  isPassword: false,
                  keyboardType: TextInputType
                      .number, // Add this to restrict to numeric input
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  controller: _villeController,
                  label: "ville",
                  icon: Icons.location_city,
                  isPassword: false,
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  controller: _passwordController,
                  label: "Password",
                  icon: Icons.lock,
                  isPassword: true,
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  controller: _confirmPasswordController,
                  label: "Confirm Password",
                  icon: Icons.lock_outline,
                  isPassword: true,
                ),
                const SizedBox(height: 30),
                _isLoading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _register,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white, // Button color
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50, vertical: 15),
                          textStyle: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        child: const Text(
                          "Sign Up",
                          style: TextStyle(
                            color:
                                Color.fromARGB(255, 220, 0, 25), // Text color
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required bool isPassword,
    FocusNode? focusNode,
    TextInputType keyboardType =
        TextInputType.text, // Add keyboardType with default value
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      focusNode: focusNode,
      keyboardType: keyboardType, // Apply the keyboardType here
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          color: Colors.white, // Label text color
        ),
        prefixIcon: Icon(
          icon,
          color: Colors.white, // Icon color
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
            color: Colors.white, // Border color
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
            color: Colors.white, // Enabled border color
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
            color: Colors.white, // Focused border color
            width: 2.0,
          ),
        ),
      ),
      style: const TextStyle(
        color: Colors.white, // Input text color
      ),
    );
  }
}
