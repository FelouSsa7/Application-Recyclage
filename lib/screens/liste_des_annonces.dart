import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nadif/screens/home_ScreenFournisseur.dart';
import 'package:provider/provider.dart';
import '../controller/location_controller.dart';
import '../modal/annonce_model.dart';
import '../provider/provider_auth.dart';
import '../widgets/dialog_popup.dart';

class AnnonceListe extends StatefulWidget {
  final AnnonceModel annonce;
  const AnnonceListe({Key? key, required this.annonce}) : super(key: key);

  @override
  State<AnnonceListe> createState() => _AnnonceListeState();
}

class _AnnonceListeState extends State<AnnonceListe> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    return GetBuilder<LocationController>(
        init: LocationController(),
        builder: (controller) {
          final String userName = ap.userModal.name!;
          final String phoneNumber = ap.userModal.phoneNumber;
          return Scaffold(
            appBar: AppBar(
              leading: InkWell(
                child: const Icon(Icons.exit_to_app),
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const HomeScreenFournisseur())),
              ),
              title: const Text('Liste des annonces '),
            ),
            body: Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.greenAccent,
                  backgroundImage: NetworkImage(ap.userModal.profilePic),
                  radius: 50.0,
                ),
                title: Text('Fournisseur Name: $userName'),
                subtitle: Text('Phone number: $phoneNumber'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DialogPopup(
                        ap: ap,
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        });
  }
}
