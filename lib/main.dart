import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:nadif/modal/annonce_model.dart';
import 'package:nadif/provider/provider_auth.dart';
import 'package:nadif/screens/onBoardingScreen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider<AnnonceModel>(create: (_) => AnnonceModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: OnboardingScreen(),
      ),
    );
  }
}
