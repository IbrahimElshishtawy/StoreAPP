import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/core/util/responsive_layout.dart';
import 'package:store/features/products/presentation/bloc/product_bloc.dart';
import 'package:store/features/products/presentation/bloc/product_event.dart';
import 'package:store/features/products/presentation/bloc/product_state.dart';
import 'package:store/presentation/widgets/common_ui.dart';
import '../models/dummy_product.dart';
import '../widgets/store_header.dart';
import '../widgets/search_bar_delegate.dart';
import '../widgets/virtual_product_card.dart';
import 'product_virtual_view.dart';

class StoreView extends StatefulWidget {
  const StoreView({super.key});

  @override
  State<StoreView> createState() => _StoreViewState();
}

class _StoreViewState extends State<StoreView> {
  @override
  void initState() {
    super.initState();
    context.read<ProductBloc>().add(GetProductsRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.light
          ? const Color(0xFFF8FAFC)
          : const Color(0xFF0F172A),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductLoading) {
            return const LoadingIndicator();
          } else if (state is ProductError) {
            return Center(child: Text(state.message));
          } else if (state is ProductEmpty) {
            return const EmptyState(message: 'No products found');
          } else if (state is ProductLoaded) {
            return ResponsiveLayout(
              mobile: _buildContent(context, 2, state.products),
              tablet: _buildContent(context, 3, state.products),
              desktop: _buildContent(context, 4, state.products),
            );
          }
          // Default to dummy products if initial or other state
          return ResponsiveLayout(
            mobile: _buildContent(context, 2, dummyProducts),
            tablet: _buildContent(context, 3, dummyProducts),
            desktop: _buildContent(context, 4, dummyProducts),
          );
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, int crossAxisCount, List products) {
    return CustomScrollView(
      slivers: [
        const SliverToBoxAdapter(
          child: StoreHeader(),
        ),
        SliverPersistentHeader(
          pinned: true,
          delegate: PersistentSearchBarDelegate(),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              childAspectRatio: 0.65,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final product = products[index];
                return VirtualProductCard(
                  product: product is DummyProduct
                      ? product
                      : DummyProduct(
                          id: product.id,
                          title: product.title,
                          description: product.description,
                          price: product.price,
                          image: product.image,
                          category: product.category,
                        ),
                  onVrTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductVirtualView(
                          product: product is DummyProduct
                              ? product
                              : DummyProduct(
                                  id: product.id,
                                  title: product.title,
                                  description: product.description,
                                  price: product.price,
                                  image: product.image,
                                  category: product.category,
                                ),
                        ),
                      ),
                    );
                  },
                );
              },
              childCount: products.length,
            ),
          ),
        ),
        const SliverPadding(padding: EdgeInsets.only(bottom: 40)),
      ],
    );
  }
}
