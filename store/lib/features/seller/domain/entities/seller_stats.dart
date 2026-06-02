class SellerStats {
  final double totalSales;
  final int totalOrders;
  final List<double> dailySales;
  final double totalProfit;
  final List<BestSellingProduct> bestSellingProducts;
  final CustomerBehavior customerBehavior;

  SellerStats({
    required this.totalSales,
    required this.totalOrders,
    required this.dailySales,
    required this.totalProfit,
    required this.bestSellingProducts,
    required this.customerBehavior,
  });
}

class BestSellingProduct {
  final String title;
  final int salesCount;
  final double revenue;

  BestSellingProduct({
    required this.title,
    required this.salesCount,
    required this.revenue,
  });
}

class CustomerBehavior {
  final int visits;
  final int conversions;
  final List<String> favoriteCategories;

  CustomerBehavior({
    required this.visits,
    required this.conversions,
    required this.favoriteCategories,
  });

  double get conversionRate => visits > 0 ? (conversions / visits) * 100 : 0;
}
