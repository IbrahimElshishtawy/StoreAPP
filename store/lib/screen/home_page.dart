import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:store/features/auth/presentation/bloc/auth_state.dart';
import 'package:store/features/auth/presentation/bloc/auth_event.dart';
import 'package:store/features/products/presentation/bloc/product_bloc.dart';
import 'package:store/features/products/presentation/bloc/product_event.dart';
import 'package:store/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:store/features/cart/presentation/bloc/cart_state.dart';
import 'package:store/features/auth/domain/entities/user_entity.dart';
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

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Unauthenticated) {
          Navigator.pushReplacementNamed(context, '/login');
        }
      },
      builder: (context, state) {
        if (state is AuthLoading) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        if (state is Authenticated) {
          final user = state.user;
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
                      backgroundImage: (user.imageUrl != null && user.imageUrl!.isNotEmpty)
                          ? NetworkImage(user.imageUrl!)
                          : const AssetImage('assets/image/images.png') as ImageProvider,
                    ),
                    accountName: Text('${user.firstName} ${user.lastName}',
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    accountEmail: Text(user.email),
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
                              // Handle Profile Page
                            },
                          ),
                          const Divider(thickness: 1.2),
                          ListTile(
                            leading: const Icon(Icons.cloud_upload_outlined, color: Colors.green),
                            title: const Text('Upload Product'),
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.pushNamed(context, '/upload');
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.inventory_2_outlined, color: Colors.orange),
                            title: const Text('My Products'),
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.pushNamed(context, '/orders');
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.history, color: Colors.indigo),
                            title: const Text('Order History'),
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.push(context, MaterialPageRoute(builder: (_) => const OrderHistoryPage()));
                            },
                          ),
                          const Divider(thickness: 1.2),
                          ListTile(
                            leading: const Icon(Icons.logout, color: Colors.red),
                            title: const Text('Logout'),
                            onTap: () {
                              Navigator.pop(context);
                              context.read<AuthBloc>().add(LogoutRequested());
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
                style: TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
              ),
              actions: [
                 BlocBuilder<CartBloc, CartState>(
                  builder: (context, cartState) {
                    return Stack(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.shopping_cart, color: Colors.black),
                          onPressed: () => setState(() => currentIndex = 1),
                        ),
                        if (cartState.items.isNotEmpty)
                          Positioned(
                            right: 8,
                            top: 8,
                            child: CircleAvatar(
                              radius: 8,
                              backgroundColor: Colors.red,
                              child: Text(
                                cartState.items.length.toString(),
                                style: const TextStyle(fontSize: 10, color: Colors.white),
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ],
            ),
            body: IndexedStack(index: currentIndex, children: pages),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: currentIndex,
              onTap: (index) => setState(() => currentIndex = index),
              selectedItemColor: Colors.black,
              unselectedItemColor: Colors.grey,
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
                BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
                BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
              ],
            ),
          );
        }

        return const Scaffold(body: Center(child: Text('Please login')));
      },
    );
  }
}
