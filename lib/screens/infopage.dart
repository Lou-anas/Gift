import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gift/auth/disconnection.dart';
import 'package:gift/screens/phoneInputFormatter.dart';
import 'package:gift/screens/termsOfUse.dart';
import 'package:gift/services/infoPageService.dart';

class InfoScreen extends StatefulWidget {
  final String uid;

  InfoScreen({required this.uid});

  @override
  _InfoScreenState createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _prenomController = TextEditingController();
  final FocusNode _phoneFocusNode = FocusNode();

  bool _acceptedTerms = false;
  bool _isAdult = false; // New variable to track if the user is 18 or older

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 220, 0, 25),
      body: Stack(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              bool isTablet = constraints.maxWidth > 600;
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
                            child: Image.asset('assets/logo1.png')),
                        const SizedBox(height: 20),

                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 400),
                          child: _buildTextField(
                              "Téléphone", Icons.phone, _phoneController,
                              isPhone: true),
                        ),
                        const SizedBox(height: 20),
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 400),
                          child: _buildTextField(
                              "Nom", Icons.person, _nomController),
                        ),
                        const SizedBox(height: 20),
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 400),
                          child: _buildTextField(
                              "Prénom", Icons.person, _prenomController),
                        ),
                        const SizedBox(height: 20),

                      // Checkbox to check if user is 18 or older
                        Row(
                          mainAxisAlignment: MainAxisAlignment
                              .start, // Align content to the start
                          crossAxisAlignment: CrossAxisAlignment
                              .center, // Ensure text is aligned with checkbox
                          children: [
                            Checkbox(
                              value: _isAdult,
                              onChanged: (bool? value) {
                                setState(() {
                                  _isAdult = value ?? false;
                                });
                              },
                              activeColor: Colors.white,
                              checkColor: Colors.red,
                            ),
                            const Text(
                              "Je suis 18 ans ou plus",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),

                        // Checkbox for Terms of Use
                        Row(
                          mainAxisAlignment: MainAxisAlignment
                              .start, // Align content to the start
                          crossAxisAlignment: CrossAxisAlignment
                              .center, // Ensure text is aligned with checkbox
                          children: [
                            Checkbox(
                              value: _acceptedTerms,
                              onChanged: (bool? value) {
                                setState(() {
                                  _acceptedTerms = value ?? false;
                                });
                              },
                              activeColor: Colors.white,
                              checkColor: Colors.red,
                            ),
                            GestureDetector(
                              onTap: () =>
                                  Termsofuse.showTermsOfUseDialog(context),
                              child: const Text(
                                "J'accepte les conditions d'utilisation",
                                style: TextStyle(
                                  color: Colors.white,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            InfoPageService.saveToFirestore(
                              context,
                              _phoneController,
                              _nomController,
                              _prenomController,
                              _acceptedTerms,
                              _isAdult,
                              _phoneFocusNode,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 255, 255, 255),
                            padding: EdgeInsets.symmetric(
                                horizontal: isTablet ? 70 : 50, vertical: 15),
                            textStyle: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          child: const Text(
                            "Jouer !",
                            style: TextStyle(color: Color(0xFFB90000)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          const Positioned(
            top: 40,
            left: 10,
            child: DisconnectButton(),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
      String labelText, IconData icon, TextEditingController controller,
      {bool isPhone = false}) {
    return TextFormField(
      controller: controller,
      keyboardType: isPhone ? TextInputType.number : TextInputType.text,
      inputFormatters: isPhone
          ? <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly, // Only allows digits
              PhoneNumberInputFormatter(), // Custom formatter for 06/07 and length validation
            ]
          : null,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(color: Color(0xFFFFFFFF)),
        prefixIcon: Icon(icon, color: const Color(0xFFFFFFFF)),
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
