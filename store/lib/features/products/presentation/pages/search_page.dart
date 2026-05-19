import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/features/products/presentation/bloc/product_bloc.dart';
import 'package:store/features/products/presentation/bloc/product_event.dart';
import 'package:store/features/products/presentation/bloc/product_state.dart';
import 'package:store/presentation/widgets/custom_card.dart';
import 'package:store/presentation/widgets/empty_state.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  double _minPrice = 0;
  double _maxPrice = 1000;
  String? _selectedCategory;
  double _minRating = 0;

  final List<String> _categories = [
    "electronics",
    "jewelery",
    "men's clothing",
    "women's clothing"
  ];

  void _onSearchChanged() {
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

  @override
  void initState() {
    super.initState();
    _dispatchSearch();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              TextField(
                controller: _searchController,
                onChanged: (_) => _onSearchChanged(),
                decoration: InputDecoration(
                  hintText: 'Search for a product...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.filter_list),
                    onPressed: () => _showFilterBottomSheet(context),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
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
                return const EmptyState(
                  icon: Icons.search_off,
                  message: 'No products found',
                  subMessage: 'Try adjusting your search or filters',
                );
              } else if (state is ProductLoaded) {
                return GridView.builder(
                  padding: const EdgeInsets.all(8),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childAspectRatio: 0.7,
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
              } else if (state is ProductError) {
                return Center(child: Text(state.message));
              }
              return const Center(child: Text('Start searching!'));
            },
          ),
        ),
      ],
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
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
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Filters",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  const Text("Category"),
                  DropdownButton<String>(
                    value: _selectedCategory,
                    isExpanded: true,
                    hint: const Text("Select Category"),
                    items: [
                      const DropdownMenuItem(value: null, child: Text("All")),
                      ..._categories.map((c) => DropdownMenuItem(value: c, child: Text(c))),
                    ],
                    onChanged: (val) {
                      setModalState(() => _selectedCategory = val);
                      setState(() => _selectedCategory = val);
                    },
                  ),
                  const SizedBox(height: 20),
                  Text("Price Range: \$${_minPrice.toInt()} - \$${_maxPrice.toInt()}"),
                  RangeSlider(
                    values: RangeValues(_minPrice, _maxPrice),
                    min: 0,
                    max: 1000,
                    divisions: 20,
                    labels: RangeLabels('\$${_minPrice.toInt()}', '\$${_maxPrice.toInt()}'),
                    onChanged: (RangeValues values) {
                      setModalState(() {
                        _minPrice = values.start;
                        _maxPrice = values.end;
                      });
                      setState(() {
                        _minPrice = values.start;
                        _maxPrice = values.end;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  Text("Minimum Rating: ${_minRating.toStringAsFixed(1)}"),
                  Slider(
                    value: _minRating,
                    min: 0,
                    max: 5,
                    divisions: 10,
                    label: _minRating.toStringAsFixed(1),
                    onChanged: (val) {
                      setModalState(() => _minRating = val);
                      setState(() => _minRating = val);
                    },
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        _dispatchSearch();
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                      child: const Text("Apply Filters", style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
