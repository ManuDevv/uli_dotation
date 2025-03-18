import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:uli_doation/screens/TableTeamScreen.dart';
import 'package:uli_doation/screens/login_screen.dart';
import 'package:uli_doation/screens/adminSceen.dart';

import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseAuth.instance.authStateChanges().listen((User? user) {
    if (user == null) {
      print('Non connecté');
      runApp(LoginScreen());
    } else {
      print('connecté');
      runApp(const MyApp());
    }
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'ULI dotation',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: SplashScreen());
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigation vers la page d'accueil après 3 secondes
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => test3()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text('Unité logistique Interne',style: TextStyle(color: Colors.white, fontSize: 50,fontWeight: FontWeight.bold),),
            Text('Dotation',style: TextStyle(color: Colors.white,fontSize: 30,fontWeight: FontWeight.bold),),
            // Ajoutez votre logo ici
            Container(
              padding: EdgeInsets.all(40),
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(colors: [
                   Color(0xfffea753),
              Color(0xfffb7045),
              Color(0xffed2b49),
              Color(0xffc01271),
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight)),
              
              child: Image.asset(
                'assets/images/logo_arcelor_transparent.png', color: Colors.white, // Assurez-vous d'ajouter votre logo dans le dossier assets
                width: 200,
                height: 200,
              ),
            ),
            const SizedBox(height: 20),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
