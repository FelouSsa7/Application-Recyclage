import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlng/latlng.dart';

import '../modal/annonce_model.dart';

class LocationController extends GetxController {
  Position? currentPosition;
  var isLoading = false.obs;
  String? currentLocation;
  AnnonceModel? annonceModel;

  final locationController = TextEditingController();
  final descriptionController = TextEditingController();

  Future<Position> getPosition() async {
    LocationPermission? permission;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission == await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error("Permission Location are denied");
      }
    }
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
  }

  Future<void> getAddressFromLatLng(long, lat) async {
    try {
      List<Placemark> placemark = await placemarkFromCoordinates(lat, long);

      Placemark place = placemark[0];

      currentLocation =
          "${place.locality} , ${place.street}, ${place.subLocality} , ${place.subAdministrativeArea}";
      update();
    } catch (e) {
      print(e);
    }
  }

  //  Card(
  //   child: Padding(
  //     padding: const EdgeInsets.all(16.0),
  //     child: Text(
  //       "${location.isNotEmpty ? location.first.country ?? "" : ""},${location.isNotEmpty ? location.first.locality ?? "" : ""},${location.isNotEmpty ? location.first.thoroughfare ?? location.first.name ?? "" : ""}",
  //       style: const TextStyle(fontWeight: FontWeight.bold),
  //     ),
  //   ),
  // ),

  Future<void> getCurrentLocation() async {
    try {
      isLoading.value = true;
      update();
      currentPosition = await getPosition();
      getAddressFromLatLng(
          currentPosition!.longitude, currentPosition!.latitude);
      if (currentLocation != null) {
        annonceModel = AnnonceModel(currentLocation: currentLocation!);
      }
      isLoading.value = false;
      update();
    } catch (e) {
      print(e);
    }
  }

  Future<String?> getProviderLocation() async {
    currentPosition = await getPosition();
    await getAddressFromLatLng(
      currentPosition!.longitude,
      currentPosition!.latitude,
    );

    return currentLocation;
  }

  Future<Map<String, String>?> getProviderLocation2() async {
    Position position = await Geolocator.getCurrentPosition();
    return {
      'latitude': position.latitude.toString(),
      'longitude': position.longitude.toString(),
    };
  }

  Future<String?> getAchteurLocation() async {
    currentPosition = await getPosition();
    await getAddressFromLatLng(
      currentPosition!.longitude,
      currentPosition!.latitude,
    );

    return currentLocation;
  }

  Future<Map<String, String>?> getAchteurLocation2() async {
    Position position = await Geolocator.getCurrentPosition();
    return {
      'latitude': position.latitude.toString(),
      'longitude': position.longitude.toString(),
    };
  }

  Future<void> showAnnonceDialogueAlert(BuildContext context, String name) {
    locationController.text = name;
    descriptionController.text = name;
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Modifier votre annonce : '),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: locationController,
                    onFieldSubmitted: (value) {},
                    keyboardType: TextInputType.text,
                    obscureText: false,
                    decoration: const InputDecoration(hintText: "Enter Name"),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Annuller"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Modifier"),
              ),
            ],
          );
        });
  }

  Future<String?> getCurrentLocationFromFirebase() async {
    try {
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Annonce')
          .limit(1) // Assuming you only have one document in the collection
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final DocumentSnapshot documentSnapshot = querySnapshot.docs[0];
        final data = documentSnapshot.data()
            as Map<String, dynamic>; // Explicitly cast to Map<String, dynamic>
        final annonceModel = AnnonceModel.fromMap(data);
        return annonceModel.currentLocation;
      }
    } catch (e) {
      print('Error retrieving current location: $e');
    }

    return null; // Return null if the location is not found or an error occurs
  }
}
