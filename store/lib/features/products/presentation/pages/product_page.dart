import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/features/products/presentation/bloc/product_bloc.dart';
import 'package:store/features/products/presentation/bloc/product_event.dart';
import 'package:store/core/util/responsive_layout.dart';
import 'package:store/features/products/presentation/bloc/product_state.dart';
import 'package:store/presentation/widgets/custom_card.dart';
import 'package:store/presentation/widgets/empty_state.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  void _showReviewDialog(BuildContext context, String productId) {
    final commentController = TextEditingController();
    double rating = 5.0;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Rate Product'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      index < rating ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                    ),
                    onPressed: () => setState(() => rating = index + 1.0),
                  );
                }),
              ),
              TextField(
                controller: commentController,
                decoration: const InputDecoration(hintText: 'Write a review...'),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Thank you for your review!')),
                );
                Navigator.pop(context);
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    context.read<ProductBloc>().add(GetProductsRequested());
  }

  Widget _buildGrid(List products, int crossAxisCount) {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 0.75,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];

        return InkWell(
          onTap: () => _showReviewDialog(context, product.id.toString()),
          child: CustomCard(
            product: product,
            title: product.title,
            price: '\$${product.price.toStringAsFixed(2)}',
            image: product.image,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProductBloc, ProductState>(
      listener: (context, state) {
        if (state is ProductError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is ProductLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ProductError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 16),
                Text('Error: ${state.message}'),
                ElevatedButton(
                  onPressed: () => context.read<ProductBloc>().add(GetProductsRequested()),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        } else if (state is ProductEmpty) {
          return const EmptyState(
            icon: Icons.inventory_2_outlined,
            message: 'No products available',
            subMessage: 'Check back later for new arrivals!',
          );
        } else if (state is ProductLoaded) {
          final products = state.products;

          return ResponsiveLayout(
            mobile: _buildGrid(products, 2),
            tablet: _buildGrid(products, 3),
            desktop: _buildGrid(products, 4),
          );
        }
        return const Center(child: Text('Start exploring products!'));
      },
    );
  }
}
