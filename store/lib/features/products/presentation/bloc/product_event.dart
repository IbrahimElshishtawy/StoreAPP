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
