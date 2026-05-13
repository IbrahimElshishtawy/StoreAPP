import 'package:store/features/products/domain/entities/product_entity.dart';

abstract class ProductEvent {}

class GetProductsRequested extends ProductEvent {}

class SearchProductsRequested extends ProductEvent {
  final String query;
  final String? category;
  final double? minPrice;
  final double? maxPrice;
  final double? minRating;

  SearchProductsRequested({
    required this.query,
    this.category,
    this.minPrice,
    this.maxPrice,
    this.minRating,
  });
}

class GetProductsByCategoryRequested extends ProductEvent {
  final String category;
  GetProductsByCategoryRequested(this.category);
}
