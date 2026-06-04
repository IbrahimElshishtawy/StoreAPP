import 'dart:io';
import 'package:store/features/seller/domain/entities/seller_stats.dart';
import 'package:store/features/products/domain/entities/product_entity.dart';

abstract class SellerRemoteDataSource {
  Future<SellerStats> getSellerStats();
  Future<void> addProduct(ProductEntity product, File? imageFile);
  Future<void> updateProduct(ProductEntity product, File? imageFile);
  Future<void> deleteProduct(String productId);
  Future<void> promoteProduct(String productId);
}

class SellerRemoteDataSourceImpl implements SellerRemoteDataSource {
  @override
  Future<SellerStats> getSellerStats() async {
    // Mock data
    return SellerStats(
      totalSales: 15000.0,
      totalOrders: 50,
      dailySales: [120, 250, 180, 350, 280, 450, 400],
      behavior: CustomerBehavior(visits: 1000, conversions: 50),
    );
  }

  @override
  Future<void> addProduct(ProductEntity product, File? imageFile) async {
    // Implement Firestore logic
  }

  @override
  Future<void> updateProduct(ProductEntity product, File? imageFile) async {
    // Implement Firestore logic
  }

  @override
  Future<void> deleteProduct(String productId) async {
    // Implement Firestore logic
  }

  @override
  Future<void> promoteProduct(String productId) async {
    // Implement promotion logic
  }
}
