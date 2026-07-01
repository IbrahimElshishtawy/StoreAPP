import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:store/features/seller/domain/entities/seller_stats.dart';
import 'package:store/features/products/domain/entities/product_entity.dart';
import 'package:store/features/products/data/models/product_model.dart';

abstract class SellerRemoteDataSource {
  Future<SellerStats> getSellerStats();
  Future<void> addProduct(ProductEntity product, File? imageFile);
  Future<void> updateProduct(ProductEntity product, File? imageFile);
  Future<void> deleteProduct(String productId);
  Future<void> promoteProduct(String productId);
}

class SellerRemoteDataSourceImpl implements SellerRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseStorage storage;

  SellerRemoteDataSourceImpl({
    required this.firestore,
    required this.storage,
  });

  @override
  Future<SellerStats> getSellerStats() async {
    final productsSnapshot = await firestore.collection('products').get();
    final ordersSnapshot = await firestore.collection('orders').get();

    double totalSales = 0;
    for (var doc in ordersSnapshot.docs) {
      totalSales += (doc.data()['totalAmount'] as num?)?.toDouble() ?? 0.0;
    }

    final products = productsSnapshot.docs.map((doc) {
      final model = ProductModel.fromJson({...doc.data(), 'id': doc.id});
      return ProductEntity(
        id: model.id,
        title: model.title ?? '',
        price: model.price ?? 0.0,
        description: model.description ?? '',
        category: doc.data()['category'] ?? '', // Category might not be in ProductModel
        image: model.imageUrl ?? '',
        rating: model.rating?.rate ?? 0.0,
        ratingCount: model.rating?.count ?? 0,
      );
    }).toList();

    // In a real scenario, we'd calculate best sellers by counting order items.
    // For now, we take the top 5 products.
    final bestSellers = products.take(5).toList();

    return SellerStats(
      totalSales: totalSales,
      totalProfit: totalSales * 0.25, // Assuming 25% margin
      totalOrders: ordersSnapshot.docs.length,
      dailySales: [100, 150, 120, 200, 180, 250, totalSales / (ordersSnapshot.docs.length > 0 ? ordersSnapshot.docs.length : 1)],
      bestSellingProducts: bestSellers,
      behavior: CustomerBehavior(
        visits: 1200,
        conversions: ordersSnapshot.docs.length,
      ),
    );
  }

  @override
  Future<void> addProduct(ProductEntity product, File? imageFile) async {
    String imageUrl = product.image;
    if (imageFile != null) {
      final ref = storage.ref().child('products/${DateTime.now().millisecondsSinceEpoch}.jpg');
      await ref.putFile(imageFile);
      imageUrl = await ref.getDownloadURL();
    }

    final productMap = {
      'title': product.title,
      'price': product.price,
      'description': product.description,
      'category': product.category,
      'image': imageUrl,
      'rating': {'rate': product.rating, 'count': product.ratingCount},
      'isPromoted': product.isPromoted,
    };

    await firestore.collection('products').add(productMap);
  }

  @override
  Future<void> updateProduct(ProductEntity product, File? imageFile) async {
    String imageUrl = product.image;
    if (imageFile != null) {
      final ref = storage.ref().child('products/${product.id}.jpg');
      await ref.putFile(imageFile);
      imageUrl = await ref.getDownloadURL();
    }

    await firestore.collection('products').doc(product.id).update({
      'title': product.title,
      'price': product.price,
      'description': product.description,
      'category': product.category,
      'image': imageUrl,
      'isPromoted': product.isPromoted,
    });
  }

  @override
  Future<void> deleteProduct(String productId) async {
    await firestore.collection('products').doc(productId).delete();
  }

  @override
  Future<void> promoteProduct(String productId) async {
    await firestore.collection('products').doc(productId).update({
      'isPromoted': true,
    });
  }
}
