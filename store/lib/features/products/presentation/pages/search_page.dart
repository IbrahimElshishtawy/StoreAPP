// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/features/products/presentation/bloc/product_bloc.dart';
import 'package:store/features/products/presentation/bloc/product_event.dart';
import 'package:store/features/products/presentation/bloc/product_state.dart';
import 'package:store/presentation/widgets/custom_card.dart';
import 'package:store/presentation/widgets/common_ui.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedCategory;
  double _minPrice = 0;
  double _maxPrice = 1000;
  double _minRating = 0;

  @override
  void initState() {
    super.initState();
    _dispatchSearch();
  }

  void _dispatchSearch() {
    context.read<ProductBloc>().add(SearchProductsRequested(
          query: _searchController.text,
          category: _selectedCategory,
          minPrice: _minPrice,
          maxPrice: _maxPrice,
          minRating: _minRating,
        ));
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Filters",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  DropdownButton<String>(
                    value: _selectedCategory,
                    hint: const Text("Select Category"),
                    isExpanded: true,
                    items: ["electronics", "jewelery", "men's clothing", "women's clothing"]
                        .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                    onChanged: (val) {
                      setModalState(() => _selectedCategory = val);
                      setState(() {});
                    },
                  ),
                  const SizedBox(height: 16),
                  Text("Price Range: \$${_minPrice.round()} - \$${_maxPrice.round()}"),
                  RangeSlider(
                    values: RangeValues(_minPrice, _maxPrice),
                    min: 0,
                    max: 1000,
                    onChanged: (val) {
                      setModalState(() {
                        _minPrice = val.start;
                        _maxPrice = val.end;
                      });
                      setState(() {});
                    },
                  ),
                  const SizedBox(height: 16),
                  Text("Minimum Rating: ${_minRating.toStringAsFixed(1)}"),
                  Slider(
                    value: _minRating,
                    min: 0,
                    max: 5,
                    divisions: 5,
                    onChanged: (val) {
                      setModalState(() => _minRating = val);
                      setState(() {});
                    },
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      _dispatchSearch();
                      Navigator.pop(context);
                    },
                    child: const Text("Apply Filters"),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  onChanged: (val) => _dispatchSearch(),
                  decoration: InputDecoration(
                    hintText: 'Search for a product...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: _showFilterBottomSheet,
                icon: const Icon(Icons.tune),
              )
            ],
          ),
        ),
        Expanded(
          child: BlocBuilder<ProductBloc, ProductState>(
            builder: (context, state) {
              if (state is ProductLoading) {
                return const LoadingIndicator();
              } else if (state is ProductEmpty) {
                return const EmptyState(message: "No products found");
              } else if (state is ProductError) {
                return Center(child: Text(state.message));
              } else if (state is ProductLoaded) {
                return GridView.builder(
                  padding: const EdgeInsets.all(8),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: state.products.length,
                  itemBuilder: (context, index) {
                    final product = state.products[index];
                    return CustomCard(
                      product: product,
                      title: product.title,
                      price: '\$${product.price}',
                      image: product.image,
                    );
                  },
                );
              }
              return const Center(child: Text("Search for products"));
            },
          ),
        ),
      ],
    );
  }
}
