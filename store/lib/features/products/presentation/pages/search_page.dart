import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/features/products/presentation/bloc/product_bloc.dart';
import 'package:store/features/products/presentation/bloc/product_event.dart';
import 'package:store/features/products/presentation/bloc/product_state.dart';
import 'package:store/presentation/widgets/custom_card.dart';

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

  final List<String> _categories = [
    'electronics',
    'jewelery',
    "men's clothing",
    "women's clothing"
  ];

  @override
  void initState() {
    super.initState();
    _triggerSearch();
  }

  void _triggerSearch() {
    context.read<ProductBloc>().add(
          SearchProductsRequested(
            query: _searchController.text,
            category: _selectedCategory,
            minPrice: _priceRange.start,
            maxPrice: _priceRange.end,
            minRating: _minRating > 0 ? _minRating : null,
          ),
        );
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Filters',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  const Text('Category'),
                  DropdownButton<String>(
                    isExpanded: true,
                    value: _selectedCategory,
                    hint: const Text('All Categories'),
                    items: [
                      const DropdownMenuItem<String>(
                        value: null,
                        child: Text('All Categories'),
                      ),
                      ..._categories.map((cat) => DropdownMenuItem(
                            value: cat,
                            child: Text(cat),
                          )),
                    ],
                    onChanged: (value) {
                      setModalState(() => _selectedCategory = value);
                      setState(() => _selectedCategory = value);
                    },
                  ),
                  const SizedBox(height: 16),
                  Text(
                      'Price Range: \$${_priceRange.start.toInt()} - \$${_priceRange.end.toInt()}'),
                  RangeSlider(
                    values: _priceRange,
                    min: 0,
                    max: 1000,
                    divisions: 20,
                    labels: RangeLabels(
                      _priceRange.start.round().toString(),
                      _priceRange.end.round().toString(),
                    ),
                    onChanged: (values) {
                      setModalState(() => _priceRange = values);
                      setState(() => _priceRange = values);
                    },
                  ),
                  const SizedBox(height: 16),
                  Text('Minimum Rating: ${_minRating.toStringAsFixed(1)}'),
                  Slider(
                    value: _minRating,
                    min: 0,
                    max: 5,
                    divisions: 5,
                    label: _minRating.toString(),
                    onChanged: (value) {
                      setModalState(() => _minRating = value);
                      setState(() => _minRating = value);
                    },
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        _triggerSearch();
                        Navigator.pop(context);
                      },
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
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) => _triggerSearch(),
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
                icon: const Icon(Icons.filter_list),
              ),
            ],
          ),
        ),
        Expanded(
          child: BlocBuilder<ProductBloc, ProductState>(
            builder: (context, state) {
              if (state is ProductLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is ProductEmpty) {
                return const Center(child: Text('No products found'));
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
                      price: '\$${product.price.toStringAsFixed(2)}',
                      image: product.image,
                    );
                  },
                );
              }
              return const Center(child: Text('Search for products'));
            },
          ),
        ),
      ],
    );
  }
}
