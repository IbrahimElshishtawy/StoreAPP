import 'dart:async';
import 'package:flutter/material.dart';
import 'package:store/screen/login_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/image/images.png', width: 120, height: 120),
            const SizedBox(height: 20),
            const Text(
              "Store App",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 107, 107, 107),
              ),
            ),
            const SizedBox(height: 12),
            const CircularProgressIndicator(
              color: Color.fromARGB(255, 173, 190, 189),
            ),
          ],
        ),
      ),
    );
  }
}
