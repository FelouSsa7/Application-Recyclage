import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:nadif/controller/location_controller.dart';
import 'package:nadif/controller/location_withMarker.dart';
import 'package:latlong2/latlong.dart';

import 'detail_drawer/detail_drivers.dart';

class CartonScreen extends StatelessWidget {
  const CartonScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.tealAccent,
        title: const Text('Carton Screen'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance.collection('fournisseur').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Une erreur s\'est produite');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          final fournisseurs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: fournisseurs.length,
            itemBuilder: (BuildContext context, int index) {
              final fournisseur =
                  fournisseurs[index].data() as Map<String, dynamic>;
              final fournisseurId = fournisseurs[index].id;

              return Card(
                elevation: 4,
                margin: const EdgeInsets.all(8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  child: ListTile(
                    title: Text(
                      fournisseur['name'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      fournisseur['phoneNumber'],
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(fournisseur['profilePic']),
                    ),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Dialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Center(child: Text('Annonces')),
                                  const SizedBox(height: 16),
                                  SingleChildScrollView(
                                    child: FutureBuilder<QuerySnapshot>(
                                      future: FirebaseFirestore.instance
                                          .collection('Annonce')
                                          .where('annonceId',
                                              isEqualTo:
                                                  fournisseur['phoneNumber'])
                                          .where('dechetType',
                                              isEqualTo: 'Carton')
                                          .get(),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<QuerySnapshot>
                                              snapshot) {
                                        if (snapshot.hasError) {
                                          return const Text(
                                              'Une erreur s\'est produite');
                                        }

                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const CircularProgressIndicator();
                                        }

                                        final annonces = snapshot.data!.docs;

                                        if (annonces.isEmpty) {
                                          return const Text(
                                              'Aucune annonce disponible pour ce fournisseur');
                                        }

                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: annonces
                                              .map((DocumentSnapshot document) {
                                            Map<String, dynamic> annonce =
                                                document.data()
                                                    as Map<String, dynamic>;

                                            return Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: Colors.grey,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              padding: const EdgeInsets.all(8),
                                              margin: const EdgeInsets.only(
                                                bottom: 8,
                                              ),
                                              child: ListTile(
                                                title: Text(
                                                  'Annonce ID: ${annonce['annonceId']}',
                                                ),
                                                subtitle: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Localisation: ${annonce['location']}',
                                                    ),
                                                    Text(
                                                      'Type de déchet: ${annonce['dechetType']}',
                                                    ),
                                                    Text(
                                                      'Description: ${annonce['description']}',
                                                    ),
                                                    const SizedBox(height: 16),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        ElevatedButton(
                                                          onPressed: () {
                                                            showDialog(
                                                              context: context,
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                return AlertDialog(
                                                                  title: const Text(
                                                                      'Confirmation'),
                                                                  content:
                                                                      const Text(
                                                                          'Vous avez une moyenne de transport ?'),
                                                                  actions: [
                                                                    TextButton(
                                                                      onPressed:
                                                                          () async {
                                                                        LocationController
                                                                            location =
                                                                            LocationController();
                                                                        final fournisseurLocationData =
                                                                            await location.getProviderLocation2();
                                                                        final achteurLocationData =
                                                                            await location.getAchteurLocation2();

                                                                        if (fournisseurLocationData !=
                                                                                null &&
                                                                            achteurLocationData !=
                                                                                null) {
                                                                          final fournisseurLatitude =
                                                                              double.parse(fournisseurLocationData['latitude'] ?? '0');
                                                                          final fournisseurLongitude =
                                                                              double.parse(fournisseurLocationData['longitude'] ?? '0');
                                                                          final achteurLatitude =
                                                                              double.parse(achteurLocationData['latitude'] ?? '0');
                                                                          final achteurLongitude =
                                                                              double.parse(achteurLocationData['longitude'] ?? '0');

                                                                          final fournisseurLocation = LatLng(
                                                                              fournisseurLatitude,
                                                                              fournisseurLongitude);
                                                                          final achteurLocation = LatLng(
                                                                              achteurLatitude,
                                                                              achteurLongitude);

                                                                          Navigator
                                                                              .push(
                                                                            context,
                                                                            MaterialPageRoute(
                                                                              builder: (context) => LocationWithMarker(
                                                                                fournisseurLocation: fournisseurLocation,
                                                                                achteurLocation: achteurLocation,
                                                                              ),
                                                                            ),
                                                                          );
                                                                        }
                                                                      },
                                                                      child: const Text(
                                                                          'Oui'),
                                                                    ),
                                                                    TextButton(
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.of(context)
                                                                            .push(
                                                                          MaterialPageRoute(
                                                                            builder: (context) =>
                                                                                AnnonceListePageChauffeur(),
                                                                          ),
                                                                        );
                                                                      },
                                                                      child: const Text(
                                                                          'Non'),
                                                                    ),
                                                                  ],
                                                                );
                                                              },
                                                            );
                                                          },
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            backgroundColor:
                                                                Colors
                                                                    .greenAccent,
                                                          ),
                                                          child: const Text(
                                                              'Accepter'),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
