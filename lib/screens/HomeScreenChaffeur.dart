import 'package:flutter/material.dart';
import 'package:nadif/screens/drawerScreenChauffeur.dart';
import 'package:nadif/screens/qr_code_scanner.dart';

import 'cart_geolocalisaton.dart';

class HomeScreenChauffeur extends StatefulWidget {
  const HomeScreenChauffeur({super.key});

  @override
  State<HomeScreenChauffeur> createState() => _HomeScreenChauffeurState();
}

class _HomeScreenChauffeurState extends State<HomeScreenChauffeur> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bienvenue Chauffeur'),
        centerTitle: true,
        backgroundColor: Colors.tealAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.scanner),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const QrCodeScanner(),
                ),
              );
            },
          ),
        ],
      ),
      drawer: const DrawerScreenChauffeur(),
      body: const MyCard(),
    );
  }
}
