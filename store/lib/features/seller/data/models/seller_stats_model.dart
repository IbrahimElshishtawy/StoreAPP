import 'package:store/features/seller/domain/entities/seller_stats.dart';

class SellerStatsModel extends SellerStats {
  SellerStatsModel({
    required super.totalSales,
    required super.totalOrders,
    required super.dailySales,
  });

  factory SellerStatsModel.fromJson(Map<String, dynamic> json) {
    return SellerStatsModel(
      totalSales: (json['totalSales'] as num).toDouble(),
      totalOrders: json['totalOrders'] as int,
      dailySales: (json['dailySales'] as List).map((e) => (e as num).toDouble()).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalSales': totalSales,
      'totalOrders': totalOrders,
      'dailySales': dailySales,
    };
  }
}
