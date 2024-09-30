import 'package:flutter/material.dart';
import 'package:gift/screens/scratch.dart';

class EcranLoterie extends StatelessWidget {
  final String docId;

  EcranLoterie({required this.docId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Image de fond
          Positioned.fill(
            child: Image.asset(
              'assets/background.jpeg',
              fit: BoxFit.cover,
            ),
          ),
          // Couleur de fond semi-transparente
          Container(
            color: const Color.fromRGBO(229, 57, 53, 0.7),
          ),
          // Contenu
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Souhaitez-vous tenter votre\nchance à la grande loterie ?',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Gagnez des prix incroyables en un seul clic !',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Bouton accepter
                    IconButton(
                      icon: const Icon(Icons.check_circle,
                          size: 80, color: Colors.white),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ScratchCardPage(docId: docId)),
                        );
                      },
                    ),
                    const SizedBox(width: 20),
                    // Bouton refuser
                    IconButton(
                      icon: const Icon(Icons.cancel,
                          size: 80, color: Colors.white),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ScratchCardPage(docId: docId)),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
