import 'package:flutter/material.dart';
import 'package:store/core/util/responsive_layout.dart';
import '../models/dummy_product.dart';
import '../widgets/store_header.dart';
import '../widgets/search_bar_delegate.dart';
import '../widgets/virtual_product_card.dart';
import 'product_virtual_view.dart';

class StoreView extends StatelessWidget {
  const StoreView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.light
          ? const Color(0xFFF8FAFC)
          : const Color(0xFF0F172A),
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
                final product = dummyProducts[index];
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
              childCount: dummyProducts.length,
            ),
          ),
        ),
        const SliverPadding(padding: EdgeInsets.only(bottom: 40)),
      ],
    );
  }
}
