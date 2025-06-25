// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:store/models/customs_userid.dart';
import 'package:store/screen/Search_page.dart';
import 'package:store/screen/cart_page_product.dart';
import 'package:store/screen/product_page.dart';
import 'package:store/screen/profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  static String id = 'homePage';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;
  Map<String, dynamic>? userData;

  final List<Widget> pages = [
    const ProductsPage(),
    const CartPage(),
    const SearchPage(),
  ];

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  Future<void> getUserData() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();
      if (doc.exists) {
        setState(() {
          userData = doc.data();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF0D47A1), Color(0xFF42A5F5)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              currentAccountPicture: const CircleAvatar(
                radius: 30,
                backgroundImage: AssetImage(
                  'assets/image/images.png',
                ), // ← غيّر حسب صورتك
              ),
              accountName: Text(
                userData != null
                    ? '${userData!["firstName"]} ${userData!["lastName"]}'
                    : 'Store App',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              accountEmail: Text(
                userData != null ? userData!["email"] : 'Welcome!',
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    leading: const Icon(
                      Icons.person_outline,
                      color: Colors.blue,
                    ),
                    title: const Text('Profile'),
                    onTap: () async {
                      Navigator.pop(context);
                      if (userData != null) {
                        final userProfile = UserProfile(
                          id: userData!['uid'],
                          firstName: userData!['firstName'],
                          lastName: userData!['lastName'],
                          email: userData!['email'],
                          phone: userData!['phone'],
                          address: userData!['address'],
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ProfilePage(user: userProfile),
                          ),
                        );
                      }
                    },
                  ),
                  const Divider(),

                  ListTile(
                    leading: const Icon(
                      Icons.cloud_upload_outlined,
                      color: Colors.green,
                    ),
                    title: const Text('Upload Product'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/upload');
                    },
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.inventory_2_outlined,
                      color: Colors.orange,
                    ),
                    title: const Text('My Products'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/orders');
                    },
                  ),
                  const Divider(),

                  ListTile(
                    leading: const Icon(Icons.logout, color: Colors.red),
                    title: const Text('Logout'),
                    onTap: () async {
                      Navigator.pop(context);
                      await FirebaseAuth.instance.signOut();
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'New Trend',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) => setState(() => currentIndex = index),
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
        ],
      ),
    );
  }
}
