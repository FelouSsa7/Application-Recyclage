import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:nadif/modal/annonce_model.dart';
import 'package:nadif/modal/courseModel.dart';
import 'package:nadif/modal/user_modal.dart';
import 'package:nadif/screens/otp_screen.dart';
import 'package:nadif/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controller/location_controller.dart';

class AuthProvider extends ChangeNotifier {
  LocationController currentLocationController = LocationController();
  //for signIn verification
  bool _isSignedIn = false;

  bool get isSignedIn => _isSignedIn;

  //for Loading verification
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  String? _userId;

  String get userId => _userId!;

  String? _annonceId;

  String get annonceId => _annonceId!;

  UserModal? _userModal;
  UserModal get userModal => _userModal!;

  AnnonceModel? _annonceModel;
  AnnonceModel get annonceModel => _annonceModel!;

  CourseModel? _courseModel;
  CourseModel get courseModel => _courseModel!;

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  AuthProvider() {
    checkSign();
  }
// check SignIn Method
  void checkSign() async {
    final SharedPreferences e = await SharedPreferences.getInstance();
    _isSignedIn = e.getBool('is_signedIn') ?? false;
    notifyListeners();
  }

  Future setSignIn() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    s.setBool("is_signedIn", true);
    _isSignedIn = true;
    notifyListeners();
  }

  // SignInMethod

  void signInWithPhone(BuildContext context, String phoneNumber) async {
    try {
      await _firebaseAuth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted:
              (PhoneAuthCredential phoneAuthCredential) async {
            await _firebaseAuth.signInWithCredential(phoneAuthCredential);
          },
          verificationFailed: (error) {
            throw Exception(error.message);
          },
          codeSent: (verificationId, forceResendingToken) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OtpScreen(verificationId: verificationId),
              ),
            );
          },
          codeAutoRetrievalTimeout: (verificationId) {});
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message.toString());
    }
  }

