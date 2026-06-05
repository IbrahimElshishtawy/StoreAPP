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
          title: 'Fjallraven - Foldsack No. 1 Backpack, Fits 15 Laptops',
          price: 109.95,
          description: 'Your perfect pack for everyday use and walks in the forest. Stash your laptop (up to 15 inches) in the padded sleeve, your everyday',
          category: "men's clothing",
          image: 'https://fakestoreapi.com/img/81fPKd-2AYL._AC_SL1500_.jpg',
          rating: 3.9,
          ratingCount: 120,
        ),
        ProductEntity(
          id: '2',
          title: 'Mens Casual Premium Slim Fit T-Shirts ',
          price: 22.3,
          description: 'Slim-fitting style, contrast raglan long sleeve, three-button henley placket, light weight & soft fabric for breathable and comfortable wearing. And Solid stitched shirts with round neck made for durability and a great fit for casual fashion wear and diehard baseball fans. The Henley style round neckline includes a three-button placket.',
          category: "men's clothing",
          image: 'https://fakestoreapi.com/img/71-3HjGNDUL._AC_SY879._SX._UX._SY._UY_.jpg',
          rating: 4.1,
          ratingCount: 259,
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
