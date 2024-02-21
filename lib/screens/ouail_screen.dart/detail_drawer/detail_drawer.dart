import 'package:flutter/material.dart';
import 'package:nadif/provider/provider_auth.dart';
import 'package:nadif/screens/cart_geolocalisaton.dart';
import 'package:nadif/screens/ouail_screen.dart/detail_drawer/detail_drivers.dart';
import 'package:nadif/screens/ouail_screen.dart/detail_drawer/detail_help.dart';
import 'package:nadif/screens/ouail_screen.dart/detail_drawer/detail_profile.dart';
import 'package:nadif/screens/qr_code_scanner.dart';
import 'package:nadif/screens/welcome_screen.dart';
import 'package:provider/provider.dart';

class DrawerScreen extends StatelessWidget {
  const DrawerScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    return Drawer(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 8, 54, 11),
              Color.fromARGB(255, 5, 13, 20),
            ],
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 50),
            ListTile(
              leading: const Icon(
                Icons.account_balance,
                color: Colors.white,
              ),
              title: const Text(
                'Profil',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ProfileScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.dashboard,
                color: Colors.white,
              ),
              title: const Text(
                'Tableau de bord',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const QrCodeScanner(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.drive_eta,
                color: Colors.white,
              ),
              title: const Text(
                'Liste des chauffeurs',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AnnonceListePageChauffeur(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.help,
                color: Colors.white,
              ),
              title: const Text(
                'Aide',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const HelpScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.map,
                color: Colors.white,
              ),
              title: const Text(
                'Carte',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const MyCard(),
                  ),
                );
              },
            ),
            Expanded(
              child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: ListTile(
                  leading: const Icon(
                    Icons.logout,
                    color: Colors.white,
                  ),
                  title: const Text(
                    'Déconnexion',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () async {
                    await ap.userSignOut().then(
                          (value) => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const WelcomeScreen(),
                            ),
                          ),
                        );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
