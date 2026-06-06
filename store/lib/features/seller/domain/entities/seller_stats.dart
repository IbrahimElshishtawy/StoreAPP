import 'package:store/features/products/domain/entities/product_entity.dart';

class SellerStats {
  final double totalSales;
  final double totalProfit;
  final int totalOrders;
  final List<double> dailySales;
  final List<ProductEntity> bestSellingProducts;
  final CustomerBehavior behavior;

  SellerStats({
    required this.totalSales,
    required this.totalProfit,
    required this.totalOrders,
    required this.dailySales,
    required this.bestSellingProducts,
    required this.behavior,
  });
}

class CustomerBehavior {
  final int visits;
  final int conversions;

  CustomerBehavior({required this.visits, required this.conversions});
}
