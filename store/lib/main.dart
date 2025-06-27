// ignore_for_file: unused_local_variable

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store/models/customs_userid.dart';
import 'package:store/screen/cart_page_product.dart';
import 'package:store/screen/edit_profile_page.dart';
import 'package:store/screen/home_page.dart';
import 'package:store/screen/login_page.dart';
import 'package:store/screen/my_products_page.dart';
import 'package:store/screen/profile_page.dart';
import 'package:store/screen/rgister_page.dart';
import 'package:store/screen/upload_product_page.dart';
import 'package:store/widget/items_cart_product.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const Store());
}

class Store extends StatelessWidget {
  const Store({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => CartProvider())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/login',
        routes: {
          '/login': (context) => const LoginPage(),
          '/register': (context) => const RegisterPage(),
          '/home': (context) => const HomePage(),
          '/upload': (context) => const UploadProductPage(),
          '/cart': (context) => const CartPage(),
          '/orders': (context) => const MyProductsPage(),
        },
        onGenerateRoute: (settings) {
          if (settings.name == '/editProfile') {
            final user = settings.arguments as UserProfile;
            return MaterialPageRoute(
              builder: (_) => EditProfilePage(user: user),
            );
          }
          return null;
        },
      ),
    );
  }
}
