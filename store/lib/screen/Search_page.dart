// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:store/models/prodect_model.dart';
import 'package:store/service/get_all_product_serive.dart';
import 'package:store/widget/custom_card.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<ProductModel> _allProducts = [];
  List<ProductModel> _filteredProducts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    try {
      final List<ProductModel> products = await GetAllProductService()
          .getAllProducts();
      setState(() {
        _allProducts = products;
        _filteredProducts = products;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      debugPrint('❌ Error fetching products: $e');
    }
  }

  void _filterProducts(String query) {
    final results = _allProducts.where((product) {
      return product.title?.toLowerCase().contains(query.toLowerCase()) ??
          false;
    }).toList();

    setState(() => _filteredProducts = results);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: TextField(
            onChanged: _filterProducts,
            decoration: InputDecoration(
              hintText: 'Search for a product...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        Expanded(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _filteredProducts.isEmpty
              ? const Center(child: Text('No products found'))
              : GridView.builder(
                  padding: const EdgeInsets.all(8),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: _filteredProducts.length,
                  itemBuilder: (context, index) {
                    return CustomCard(
                      product: _filteredProducts[index],
                      title: _filteredProducts[index].title ?? '',
                      price: _filteredProducts[index].price?.toString() ?? '',
                      image: _filteredProducts[index].imageUrl ?? '',
                    );
                  },
                ),
        ),
      ],
    );
  }
}
