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
    // Mock data with enriched statistics
    return SellerStats(
      totalSales: 15000.0,
      totalProfit: 4500.0,
      totalOrders: 124,
      dailySales: [120, 250, 180, 350, 280, 450, 400],
      bestSellingProducts: [
        ProductEntity(
          id: '1',
          title: 'Premium Watch',
          price: 199.99,
          description: 'Luxury watch',
          category: 'Electronics',
          image: 'https://images.unsplash.com/photo-1523275335684-37898b6baf30',
          rating: 4.8,
        ),
        ProductEntity(
          id: '2',
          title: 'Designer Bag',
          price: 299.99,
          description: 'Italian leather',
          category: "Women's Clothing",
          image: 'https://images.unsplash.com/photo-1548036328-c9fa89d128fa',
          rating: 4.7,
        ),
      ],
      behavior: CustomerBehavior(visits: 2500, conversions: 124),
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
