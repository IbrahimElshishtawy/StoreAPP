import 'package:dartz/dartz.dart';
import 'package:store/features/products/domain/entities/product_entity.dart';
import 'package:store/features/seller/data/models/seller_stats_model.dart';

abstract class SellerRemoteDataSource {
  Future<SellerStatsModel> getSellerStats();
  Future<Unit> addProduct(ProductEntity product);
  Future<Unit> updateProduct(ProductEntity product);
  Future<Unit> deleteProduct(String productId);
}

class SellerRemoteDataSourceImpl implements SellerRemoteDataSource {
  @override
  Future<SellerStatsModel> getSellerStats() async {
    // Mock implementation
    await Future.delayed(const Duration(seconds: 1));
    return SellerStatsModel(
      totalSales: 12500.0,
      totalOrders: 45,
      dailySales: [100, 200, 150, 300, 250, 400, 350],
    );
  }

  @override
  Future<Unit> addProduct(ProductEntity product) async {
    await Future.delayed(const Duration(seconds: 1));
    return unit;
  }

  @override
  Future<Unit> updateProduct(ProductEntity product) async {
    await Future.delayed(const Duration(seconds: 1));
    return unit;
  }

  @override
  Future<Unit> deleteProduct(String productId) async {
    await Future.delayed(const Duration(seconds: 1));
    return unit;
  }
}
