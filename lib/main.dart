import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:cobaprojek1/firebase_options.dart';
import 'package:cobaprojek1/pages/auth/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AnimatedSplashScreen(
        splash: Text(
          "TabungKUY",
          style: GoogleFonts.poppins(
              fontSize: 34,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontStyle: FontStyle.italic),
        ),
        duration: 2000,
        backgroundColor: Color(0xff5B0888),
        splashTransition: SplashTransition.fadeTransition,
        nextScreen: LoginPage(),
      ),
      theme: ThemeData(primarySwatch: Colors.purple),
    );
  }
}
