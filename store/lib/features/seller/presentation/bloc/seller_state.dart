class SellerStats {
  final double totalSales;
  final int totalOrders;
  final List<double> dailySales;

  SellerStats({
    required this.totalSales,
    required this.totalOrders,
    required this.dailySales,
  });
}

abstract class SellerState {}

class SellerInitial extends SellerState {}

class SellerLoading extends SellerState {}

class SellerStatsLoaded extends SellerState {
  final SellerStats stats;
  SellerStatsLoaded(this.stats);
}

class SellerProductUploaded extends SellerState {}

class SellerError extends SellerState {
  final String message;
  SellerError(this.message);
}
