import 'package:flutter/material.dart';
import 'package:scratcher/scratcher.dart';
import 'package:confetti/confetti.dart';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';

class ScratchCardPage extends StatefulWidget {
  final String docId;
  final Color scratchBoxColor;
  final double scratchBoxWidth;
  final double scratchBoxHeight;

  ScratchCardPage({
    required this.docId,
    this.scratchBoxColor = const Color.fromARGB(255, 255, 255, 255),
    this.scratchBoxWidth = 250.0,
    this.scratchBoxHeight = 200.0,
  });

  @override
  _ScratchCardPageState createState() => _ScratchCardPageState();
}

class _ScratchCardPageState extends State<ScratchCardPage> {
  bool isScratched = false;
  String gift = '';
  bool isNetworkImage = false;
  late ConfettiController _confettiControllerLeft;
  late ConfettiController _confettiControllerRight;
  int _confettiPlayCount = 0;

  @override
  void initState() {
    super.initState();
    _confettiControllerLeft =
        ConfettiController(duration: const Duration(seconds: 2));
    _confettiControllerRight =
        ConfettiController(duration: const Duration(seconds: 2));
    _fetchGiftData();
  }

  @override
  void dispose() {
    _confettiControllerLeft.dispose();
    _confettiControllerRight.dispose();
    super.dispose();
  }

  Future<void> _fetchGiftData() async {
    try {
      DocumentReference docRef =
          FirebaseFirestore.instance.collection('contact').doc(widget.docId);
      DocumentSnapshot doc = await docRef.get();

      if (doc.exists) {
        setState(() {
          gift = doc['gift'];
          isNetworkImage = gift.startsWith('https');
        });
      }
    } catch (e) {
      print("Erreur lors de la récupération des données du cadeau : $e");
    }
  }

