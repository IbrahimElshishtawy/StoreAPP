import 'package:flutter/material.dart';
import 'package:store/screen/login_page.dart';
import 'package:store/screen/home_page.dart';
import 'package:store/screen/rgister_page.dart';

void main() {
  runApp(const Store());
}

class Store extends StatelessWidget {
  const Store({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/home': (context) => const HomePage(),
      },
    );
  }
}