//VerifyOtp
  void verifyOtp(
      {required BuildContext context,
      required String userOtp,
      required String verificationId,
      required Function onSuccess}) async {
    _isLoading = true;
    notifyListeners();
    try {
      PhoneAuthCredential crds = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: userOtp);
      User? user = (await _firebaseAuth.signInWithCredential(crds)).user!;

      if (user != null) {
        _userId = user.uid;
        onSuccess();
      }
      _isLoading = false;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message.toString());
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String> checkExistingUser() async {
    DocumentSnapshot fournisseurSnapshot =
        await _firebaseFirestore.collection("fournisseur").doc(_userId).get();

    DocumentSnapshot achteurSnapshot =
        await _firebaseFirestore.collection("achteur").doc(_userId).get();

    DocumentSnapshot chauffeurSnapshot =
        await _firebaseFirestore.collection("chauffeur").doc(_userId).get();

    if (fournisseurSnapshot.exists) {
      return 'fournisseur'; // User exists as a fournisseur
    } else if (achteurSnapshot.exists) {
      return 'achteur'; // User exists as an achteur
    } else if (chauffeurSnapshot.exists) {
      return 'chauffeur'; // User exists as a chauffeur
    } else {
      return 'new_user'; // User is new
    }
  }

  void saveUserDataToFirebase({
    required BuildContext context,
    required UserModal userModal,
    required Function onSuccess,
    required File profilePic,
    required String userType, // added userType parameter
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      // uploading image to firebase storage
      await storeFileToStorage("profilePick/$_userId", profilePic)
          .then((value) {
        userModal.profilePic = value;
        userModal.phoneNumber = _firebaseAuth.currentUser!.phoneNumber!;
        userModal.userId = _firebaseAuth.currentUser!.phoneNumber!;
      });
      _userModal = userModal;

      // save user data to the correct collection based on userType parameter
      await _firebaseFirestore
          .collection(
              userType) //  userType parameter to specify collection name
          .doc(_userId)
          .set(userModal.toMap())
          .then((value) {
        onSuccess();
        _isLoading = false;
        notifyListeners();
      });
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message.toString());
      _isLoading = false;
      notifyListeners();
    }
  }

  void saveAnnonceDataToFirebase({
    required BuildContext context,
    required AnnonceModel annonceModel,
    required Function onSuccess,
    required File productPic,
    required LocationController locationController,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Get the current location
      await currentLocationController.getCurrentLocation();

      // Set the location in the annonceModel
      annonceModel.currentLocation = locationController.currentLocation;

      // Uploading image to Firebase F
      String imageUrl = await storeFileToStorage(
        "productPick/$_annonceId",
        productPic,
      );
      annonceModel.productPic = imageUrl;
      annonceModel.annonceId = _firebaseAuth.currentUser!.phoneNumber!;
      _annonceModel = annonceModel;
      await _firebaseFirestore
          .collection('Annonce')
          .doc(_annonceId)
          .set(annonceModel.toMap1())
          .then((value) {
        onSuccess();
        _isLoading = false;
        notifyListeners();
      });
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message.toString());
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> saveCourseDataToFirebase({
    required BuildContext context,
    required AnnonceModel annonceModel,
    required CourseModel courseModel,
    required Function onSuccess,
    required LocationController locationController,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Get the current location

      // Set the location in the annonceModel
      courseModel.fournisseurName = userModal.name;
      courseModel.achteurName = userModal.name;
      courseModel.localisationAchteur =
          await currentLocationController.getAchteurLocation();
      courseModel.localisationFournisseur =
          await currentLocationController.getCurrentLocationFromFirebase();
      courseModel.annonceId = annonceModel.annonceId;
      _courseModel = courseModel;
      await _firebaseFirestore
          .collection('Course')
          .doc(_annonceId)
          .set(courseModel.toMap2())
          .then((value) {
        onSuccess();
        _isLoading = false;
        notifyListeners();
      });
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message.toString());
      _isLoading = false;
      notifyListeners();
    }
  }

  Future saveCourseDataToSP() async {
    CourseModel courseModel = CourseModel();
    SharedPreferences s = await SharedPreferences.getInstance();
    await s.setString(
      "course",
      jsonEncode(courseModel.toMap2()),
    );
  }

  Future<String> storeFileToStorage(String ref, File file) async {
    UploadTask uploadTask = _firebaseStorage.ref().child(ref).putFile(file);
    TaskSnapshot snapshot = await uploadTask;
    String downloadURL = await snapshot.ref.getDownloadURL();
    return downloadURL;
  }

  Future<void> getDataFromFirestore() async {
    try {
      final docFournisseur = await _firebaseFirestore
          .collection('fournisseur')
          .doc(_firebaseAuth.currentUser!.uid)
          .get();
      final docAchteur = await _firebaseFirestore
          .collection('achteur')
          .doc(_firebaseAuth.currentUser!.uid)
          .get();
      final docChauffeur = await _firebaseFirestore
          .collection('chauffeur')
          .doc(_firebaseAuth.currentUser!.uid)
          .get();

      if (docFournisseur.exists) {
        _userModal = UserModal(
          permis: '',
          name: docFournisseur['name'],
          email: docFournisseur['email'],
          phoneNumber: docFournisseur['phoneNumber'],
          userId: _firebaseAuth.currentUser!.uid,
          profilePic: docFournisseur['profilePic'],
        );
      } else if (docAchteur.exists) {
        _userModal = UserModal(
          name: docAchteur['name'],
          email: docAchteur['email'],
          permis: "",
          phoneNumber: docAchteur['phoneNumber'],
          userId: _firebaseAuth.currentUser!.uid,
          profilePic: docAchteur['profilePic'],
        );
      } else if (docChauffeur.exists) {
        _userModal = UserModal(
          name: docChauffeur['name'],
          email: docChauffeur['email'],
          phoneNumber: docChauffeur['phoneNumber'],
          permis: docChauffeur['permis'],
          userId: _firebaseAuth.currentUser!.uid,
          profilePic: docChauffeur['profilePic'],
        );
      } else {
        // user doesn't exist in either collection
        _userModal = null;
      }
    } catch (e) {
      // handle error
      print(e.toString());
    }
  }

  // Now to store data locally we need the sharedPrefences Package
  Future saveUserDataToSP() async {
    SharedPreferences s = await SharedPreferences.getInstance();
    await s.setString(
      "user modal",
      jsonEncode(userModal.toMap()),
    );
  }

  Future saveAnnonceDataToSP() async {
    SharedPreferences s = await SharedPreferences.getInstance();
    await s.setString(
      "annonce model",
      jsonEncode(annonceModel.toMap1()),
    );
  }

  Future getDataFromSP() async {
    SharedPreferences s = await SharedPreferences.getInstance();
    String data = s.getString('user modal') ?? '';
    _userModal = UserModal.fromMap(
      jsonDecode(data),
    );
    _userId = _userModal!.userId;
    notifyListeners();
  }

  Future<void> getAnnonceDataFromFirestore() async {
    try {
      final docAnnonce = await _firebaseFirestore
          .collection('annonce')
          .doc(_firebaseAuth.currentUser!.uid)
          .get();

      if (docAnnonce.exists) {
        _annonceModel = AnnonceModel(
          currentLocation: docAnnonce['currentLocation'],
          dechetType: docAnnonce['dechetType'],
          description: docAnnonce['descriptiion'],
          location: docAnnonce['location'],
          annonceId: _firebaseAuth.currentUser!.uid,
          productPic: docAnnonce['productPic'],
        );
      } else {
        // user doesn't exist in either collection
        _annonceModel = null;
      }
    } catch (e) {
      // handle error
      print(e.toString());
    }
  }

  Future<void> getAnnonceDataFromSP() async {
    SharedPreferences s = await SharedPreferences.getInstance();
    String data = s.getString('annonce model') ?? '';

    if (data.isNotEmpty) {
      Map<String, dynamic> jsonData = jsonDecode(data);
      _annonceModel = AnnonceModel.fromMap(jsonData);
      _annonceModel = annonceModel;
      notifyListeners();
    }
  }

  Future userSignOut() async {
    SharedPreferences s = await SharedPreferences.getInstance();
    await _firebaseAuth.signOut();
    _isLoading = false;
    notifyListeners();
    s.clear();
  }
}
// ElevatedButton(
// onPressed: () async {
// await ap.getAnnonceDataFromSP(context);
// },
// child: const Text("Voir les annonces:"),
// ),