  Future<void> _reduceGiftStock(String giftImage) async {
    try {
      CollectionReference giftlist =
          FirebaseFirestore.instance.collection('giftlist');
      QuerySnapshot querySnapshot =
          await giftlist.where('image', isEqualTo: giftImage).get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot giftDoc = querySnapshot.docs.first;
        int currentStock = giftDoc['stock'];

        if (currentStock > 0) {
          await giftDoc.reference.update({
            'stock': FieldValue.increment(-1),
          });
          print("Stock réduit de 1 pour le cadeau : $giftImage");
        } else {
          print(
              "Le stock est déjà à 0 pour le cadeau : $giftImage, impossible de réduire davantage.");
        }
      } else {
        print(
            "Aucun cadeau correspondant trouvé dans la liste pour : $giftImage.");
      }
    } catch (e) {
      print("Erreur lors de la réduction du stock du cadeau : $e");
    }
  }

  Future<void> _decrementVipGiftStock() async {
    try {
      CollectionReference giftList =
          FirebaseFirestore.instance.collection('giftlist');
      QuerySnapshot vipGiftSnapshot =
          await giftList.where('type', isEqualTo: 'vip').get();

      if (vipGiftSnapshot.docs.isNotEmpty) {
        DocumentSnapshot vipGiftDoc = vipGiftSnapshot.docs.first;
        int currentStock = vipGiftDoc['stock'];

        if (currentStock > 0) {
          await vipGiftDoc.reference.update({
            'stock': currentStock - 1,
          });
          print('Stock du cadeau VIP réduit avec succès !');
        } else {
          print('Le cadeau VIP est en rupture de stock !');
        }
      } else {
        print('Cadeau VIP introuvable !');
      }
    } catch (e) {
      print('Erreur lors de la réduction du stock du cadeau VIP : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/lighting.png', // Remplacer par le chemin de votre image
              fit: BoxFit.cover,
            ),
            //  child: ParticleAnimation(),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Grattez pour Gagner !",
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 255, 255, 255)),
                ),
                const SizedBox(height: 60),
                ClipPath(
                  clipper: PolygonClipPath(),
                  child: Scratcher(
                    brushSize: 40,
                    threshold: 30,
                    color: widget.scratchBoxColor,
                    onChange: (value) {
                      if (value > 30 && !isScratched) {
                        setState(() {
                          isScratched = true;
                        });

                        if (_confettiPlayCount < 2) {
                          _confettiPlayCount++;
                          _confettiControllerLeft.play();
                          _confettiControllerRight.play();
                        }

                        // Afficher la boîte de dialogue lorsque le grattage est terminé
                        showDialog(
                          context: context,
                          builder: (context) {
                            return Stack(
                              alignment: Alignment.center,
                              children: [
                                AlertDialog(
                                  title: const Center(
                                    child: Text(
                                      "Félicitations !",
                                      style: TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromARGB(255, 220, 0, 25),
                                      ),
                                    ),
                                  ),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      gift.isNotEmpty
                                          ? (isNetworkImage
                                              ? Image.network(gift,
                                                  width:
                                                      150) // Définir la largeur de l'image
                                              : Image.asset(gift,
                                                  width:
                                                      150)) // Définir la largeur de l'image
                                          : const Text(
                                              "Aucun cadeau disponible"),
                                      const SizedBox(height: 10),
                                      const Text(
                                        'Vous avez gagné !',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500,
                                          color:
                                              Color.fromARGB(255, 220, 0, 25),
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                  actions: [
                                    ElevatedButton(
                                      onPressed: () async {
                                        CollectionReference giftlist =
                                            FirebaseFirestore.instance
                                                .collection('giftlist');

                                        try {
                                          QuerySnapshot querySnapshot =
                                              await giftlist
                                                  .where('image',
                                                      isEqualTo: gift)
                                                  .get();

                                          if (querySnapshot.docs.isNotEmpty) {
                                            DocumentSnapshot giftDoc =
                                                querySnapshot.docs.first;
                                            String giftType = giftDoc['type'];

                                            if (giftType == 'vip') {
                                              await _decrementVipGiftStock();
                                            } else {
                                              await _reduceGiftStock(gift);
                                            }

                                            Navigator.pop(context, true);
                                          } else {
                                            print(
                                                "Aucun cadeau correspondant trouvé avec l'image : $gift");
                                          }
                                        } catch (e) {
                                          print(
                                              "Erreur lors de la récupération du document du cadeau : $e");
                                        }
                                      },
                                      child: const Text(
                                        "OK",
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color:
                                              Color.fromARGB(255, 220, 0, 25),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                ConfettiWidget(
                                  confettiController: _confettiControllerLeft,
                                  blastDirection: pi / 2,
                                  particleDrag: 0.05,
                                  emissionFrequency: 0.05,
                                  numberOfParticles: 10,
                                  gravity: 0.1,
                                  shouldLoop: false,
                                ),
                                ConfettiWidget(
                                  confettiController: _confettiControllerRight,
                                  blastDirection: -pi / 2,
                                  particleDrag: 0.05,
                                  emissionFrequency: 0.05,
                                  numberOfParticles: 10,
                                  gravity: 0.1,
                                  shouldLoop: false,
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                    child: Container(
                      width: widget
                          .scratchBoxWidth, // Définir la largeur à partir de la propriété du widget
                      height: widget
                          .scratchBoxHeight, // Définir la hauteur à partir de la propriété du widget
                      color: Colors.grey[300],
                      child: Center(
                        child: gift.isNotEmpty
                            ? Image.network(gift,
                                fit: BoxFit
                                    .contain) // S'assurer que l'image s'adapte bien
                            : const Text("Aucune image disponible"),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 60),
                if (isScratched)
                  Positioned(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context, true);
                      },
                      child: const Text(
                        "Retour",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 220, 0, 25),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Découpe personnalisée pour la forme de la carte à gratter
class PolygonClipPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(size.width * 0.49, size.height * 0.35);
    path.lineTo(size.width * 0.98, size.height * 0.10);
    path.lineTo(size.width * 0.92, size.height * 0.91);
    path.lineTo(size.width * 0.49, size.height * 0.75);
    path.lineTo(size.width * 0.0, size.height * 0.91);
    path.lineTo(size.width * 0.08, size.height * 0.20);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
