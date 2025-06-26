import 'package:flutter/material.dart';
import 'package:store/models/prodect_model.dart';
import 'package:store/service/get_all_product_serive.dart';
import 'package:store/widget/custom_card.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ProductModel>>(
      future: GetAllProductService().getAllProducts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final products = snapshot.data ?? [];
        if (products.isEmpty) {
          return const Center(child: Text('No products available'));
        }

        return GridView.builder(
          padding: const EdgeInsets.all(8),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 0.75,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];

            return CustomCard(
              product: product,
              title: product.title ?? 'No Title',
              price: product.price != null
                  ? '\$${product.price!.toStringAsFixed(2)}'
                  : 'No Price',
              image: product.imageUrl ?? '',
            );
          },
        );
      },
    );
  }
}
