import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/features/products/presentation/bloc/product_bloc.dart';
import 'package:store/features/products/presentation/bloc/product_event.dart';
import 'package:store/features/products/presentation/bloc/product_state.dart';
import 'package:store/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:store/features/auth/presentation/bloc/auth_state.dart';
import 'package:store/presentation/widgets/custom_card.dart';
import 'package:store/presentation/widgets/common_ui.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  @override
  void initState() {
    super.initState();
    context.read<ProductBloc>().add(GetProductsRequested());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        if (state is ProductLoading) {
          return const LoadingIndicator();
        } else if (state is ProductError) {
          return ErrorState(
            message: state.message,
            onRetry: () => context.read<ProductBloc>().add(GetProductsRequested()),
          );
        } else if (state is ProductEmpty) {
          return const EmptyState(message: 'No products found');
        } else if (state is ProductLoaded) {
          final products = state.products;
          final promoted = products.where((p) => p.isPromoted).toList();

          final authState = context.read<AuthBloc>().state;
          List<String> userInterests = [];
          if (authState is Authenticated) {
            userInterests = authState.user.interests;
          }

          final recommended = products.where((p) {
            return userInterests.any((interest) =>
              p.title.toLowerCase().contains(interest.toLowerCase()) ||
              p.category.toLowerCase().contains(interest.toLowerCase())
            );
          }).toList();

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (promoted.isNotEmpty) ...[
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('Promoted Products', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(
                    height: 250,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: promoted.length,
                      itemBuilder: (context, index) => SizedBox(
                        width: 200,
                        child: CustomCard(
                          product: promoted[index],
                          title: promoted[index].title,
                          price: '\$${promoted[index].price}',
                          image: promoted[index].image,
                        ),
                      ),
                    ),
                  ),
                ],
                if (recommended.isNotEmpty) ...[
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('Recommended for You', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(
                    height: 250,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: recommended.length,
                      itemBuilder: (context, index) => SizedBox(
                        width: 200,
                        child: CustomCard(
                          product: recommended[index],
                          title: recommended[index].title,
                          price: '\$${recommended[index].price}',
                          image: recommended[index].image,
                        ),
                      ),
                    ),
                  ),
                ],
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('All Products', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
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
                      title: product.title,
                      price: '\$${product.price.toStringAsFixed(2)}',
                      image: product.image,
                    );
                  },
                ),
              ],
            ),
          );
        }
        return const Center(child: Text('Start exploring products!'));
      },
    );
  }
}
