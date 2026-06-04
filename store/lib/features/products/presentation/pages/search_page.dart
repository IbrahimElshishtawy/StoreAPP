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
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Filters',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  const Text('Category'),
                  DropdownButton<String>(
                    isExpanded: true,
                    value: _selectedCategory,
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
                  Text('Price Range: \$${_priceRange.start.toInt()} - \$${_priceRange.end.toInt()}'),
                  RangeSlider(
                    values: _priceRange,
                    min: 0,
                    max: 1000,
                    divisions: 10,
                    onChanged: (val) {
                      setState(() => _priceRange = val);
                      setModalState(() {});
                      _onSearchChanged();
                    },
                  ),
                  const SizedBox(height: 20),
                  Text('Min Rating: $_minRating'),
                  Slider(
                    value: _minRating,
                    min: 0,
                    max: 5,
                    divisions: 5,
                    onChanged: (val) {
                      setState(() => _minRating = val);
                      setModalState(() {});
                      _onSearchChanged();
                    },
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
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
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  onChanged: (_) => _onSearchChanged(),
                  decoration: InputDecoration(
                    hintText: 'Search for a product...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.filter_list),
                onPressed: _showFilterSheet,
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
                    return CustomCard(
                      product: state.products[index],
                      title: state.products[index].title,
                      price: state.products[index].price.toString(),
                      image: state.products[index].image,
                    );
                  },
                );
              } else if (state is ProductError) {
                return Center(child: Text('Error: ${state.message}'));
              }
              return const Center(child: Text('Search for something...'));
            },
          ),
        ),
      ],
    );
  }
}
