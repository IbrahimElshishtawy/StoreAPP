// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:store/features/products/data/models/product_model.dart';
import 'package:store/service/get_all_product_serive.dart';
import 'package:store/presentation/widgets/custom_card.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<ProductModel> _allProducts = [];
  List<ProductModel> _filteredProducts = [];
  bool _isLoading = true;
  String _selectedCategory = 'All';
  RangeValues _priceRange = const RangeValues(0, 1000);
  double _minRating = 0;

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

  void _applyFilters() {
    setState(() {
      _filteredProducts = _allProducts.where((product) {
        final matchesCategory =
            _selectedCategory == 'All' || product.category == _selectedCategory;
        final matchesPrice = (product.price ?? 0) >= _priceRange.start &&
            (product.price ?? 0) <= _priceRange.end;
        final matchesRating = (product.rating?.rate ?? 0) >= _minRating;
        return matchesCategory && matchesPrice && matchesRating;
      }).toList();
    });
  }

  void _filterProducts(String query) {
    final results = _allProducts.where((product) {
      final matchesQuery =
          product.title?.toLowerCase().contains(query.toLowerCase()) ?? false;
      return matchesQuery;
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
              suffixIcon: IconButton(
                icon: const Icon(Icons.filter_list),
                onPressed: () => _showFilterDialog(),
              ),
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

  void _showFilterDialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Category',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  DropdownButton<String>(
                    value: _selectedCategory,
                    isExpanded: true,
                    items: ['All', 'electronics', 'jewelery', "men's clothing", "women's clothing"]
                        .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                    onChanged: (val) {
                      setModalState(() => _selectedCategory = val!);
                    },
                  ),
                  const SizedBox(height: 16),
                  Text(
                      'Price Range: \$${_priceRange.start.round()} - \$${_priceRange.end.round()}',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  RangeSlider(
                    values: _priceRange,
                    min: 0,
                    max: 1000,
                    divisions: 20,
                    onChanged: (val) {
                      setModalState(() => _priceRange = val);
                    },
                  ),
                  const SizedBox(height: 16),
                  Text('Minimum Rating: $_minRating',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  Slider(
                    value: _minRating,
                    min: 0,
                    max: 5,
                    divisions: 5,
                    onChanged: (val) {
                      setModalState(() => _minRating = val);
                    },
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      _applyFilters();
                      Navigator.pop(context);
                    },
                    child: const Text('Apply Filters'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
