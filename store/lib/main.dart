import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:store/models/customs_userid.dart';
import 'package:store/screen/login_page.dart';
import 'package:store/screen/home_page.dart';
import 'package:store/screen/my_products_page.dart';
import 'package:store/screen/profile_page.dart';
import 'package:store/screen/rgister_page.dart';
import 'package:store/screen/upload_product_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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

        '/upload': (context) => const UploadProductPage(),
        '/orders': (context) => const MyProductsPage(), // ✅ لازم تضيف ده
      },
    );
  }
}
