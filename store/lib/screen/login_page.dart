// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:store/widget/widget_login.dart';

class LoginPage extends StatefulWidget {
  static String id = 'loginPage';

  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isChecking = true;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final user = FirebaseAuth.instance.currentUser;

    // تأخير بسيط لجعل الانتقال أكثر سلاسة
    await Future.delayed(const Duration(milliseconds: 500));

    if (user != null && user.emailVerified) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      setState(() => isChecking = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: isChecking
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Checking login status...'),
                ],
              ),
            )
          : const WidgetLogin(),
    );
  }
}
