import 'package:flutter/material.dart';
import 'package:store/screen/home_page.dart';

void main() {
  runApp(Store());
}

class Store extends StatelessWidget {
  const Store({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {HomePage.id: (context) => const HomePage()},
      initialRoute: HomePage.id,
    );
  }
}
