import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class AnnonceModel with ChangeNotifier {
  String? dechetType;
  String? description;
  String? annonceId;
  String? productPic;
  String? location;
  String? currentLocation;

  AnnonceModel({
    this.description,
    this.annonceId,
    this.productPic,
    this.location,
    this.dechetType,
    this.currentLocation,
  });

  //to map

  factory AnnonceModel.fromMap(Map<String, dynamic> map) {
    return AnnonceModel(
      dechetType: map['selectedOption'],
      description: map['description'] ?? '',
      annonceId: map['annonceId'] ?? '',
      productPic: map['productPic'] ?? '',
      currentLocation: map['currentLocation'] ?? '',
      location: map['location'] ?? '',
    );
  }
  Map<String, dynamic> toMap1() {
    return {
      'dechetType': dechetType,
      'description': description,
      'annonceId': annonceId,
      'productPic': productPic,
      'location': location,
      'currentLocation': currentLocation,
    };
  }
}
