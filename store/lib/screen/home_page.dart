// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:store/models/customs_userid.dart';
import 'package:store/screen/Search_page.dart';
import 'package:store/screen/cart_page_product.dart';
import 'package:store/screen/order_hostory_page.dart';
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

  final List<Widget> pages = const [ProductsPage(), CartPage(), SearchPage()];

  late Future<Map<String, dynamic>?> userFuture;
  final String? uid = FirebaseAuth.instance.currentUser?.uid;

  @override
  void initState() {
    super.initState();
    if (uid == null) {
      Future.microtask(() {
        Navigator.pushReplacementNamed(context, '/login');
      });
    } else {
      userFuture = getUserData();
    }
  }

  Future<Map<String, dynamic>?> getUserData() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();
      return doc.data();
    } catch (e) {
      debugPrint("Error fetching user data: $e");
      return null;
    }
  }

  void showToast(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: userFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError || snapshot.data == null) {
          return const Scaffold(
            body: Center(child: Text('⚠️ فشل تحميل بيانات المستخدم')),
          );
        }

        final userData = snapshot.data!;

        return Scaffold(
          drawer: Drawer(
            child: Column(
              children: [
                UserAccountsDrawerHeader(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.lightGreenAccent, Color(0xFF42A5F5)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  currentAccountPicture: CircleAvatar(
                    backgroundImage:
                        (userData['imageUrl'] != null &&
                            userData['imageUrl'].toString().isNotEmpty)
                        ? NetworkImage(userData['imageUrl'])
                        : const AssetImage('assets/image/images.png')
                              as ImageProvider,
                  ),
                  accountName: Text(
                    '${userData["firstName"]} ${userData["lastName"]}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  accountEmail: Text(userData["email"]),
                ),
                Expanded(
                  child: ListTileTheme(
                    iconColor: Colors.teal,
                    textColor: Colors.black87,
                    child: ListView(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.person_outline),
                          title: const Text('Profile'),
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ProfilePage(
                                  user: UserProfile(
                                    id: uid!,
                                    firstName: userData['firstName'],
                                    lastName: userData['lastName'],
                                    email: userData['email'],
                                    phone: userData['phone'],
                                    address: userData['address'],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        const Divider(thickness: 1.2),
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
                        ListTile(
                          leading: const Icon(
                            Icons.history,
                            color: Colors.indigo,
                          ),
                          title: const Text('Order History'),
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const OrderHistoryPage(),
                              ),
                            );
                          },
                        ),
                        const Divider(thickness: 1.2),
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
          body: IndexedStack(index: currentIndex, children: pages),
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
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: 'Search',
              ),
            ],
          ),
        );
      },
    );
  }
}
