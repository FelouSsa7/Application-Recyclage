import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class CourseModel with ChangeNotifier {
  String? achteurName;
  String? fournisseurName;
  String? localisationFournisseur;
  String? localisationAchteur;
  String? annonceId;

  CourseModel({
    this.achteurName,
    this.annonceId,
    this.fournisseurName,
    this.localisationAchteur,
    this.localisationFournisseur,
  });

  //to map

  factory CourseModel.fromMap(Map<String, dynamic> map) {
    return CourseModel(
      achteurName: map['achteurName'],
      fournisseurName: map['fournisseurName'] ?? '',
      annonceId: map['annonceId'] ?? '',
      localisationAchteur: map['localisationAchteur'] ?? '',
      localisationFournisseur: map['localisationFournisseur'] ?? '',
    );
  }
  Map<String, dynamic> toMap2() {
    return {
      'achteurName': achteurName,
      'fournisseurName': fournisseurName,
      'annonceId': annonceId,
      'localisationAchteur': localisationAchteur,
      'localisationFournisseur': localisationFournisseur,
    };
  }
}
