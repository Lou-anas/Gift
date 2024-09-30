import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:gift/auth/signup.dart';
import 'package:gift/screens/admin/admin.dart';
import 'package:gift/screens/infopage.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();

  void _login() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    if (!EmailValidator.validate(email)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Veuillez entrer une adresse e-mail valide."),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    if (password.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Le mot de passe ne peut pas être vide."),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    try {
      // Connexion de l'utilisateur avec Firebase Auth
      final userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Récupérer l'UID de l'utilisateur connecté
      String uid = userCredential.user!.uid;

      // Vérifier si l'utilisateur est un administrateur en interrogeant Firestore
      final admin = FirebaseFirestore.instance.collection('admin');
      final querySnapshot = await admin.where('email', isEqualTo: email).get();

      if (!mounted) return; // Vérifiez si le widget est toujours monté

      if (querySnapshot.docs.isNotEmpty) {
        // L'utilisateur est un administrateur
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => AdminScreen()),
        );
      } else {
        // L'utilisateur n'est pas un administrateur, naviguer vers InfoScreen avec UID
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => InfoScreen(uid: uid)),
        );
      }

      // Effacer les champs et refocaliser
      _emailController.clear();
      _passwordController.clear();
      _emailFocusNode.requestFocus();
    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'user-not-found') {
        message = "Aucun utilisateur trouvé avec cet e-mail.";
      } else if (e.code == 'wrong-password') {
        message = "Mot de passe incorrect.";
      } else {
        message = "Échec de la connexion. Veuillez réessayer.";
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 220, 0, 25),
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isTablet = constraints.maxWidth > 600;
          // double fontSize = isTablet ? 40 : 32;
          double padding = isTablet ? 30 : 20;

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: padding),
            child: Center(
              child: SingleChildScrollView(
                child: Flex(
                  direction: Axis.vertical,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: isTablet ? 200 : 100,
                      child: Image.asset('assets/logo1.png'),
                    ),
                    const SizedBox(height: 20),
                    ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 400),
                      child: _buildTextField(
                          "Email", Icons.email, _emailController),
                    ),
                    const SizedBox(height: 20),
                    ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 400),
                      child: _buildTextField(
                          "Mot de passe", Icons.lock, _passwordController),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 255, 255, 255),
                        padding: EdgeInsets.symmetric(
                          horizontal: isTablet ? 70 : 50,
                          vertical: 15,
                        ),
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      child: const Text(
                        "Se connecter",
                        style: TextStyle(color: Color(0xFFB90000)),
                      ),
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignupScreen()),
                        ); // Naviguer vers l'écran d'inscription
                      },
                      child: const Text(
                        "Vous n'avez pas de compte ? Inscrivez-vous",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextField(
      String labelText, IconData icon, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(color: Color(0xFFFFFFFF)),
        prefixIcon: Icon(icon, color: Color(0xFFFFFFFF)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: Color(0xFFFFFFFF)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: Color(0xFFFFFFFF)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: Color(0xFFFFFFFF), width: 2.0),
        ),
      ),
      style: const TextStyle(color: Color(0xFFFFFFFF)),
    );
  }
}
