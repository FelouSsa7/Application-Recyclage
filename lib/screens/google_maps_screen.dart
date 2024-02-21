import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../modal/annonce_model.dart';

class FournisseurCurrentLocation extends StatefulWidget {
  final String? currentLocation;

  const FournisseurCurrentLocation({Key? key, this.currentLocation})
      : super(key: key);

  @override
  FournisseurCurrentLocationState createState() =>
      FournisseurCurrentLocationState();
}

class FournisseurCurrentLocationState
    extends State<FournisseurCurrentLocation> {
  LatLng? currentLocationLatLng;

  @override
  void initState() {
    super.initState();
    getCurrentLocationFromFirebase();
  }

  Future<void> getCurrentLocationFromFirebase() async {
    try {
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Annonce')
          .limit(1) // Assuming you only have one document in the collection
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final DocumentSnapshot documentSnapshot = querySnapshot.docs[0];
        final data = documentSnapshot.data() as Map<String, dynamic>;

        final annonceModel = AnnonceModel.fromMap(data);
        final currentLocation = annonceModel.currentLocation;

        final parts = currentLocation!.split('+');
        if (parts.length == 2) {
          final latitude = double.parse(parts[0].trim());
          final longitude = double.parse(parts[1].trim());
          final result = LatLng(latitude, longitude);
          setState(() {
            currentLocationLatLng = result;
          });
        }
      }
    } catch (e) {
      print('Error retrieving current location: $e');
    }
  }

  void _showMarkerMessage(String name) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Marker info"),
          content: Text(name),
        );
      },
    );
  }

  LatLng customLocation =
      LatLng(36.9, 7.76667); // Exemple de coordonnées pour San Francisco

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fournisseur Current Location'),
      ),
      body: FlutterMap(
        options: MapOptions(
          center: customLocation,
          zoom: 13.0,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: const ['a', 'b', 'c'],
          ),
          MarkerLayer(
            markers: [
              Marker(
                width: 80.0,
                height: 80.0,
                point: customLocation,
                builder: (ctx) => GestureDetector(
                  onTap: () {
                    _showMarkerMessage("Fournisseur Location");
                  },
                  child: const Icon(
                    Icons.location_pin,
                    color: Colors.red,
                    size: 50,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
