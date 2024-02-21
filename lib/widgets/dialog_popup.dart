import 'package:flutter/material.dart';

import '../provider/provider_auth.dart';

class DialogPopup extends StatelessWidget {
  const DialogPopup({
    Key? key,
    required this.ap,
  }) : super(key: key);

  final AuthProvider ap;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Colors.tealAccent,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              padding: const EdgeInsets.all(10.0),
              child: const Text(
                "Ici vous pouvez voir toutes les informations concernant cette annonce:",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 17.0,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            Column(
              children: [
                const SizedBox(
                  height: 10.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.greenAccent,
                      backgroundImage: NetworkImage(
                        ap.annonceModel.productPic ?? "",
                      ),
                      radius: 60.0,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20.0,
                ),
                const Text(
                  'Nom:',
                  style: TextStyle(color: Colors.tealAccent, fontSize: 20.0),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Text(
                  ap.userModal.name ?? "",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                const Text(
                  'Numéro de téléphone:',
                  style: TextStyle(color: Colors.tealAccent, fontSize: 20.0),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Text(
                  ap.userModal.phoneNumber,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                const Text(
                  'Location:',
                  style: TextStyle(color: Colors.tealAccent, fontSize: 20.0),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Text(
                  ap.annonceModel.location ?? "",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                const Text(
                  'Type de déchet:',
                  style: TextStyle(color: Colors.tealAccent, fontSize: 20.0),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Text(
                  ap.annonceModel.dechetType ?? "",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                const Text(
                  'Description:',
                  style: TextStyle(color: Colors.tealAccent, fontSize: 20.0),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Text(
                  ap.annonceModel.description ?? "",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
