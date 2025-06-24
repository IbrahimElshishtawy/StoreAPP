import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:store/screen/login_page.dart'; // صفحة تسجيل الدخول
import 'package:store/screen/cart_page_product.dart';
import 'package:store/screen/home_page.dart';
import 'package:store/screen/updata_product_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const Store());
}

class Store extends StatelessWidget {
  const Store({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        LoginPage.id: (context) => const LoginPage(),
        HomePage.id: (context) => const HomePage(),
        UpdataProductPage.id: (context) => UpdataProductPage(),
        'cartPage': (context) => const CartPage(),
      },
      initialRoute: LoginPage.id,
    );
  }
}
