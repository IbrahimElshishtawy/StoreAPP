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
  RangeValues _priceRange = const RangeValues(0, 1000);
  double _minRating = 0;

  @override
  void initState() {
    super.initState();
    _onSearchChanged();
  }

  void _onSearchChanged() {
    context.read<ProductBloc>().add(SearchProductsRequested(
          query: _searchController.text,
          category: _selectedCategory,
          minPrice: _priceRange.start,
          maxPrice: _priceRange.end,
          minRating: _minRating,
        ));
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Filter Products',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 24),
                  const Text('Category', style: TextStyle(fontWeight: FontWeight.w600)),
                  DropdownButton<String>(
                    isExpanded: true,
                    value: _selectedCategory,
                    hint: const Text("Select Category"),
                    items: ['Electronics', 'Jewelery', "Men's Clothing", "Women's Clothing"]
                        .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                    onChanged: (val) {
                      setModalState(() => _selectedCategory = val);
                      _onSearchChanged();
                    },
                  ),
                  const SizedBox(height: 24),
                  Text('Price Range: \$${_priceRange.start.toInt()} - \$${_priceRange.end.toInt()}',
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  RangeSlider(
                    values: _priceRange,
                    min: 0,
                    max: 1000,
                    divisions: 20,
                    activeColor: Colors.teal,
                    labels: RangeLabels('\$${_priceRange.start.toInt()}', '\$${_priceRange.end.toInt()}'),
                    onChanged: (val) {
                      setModalState(() => _priceRange = val);
                      _onSearchChanged();
                    },
                  ),
                  const SizedBox(height: 24),
                  Text('Minimum Rating: $_minRating ⭐', style: const TextStyle(fontWeight: FontWeight.w600)),
                  Slider(
                    value: _minRating,
                    min: 0,
                    max: 5,
                    divisions: 5,
                    activeColor: Colors.teal,
                    label: '$_minRating',
                    onChanged: (val) {
                      setModalState(() => _minRating = val);
                      _onSearchChanged();
                    },
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Apply Filters'),
                    ),
                  ),
                  const SizedBox(height: 16),
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
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  onChanged: (_) => _onSearchChanged(),
                  decoration: InputDecoration(
                    hintText: 'Search for products...',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                decoration: BoxDecoration(
                  color: Colors.teal,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: const Icon(Icons.filter_list, color: Colors.white),
                  onPressed: _showFilterSheet,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: BlocConsumer<ProductBloc, ProductState>(
            listener: (context, state) {
              if (state is ProductError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message), backgroundColor: Colors.red),
                );
              }
            },
            builder: (context, state) {
              if (state is ProductLoading) {
                return const LoadingIndicator();
              } else if (state is ProductEmpty) {
                return const EmptyState(message: 'No products match your search.', icon: Icons.search_off);
              } else if (state is ProductError) {
                return ErrorState(message: state.message, onRetry: _onSearchChanged);
              } else if (state is ProductLoaded) {
                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: state.products.length,
                  itemBuilder: (context, index) {
                    return CustomCard(
                      product: state.products[index],
                      title: state.products[index].title,
                      price: '\$${state.products[index].price.toStringAsFixed(2)}',
                      image: state.products[index].image,
                    );
                  },
                );
              }
              return const Center(child: Text('Search for something...'));
            },
          ),
        ),
      ],
    );
  }
}
