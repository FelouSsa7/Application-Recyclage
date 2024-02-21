import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nadif/screens/ouail_screen.dart/AutomotiveScreen.dart';
import 'package:nadif/screens/ouail_screen.dart/MetalScreen.dart';
import 'package:nadif/screens/ouail_screen.dart/PaperScreen.dart';
import 'package:nadif/screens/ouail_screen.dart/PlastiqueScreen.dart';
import '../../modal/user_modal.dart';

class HomeBody extends StatefulWidget {
  const HomeBody({Key? key}) : super(key: key);

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  final TextEditingController _searchController = TextEditingController();

  final List<String> categories = ['Plastique', 'Carton', 'Métal', 'Bois'];

  List<String> filteredCategories = [];

  void filterCategories(String query) {
    filteredCategories.clear();
    if (query.isNotEmpty) {
      for (String category in categories) {
        if (category.toLowerCase().contains(query.toLowerCase())) {
          filteredCategories.add(category);
        }
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          child: TextField(
            controller: _searchController,
            onChanged: (value) {
              filterCategories(value);
            },
            decoration: InputDecoration(
              hintText: 'Rechercher des catégories de recyclage',
              suffixIcon: const Icon(
                Icons.search,
                color: Colors.green,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: const BorderSide(color: Colors.green),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: const BorderSide(color: Colors.green),
              ),
            ),
          ),
        ),
        if (filteredCategories.isNotEmpty)
          SizedBox(
            height: 100,
            child: ListView.builder(
              itemCount: filteredCategories.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(filteredCategories[index]),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (BuildContext context) {
                      if (filteredCategories[index] == 'Plastique') {
                        return const PlastiqueScreen();
                      } else if (filteredCategories[index] == 'Bois') {
                        return const BoisScreen();
                      } else if (filteredCategories[index] == 'Métal') {
                        return const MetalScreen();
                      } else if (filteredCategories[index] == 'Carton') {
                        return const CartonScreen();
                      } else {
                        return Container();
                      }
                    }));
                  },
                );
              },
            ),
          ),
        const SizedBox(height: 10), // Ajout d'un espace vertical
        const Text(
          'Liste des fournisseurs :',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 50, 48, 48),
          ),
        ),
        const SizedBox(
          height: 10.0,
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            //
            stream: FirebaseFirestore.instance
                .collection('fournisseur')
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                          backgroundImage:
                              NetworkImage(fournisseur['profilePic']),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Center(child: Text('Annonces')),
                                      const SizedBox(height: 16),
                                      SingleChildScrollView(
                                        child: FutureBuilder<QuerySnapshot>(
                                          future: FirebaseFirestore.instance
                                              .collection('Annonce')
                                              .where('annonceId',
                                                  isEqualTo: fournisseur[
                                                      'phoneNumber'])
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

                                            final annonces =
                                                snapshot.data!.docs;

                                            if (annonces.isEmpty) {
                                              return const Text(
                                                  'Aucune annonce disponible pour ce fournisseur');
                                            }

                                            return Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: annonces.map(
                                                  (DocumentSnapshot document) {
                                                Map<String, dynamic> annonce =
                                                    document.data()
                                                        as Map<String, dynamic>;

                                                return Container(
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: Colors.grey),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  margin: const EdgeInsets.only(
                                                      bottom: 8),
                                                  child: ListTile(
                                                    title: Text(
                                                        'Annonce ID: ${annonce['annonceId']}'),
                                                    subtitle: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                            'Localisation: ${annonce['location']}'),
                                                        Text(
                                                            'Type de déchet: ${annonce['dechetType']}'),
                                                        Text(
                                                            'Description: ${annonce['description']}'),
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
        ),
        const SizedBox(height: 10), // Ajout d'un espace vertical
        const Text(
          'Liste des chauffeurs :',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 50, 48, 48),
          ),
        ),
        const SizedBox(
          height: 10.0,
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream:
                FirebaseFirestore.instance.collection('chauffeur').snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                              style:
                                                  const TextStyle(fontSize: 16),
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
                                              style:
                                                  const TextStyle(fontSize: 14),
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
                                              style:
                                                  const TextStyle(fontSize: 14),
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
                                              style:
                                                  const TextStyle(fontSize: 14),
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
        ),
      ],
    );
  }
}
