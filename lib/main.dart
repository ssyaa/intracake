import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intracake/screen/welcome_screen.dart';
import 'package:intracake/screen/home_screen.dart';

const firebaseOptions = FirebaseOptions(
  apiKey: "AIzaSyCxsJFvymOgpmXDSUmzt4D9t3CUMLMxUxY",
  authDomain: "intracake.firebaseapp.com",
  projectId: "intracake",
  storageBucket: "intracake.firebasestorage.app",
  messagingSenderId: "994105757694",
  appId: "1:994105757694:web:589c3dce7a159d1a01baaf",
  measurementId: "G-842HH8DHEQ",
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  if (kIsWeb) {
    await Firebase.initializeApp(options: firebaseOptions);
  } else {
    await Firebase.initializeApp();
  }

  runApp(const IntracakeApp());
}

class IntracakeApp extends StatelessWidget {
  const IntracakeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            return const HomeScreen();
          } else {
            return const WelcomeScreen();
          }
        },
      ),
    );
  }
}
