abstract class ProductEvent {}

class GetProductsRequested extends ProductEvent {}

class SearchProductsRequested extends ProductEvent {
  final String query;
  SearchProductsRequested(this.query);
}

class GetProductsByCategoryRequested extends ProductEvent {
  final String category;
  GetProductsByCategoryRequested(this.category);
}

class FilterProductsRequested extends ProductEvent {
  final double minPrice;
  final double maxPrice;
  final double minRating;
  FilterProductsRequested({
    this.minPrice = 0.0,
    this.maxPrice = double.infinity,
    this.minRating = 0.0,
  });
}
