// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:store/models/prodect_model.dart';
import 'package:store/service/get_all_product_serive.dart';
import 'package:store/widget/custom_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  static String id = 'homePage';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              // Action for the cart icon
            },
            icon: Icon(Icons.shopping_cart, color: Colors.black),
          ),
        ],
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        elevation: 0,
        centerTitle: true,
        title: Text(
          'New Trend',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.only(top: 5, left: 1, right: 1),
        child: FutureBuilder<List<Product_model>>(
          future: GetAllProductSerive().getallproduct(),

          builder: (context, snaptshot) {
            if (snaptshot.connectionState == ConnectionState.waiting) {
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 1.4,
                  crossAxisSpacing: 0.1,
                  childAspectRatio: 1, // Adjust aspect ratio as needed
                ),

                itemBuilder: (context, index) {
                  return CustomCard(
                    product: Product_model(
                      id: '',
                      title: 'Loading...',
                      description: '',
                      price: 0.0,
                      imageUrl:
                          'https://fakestoreapi.com/img/81fPKd-2AYL._AC_SL1500_.jpg',
                      rating: rating_model(rate: 0.0, count: 0),
                    ),
                  );
                },
              );
            }
            if (snaptshot.hasError) {
              return Center(child: Text('Error: ${snaptshot.error}'));
            }
            // Add a default return for when data is loaded
            if (snaptshot.hasData) {
              final products = snaptshot.data!;
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 1.4,
                  crossAxisSpacing: 0.1,
                  childAspectRatio: 1,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  return CustomCard(product: products[index]);
                },
              );
            }
            // Fallback widget
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
