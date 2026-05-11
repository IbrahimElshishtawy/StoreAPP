import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/features/products/presentation/bloc/product_bloc.dart';
import 'package:store/features/products/presentation/bloc/product_event.dart';
import 'package:store/features/products/presentation/bloc/product_state.dart';
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
      backgroundColor: const Color(0xFFF8FAFC),
      body: LayoutBuilder(
        builder: (context, constraints) {
          int crossAxisCount = constraints.maxWidth > 900 ? 4 : (constraints.maxWidth > 600 ? 3 : 2);
          
          return BlocConsumer<ProductBloc, ProductState>(
            listener: (context, state) {
              if (state is ProductError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              }
            },
            builder: (context, state) {
              return CustomScrollView(
                slivers: [
                  const SliverToBoxAdapter(
                    child: StoreHeader(),
                  ),
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: PersistentSearchBarDelegate(),
                  ),
                  if (state is ProductLoading)
                    const SliverFillRemaining(
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else if (state is ProductLoaded)
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
                    )
                  else if (state is ProductError)
                    SliverFillRemaining(
                      child: Center(child: Text('Error: ${state.message}')),
                    )
                  else
                    const SliverFillRemaining(
                      child: Center(child: Text('No products found')),
                    ),
                  const SliverPadding(padding: EdgeInsets.only(bottom: 40)), // Safe area at bottom
                ],
              );
            },
          );
        },
      ),
    );
  }
}
