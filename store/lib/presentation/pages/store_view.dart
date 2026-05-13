import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/core/util/responsive_layout.dart';
import 'package:store/features/products/presentation/bloc/product_bloc.dart';
import 'package:store/features/products/presentation/bloc/product_event.dart';
import 'package:store/features/products/presentation/bloc/product_state.dart';
import 'package:store/presentation/widgets/store_header.dart';
import 'package:store/presentation/widgets/search_bar_delegate.dart';
import 'package:store/presentation/widgets/virtual_product_card.dart';
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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: ResponsiveLayout(
        mobile: _buildContent(context, 2),
        tablet: _buildContent(context, 3),
        desktop: _buildContent(context, 4),
      ),
    );
  }

  Widget _buildContent(BuildContext context, int crossAxisCount) {
    return CustomScrollView(
      slivers: [
        const SliverToBoxAdapter(
          child: StoreHeader(),
        ),
        SliverPersistentHeader(
          pinned: true,
          delegate: PersistentSearchBarDelegate(),
        ),
        BlocBuilder<ProductBloc, ProductState>(
          builder: (context, state) {
            if (state is ProductLoading) {
              return const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              );
            } else if (state is ProductError) {
              return SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Error: ${state.message}'),
                      ElevatedButton(
                        onPressed: () => context.read<ProductBloc>().add(GetProductsRequested()),
                        child: const Text('Retry'),
                      )
                    ],
                  ),
                ),
              );
            } else if (state is ProductLoaded) {
              if (state.products.isEmpty) {
                return const SliverFillRemaining(
                  child: Center(child: Text('No products found.')),
                );
              }
              return SliverPadding(
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
                      final product = state.products[index];
                      return VirtualProductCard(
                        product: product,
                        onVrTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductVirtualView(product: product),
                            ),
                          );
                        },
                      );
                    },
                    childCount: state.products.length,
                  ),
                ),
              );
            }
            return const SliverFillRemaining(child: SizedBox());
          },
        ),
        const SliverPadding(padding: EdgeInsets.only(bottom: 40)),
      ],
    );
  }
}
