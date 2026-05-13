class SellerStats {
  final double totalSales;
  final int ordersCount;
  final List<DailySales> dailySales;

  SellerStats({
    required this.totalSales,
    required this.ordersCount,
    required this.dailySales,
  });
}

class DailySales {
  final DateTime date;
  final double amount;

  DailySales({required this.date, required this.amount});
}
