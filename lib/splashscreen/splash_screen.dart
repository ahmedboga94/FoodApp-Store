import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../mainscreen/home_screen.dart';
import '../authentication/auth_screen.dart';

class SplashScreen extends StatefulWidget {
  static String id = "splashScreen";
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  startTimer() {
    if (FirebaseAuth.instance.currentUser != null) {
      Future.delayed(const Duration(seconds: 4), () {
        Navigator.of(context).pushReplacementNamed(HomeScreen.id);
      });
    } else {
      Future.delayed(const Duration(seconds: 4),
          () => Navigator.of(context).pushReplacementNamed(AuthScreen.id));
    }
  }

  static const SystemUiOverlayStyle overlayStyle = SystemUiOverlayStyle(
      systemStatusBarContrastEnforced: false,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
      statusBarColor: Colors.transparent);

  @override
  void initState() {
    startTimer();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SystemChrome.setSystemUIOverlayStyle(overlayStyle);
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge,
          overlays: [SystemUiOverlay.top]);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          colors: [
            Colors.amber,
            Colors.cyan,
          ],
        )),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Image.asset("assets/images/welcome.png")),
              const SizedBox(height: 10),
              const Text(
                "Order Food Online",
                style: TextStyle(
                    color: Colors.black54,
                    fontSize: 30,
                    fontFamily: "TrainOne",
                    letterSpacing: 2),
              )
            ],
          ),
        ),
      ),
    );
  }
}
