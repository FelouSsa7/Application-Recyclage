import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nadif/controller/location_controller.dart';
import 'package:nadif/modal/annonce_model.dart';
import 'package:nadif/modal/courseModel.dart';
import 'package:nadif/modal/user_modal.dart';
import 'package:http/http.dart' as http;
import 'package:nadif/provider/provider_auth.dart';
import 'package:nadif/utils/utils.dart';
import 'package:provider/provider.dart';

class AnnonceListePageChauffeur extends StatefulWidget {
  AnnonceListePageChauffeur({super.key});

  @override
  State<AnnonceListePageChauffeur> createState() =>
      _AnnonceListePageChauffeurState();
}

class _AnnonceListePageChauffeurState extends State<AnnonceListePageChauffeur> {
  var serverToken =
      "AAAAj9PsFwk:APA91bHGq4oMJnUrAzEUCbIU6rveOpDUcg7BZAGqDO1FVZn8vs6am_M2nb6gFnTd9JXhS7lFMJwYxW-ApLB3bSPgkCAc7NYa3XyCu4Vd4ns64eVhyClLgWSPLWvCiKV7OjmD7Jepbt6H";

  sendNotify(String title, String body, String providerLocation,
      String? buyerLocation) async {
    await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverToken',
      },
      body: jsonEncode(<String, dynamic>{
        "notification": <String, dynamic>{
          "body": body.toString(),
          "title": title.toString(),
        },
        "priority": "high",
        "data": <String, dynamic>{
          "click_action": "FLUTTER_NOTIFICATION_CLICK",
          "fournisseur_location": providerLocation,
          "achteur_location": buyerLocation ?? '',
        },
        "to": await FirebaseMessaging.instance.getToken()
      }),
    );
  }

  AnnonceModel? ap;

  getMessage() {
    FirebaseMessaging.onMessage.listen((message) {
      print("====================");
      print(message.notification?.title);
      print(message.notification?.body);
      print(message.data);
    });
  }

  @override
  void initState() {
    getMessage();
    super.initState();
  }

  LocationController location = LocationController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des Chauffeurs'),
        backgroundColor: Colors.tealAccent,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('chauffeur').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Erreur: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final chauffeurs = snapshot.data!.docs
              .map((doc) =>
                  UserModal.fromMap(doc.data() as Map<String, dynamic>))
              .toList();

          return ListView.builder(
            itemCount: chauffeurs.length,
            itemBuilder: (BuildContext context, int index) {
              final chauffeur = chauffeurs[index];

              return Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(chauffeur.profilePic),
                  ),
                  title: Text(
                    chauffeur.name!,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(
                        'Email: ${chauffeur.email}',
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Ntélé: ${chauffeur.phoneNumber}',
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Type de permis: ${chauffeur.permis ?? "N/A"}',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Dialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Text(
                                  'Détails du chauffeur',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'Nom:',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          chauffeur.name!,
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'Email:',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          chauffeur.email,
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'Numéro de téléphone:',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          chauffeur.phoneNumber,
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'Type de permis:',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          chauffeur.permis ?? 'N/A',
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        MaterialButton(
                                          onPressed: () async {
                                            String? providerLocation =
                                                await location
                                                    .getCurrentLocationFromFirebase();
                                            String? buyerLocation =
                                                await location
                                                    .getAchteurLocation();
                                            await sendNotify(
                                              "Hello chauffeur",
                                              "Nouvelle adventure depechez vous",
                                              providerLocation ?? '',
                                              buyerLocation ?? '',
                                            );
                                            showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return Dialog(
                                                    insetPadding:
                                                        const EdgeInsets.all(
                                                            50),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    child: const Text(
                                                        "Votre annonce a été bien transférer chez le chauffeur"),
                                                  );
                                                });
                                            // await storeData();
                                          },
                                          child: const Text('Accepter'),
                                          color: Colors.greenAccent,
                                        ),
                                        MaterialButton(
                                          onPressed: () {},
                                          color: Colors.red,
                                          child: const Text("Annuler"),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> storeData() async {
    final ap = Provider.of<AuthProvider>(context, listen: false);

    // Use 'await' to get the location asynchronously
    await location.getCurrentLocation();
    await location.getAchteurLocation();
    await location.getCurrentLocationFromFirebase();

    CourseModel courseModel = CourseModel(
      fournisseurName: ap.userModal.name,
      localisationAchteur: location.currentLocation ?? '',
      localisationFournisseur: location.currentLocation ?? '',
      annonceId: ap.annonceModel?.annonceId ?? '', // Use null-aware operator
    );

    if (ap.annonceModel != null) {
      // Use 'await' to wait for the completion of saveCourseDataToFirebase
      await ap.saveCourseDataToFirebase(
        courseModel: courseModel,
        onSuccess: () {
          ap.saveCourseDataToSP();
        },
        context: context,
        annonceModel: ap.annonceModel!,
        locationController: location,
      );
    } else {
      showSnackBar(context, "Please upload your product pic");
    }
  }
}
