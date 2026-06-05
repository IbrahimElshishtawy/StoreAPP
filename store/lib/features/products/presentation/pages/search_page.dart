import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/core/util/responsive_layout.dart';
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
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Container(
                      width: 40,
                      height: 5,
                      decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text('Filters',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  const Text('Category', style: TextStyle(fontWeight: FontWeight.bold)),
                  DropdownButton<String>(
                    isExpanded: true,
                    value: _selectedCategory,
                    hint: const Text('Select Category'),
                    items: ['Electronics', 'Jewelery', "Men's Clothing", "Women's Clothing"]
                        .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                    onChanged: (val) {
                      setState(() => _selectedCategory = val);
                      setModalState(() {});
                      _onSearchChanged();
                    },
                  ),
                  const SizedBox(height: 20),
                  Text('Price Range: \$${_priceRange.start.toInt()} - \$${_priceRange.end.toInt()}', style: const TextStyle(fontWeight: FontWeight.bold)),
                  RangeSlider(
                    values: _priceRange,
                    min: 0,
                    max: 1000,
                    divisions: 20,
                    activeColor: Colors.teal,
                    onChanged: (val) {
                      setState(() => _priceRange = val);
                      setModalState(() {});
                      _onSearchChanged();
                    },
                  ),
                  const SizedBox(height: 20),
                  Text('Min Rating: $_minRating', style: const TextStyle(fontWeight: FontWeight.bold)),
                  Slider(
                    value: _minRating,
                    min: 0,
                    max: 5,
                    divisions: 5,
                    activeColor: Colors.teal,
                    onChanged: (val) {
                      setState(() => _minRating = val);
                      setModalState(() {});
                      _onSearchChanged();
                    },
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text('Apply Filters'),
                    ),
                  ),
                  const SizedBox(height: 20),
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
    int crossAxisCount = 2;
    if (ResponsiveLayout.isDesktop(context)) {
      crossAxisCount = 4;
    } else if (ResponsiveLayout.isTablet(context)) {
      crossAxisCount = 3;
    }

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
                    hintText: 'Search for a product...',
                    prefixIcon: const Icon(Icons.search, color: Colors.teal),
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.teal.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: IconButton(
                  icon: const Icon(Icons.filter_list, color: Colors.teal),
                  onPressed: _showFilterSheet,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: BlocBuilder<ProductBloc, ProductState>(
            builder: (context, state) {
              if (state is ProductLoading) {
                return const LoadingIndicator(message: 'Searching...');
              } else if (state is ProductEmpty) {
                return const EmptyState(
                  message: 'No products found',
                  icon: Icons.search_off_outlined,
                );
              } else if (state is ProductLoaded) {
                return GridView.builder(
                  padding: const EdgeInsets.all(12),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.7,
                  ),
                  itemCount: state.products.length,
                  itemBuilder: (context, index) {
                    return CustomCard(
                      product: state.products[index],
                      title: state.products[index].title,
                      price: state.products[index].price.toString(),
                      image: state.products[index].image,
                    );
                  },
                );
              } else if (state is ProductError) {
                return ErrorState(
                  message: state.message,
                  onRetry: _onSearchChanged,
                );
              }
              return const EmptyState(message: 'Start searching for products');
            },
          ),
        ),
      ],
    );
  }
}
