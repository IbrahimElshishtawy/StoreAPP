class SellerStats {
  final double totalSales;
  final int totalOrders;
  final List<double> dailySales;
  final CustomerBehavior behavior;

  SellerStats({
    required this.totalSales,
    required this.totalOrders,
    required this.dailySales,
    required this.behavior,
  });
}

class CustomerBehavior {
  final int visits;
  final int conversions;

  CustomerBehavior({required this.visits, required this.conversions});
}
