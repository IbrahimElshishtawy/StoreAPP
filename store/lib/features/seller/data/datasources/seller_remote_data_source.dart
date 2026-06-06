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
      totalProfit: 4500.0,
      totalOrders: 50,
      dailySales: [120, 250, 180, 350, 280, 450, 400],
      bestSellingProducts: [
        ProductEntity(
          id: '1',
          title: 'Premium Watch',
          price: 299.99,
          image: 'https://images.unsplash.com/photo-1523275335684-37898b6baf30',
          category: 'Electronics',
          description: 'A premium smartwatch for athletes.',
          rating: 4.8,
          ratingCount: 120,
        ),
        ProductEntity(
          id: '2',
          title: 'Designer Sunglasses',
          price: 150.0,
          image: 'https://images.unsplash.com/photo-1572635196237-14b3f281503f',
          category: 'Accessories',
          description: 'Stylish sunglasses for the summer.',
          rating: 4.5,
          ratingCount: 85,
        ),
      ],
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
