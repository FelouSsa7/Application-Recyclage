import 'package:flutter/material.dart';
import 'package:nadif/screens/ouail_screen.dart/detail_drawer/detail_drawer.dart';
import 'package:nadif/widgets/custom_button.dart';

import 'annonce.dart';

class HomeScreenFournisseur extends StatefulWidget {
  const HomeScreenFournisseur({super.key});

  @override
  State<HomeScreenFournisseur> createState() => _HomeScreenFournisseurState();
}

class _HomeScreenFournisseurState extends State<HomeScreenFournisseur> {
  DateTime? selectedDate;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Fournisseur Home page '),
          backgroundColor: Colors.tealAccent,
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.calendar_today),
              onPressed: () {
                _selectDate(context);
              },
            ),
          ],
        ),
        drawer: const DrawerScreen(),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 30),
              padding: const EdgeInsets.all(25),
              child: const Image(
                image: AssetImage('assets/Images/annonce2.png'),
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            const Text(
              "Il vous reste quelques étapes à suivre ",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 50,
            ),
            CustomButton(
                text: "Créer une Annonce",
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const Annonce()));
                })
          ],
        ));
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime
          .now(), //: la date initiale affichée lorsque la boîte de dialogue de sélection de date est ouverte.
      firstDate: DateTime.now(), //la date minimale pouvant être sélectionnée
      lastDate: DateTime.now().add(const Duration(
          days: 365)), // la date maximale pouvant être sélectionnée.
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.greenAccent,
            buttonTheme:
                const ButtonThemeData(textTheme: ButtonTextTheme.primary),
            colorScheme: const ColorScheme.light(primary: Colors.greenAccent)
                .copyWith(secondary: Colors.greenAccent),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });

      // Récupérez le jour de la semaine sélectionné
      final String dayOfWeek = _getDayOfWeek(selectedDate!);

      // Affichez le type de collecte en fonction du jour de la semaine
      String collectionType = '';
      switch (dayOfWeek) {
        case 'Sunday':
        case 'Monday':
          collectionType = 'Collecte Plastique';
          break;
        case 'Tuesday':
        case 'Wednesday':
          collectionType = 'Collecte Carton';
          break;
        case 'Thursday':
          collectionType = 'Collecte Métal';
          break;
        case 'Friday':
        case 'Saturday':
          collectionType = 'Collecte de Tous les Déchets';
          break;
      }

      // Affichez le type de collecte sélectionné
      _showCollectionTypeDialog(collectionType);
    }
  }

  String _getDayOfWeek(DateTime date) {
    final weekdays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    final dayIndex = date.weekday - 1;
    return weekdays[dayIndex];
  }

  Future<void> _showCollectionTypeDialog(String collectionType) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Type de collecte'),
          content: Text(
              'Le jour sélectionné est pour la collecte de : $collectionType'),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
