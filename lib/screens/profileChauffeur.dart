import 'package:flutter/material.dart';

import 'package:nadif/provider/provider_auth.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ProfileScreen extends StatelessWidget {
  static const String routeName = '/profile';
  const ProfileScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    String userCode = '${ap.userModal.phoneNumber}';
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.tealAccent,
        title: const Text('Profil'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(height: 16),
              CircleAvatar(
                radius: 80,
                backgroundImage: NetworkImage(ap.userModal.profilePic),
              ),
              const SizedBox(height: 16),
              Text(
                ap.userModal.name!,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Card(
                child: ListTile(
                  leading: const Icon(
                    Icons.email,
                    color: Colors.greenAccent,
                  ),
                  title: Text(
                    ap.userModal.email,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Card(
                child: ListTile(
                  leading: const Icon(
                    Icons.phone,
                    color: Colors.greenAccent,
                  ),
                  title: Text(
                    ap.userModal.phoneNumber,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Card(
                child: ListTile(
                  leading: const Icon(
                    Icons.car_crash,
                    color: Colors.greenAccent,
                  ),
                  title: Text(
                    ap.userModal.permis!,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Card(
                child: Center(
                  child: QrImage(
                    data: userCode,
                    version: QrVersions.auto,
                    size: 200.0,
                    embeddedImageStyle:
                        QrEmbeddedImageStyle(size: const Size(70, 70)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Déconnexion'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
