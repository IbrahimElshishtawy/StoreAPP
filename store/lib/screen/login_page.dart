import 'package:flutter/material.dart';
import 'package:store/widget/widget_login.dart';

class LoginPage extends StatefulWidget {
  static String id = 'loginPage';

  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(backgroundColor: Colors.white, body: LoginPage());
  }
}
