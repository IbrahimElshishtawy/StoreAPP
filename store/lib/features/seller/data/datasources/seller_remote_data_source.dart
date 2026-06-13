import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
  final FirebaseFirestore firestore;
  final FirebaseStorage storage;

  SellerRemoteDataSourceImpl({
    FirebaseFirestore? firestore,
    FirebaseStorage? storage,
  })  : firestore = firestore ?? FirebaseFirestore.instance,
        storage = storage ?? FirebaseStorage.instance;

  @override
  Future<SellerStats> getSellerStats() async {
    try {
      final ordersSnapshot = await firestore.collection('orders').get();
      final productsSnapshot = await firestore.collection('products').get();

      double totalSales = 0;
      int totalOrders = ordersSnapshot.docs.length;

      for (var doc in ordersSnapshot.docs) {
        totalSales += (doc.data()['totalPrice'] as num).toDouble();
      }

      // In a real app, profit would be calculated based on cost price.
      // Here we assume 30% profit margin for simulation.
      double totalProfit = totalSales * 0.3;

      List<ProductEntity> bestSellers = [];
      if (productsSnapshot.docs.isNotEmpty) {
        bestSellers = productsSnapshot.docs
            .take(3)
            .map((doc) => ProductEntity(
                  id: doc.id,
                  title: doc.data()['title'],
                  price: (doc.data()['price'] as num).toDouble(),
                  category: doc.data()['category'],
                  image: doc.data()['image'],
                  description: doc.data()['description'],
                  rating: (doc.data()['rating']?['rate'] as num?)?.toDouble() ?? 0.0,
                ))
            .toList();
      }

      return SellerStats(
        totalSales: totalSales > 0 ? totalSales : 15000.0, // Fallback to mock if empty for demo
        totalProfit: totalProfit > 0 ? totalProfit : 4500.0,
        totalOrders: totalOrders > 0 ? totalOrders : 124,
        dailySales: [120, 250, 180, 350, 280, 450, 400],
        bestSellingProducts: bestSellers.isNotEmpty
            ? bestSellers
            : [
                ProductEntity(
                  id: '1',
                  title: 'Premium Watch',
                  price: 199.99,
                  description: 'Luxury watch',
                  category: 'Electronics',
                  image: 'https://images.unsplash.com/photo-1523275335684-37898b6baf30',
                  rating: 4.8,
                ),
              ],
        behavior: CustomerBehavior(
          visits: 2500,
          conversions: totalOrders > 0 ? totalOrders : 124,
        ),
      );
    } catch (e) {
      // Return mock data as fallback in case of Firestore error (e.g. collection doesn't exist yet)
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
        ],
        behavior: CustomerBehavior(visits: 2500, conversions: 124),
      );
    }
  }

  @override
  Future<void> addProduct(ProductEntity product, File? imageFile) async {
    String imageUrl = product.image;

    if (imageFile != null) {
      final ref = storage.ref().child('products/${DateTime.now().toIso8601String()}');
      await ref.putFile(imageFile);
      imageUrl = await ref.getDownloadURL();
    }

    await firestore.collection('products').add({
      'title': product.title,
      'description': product.description,
      'price': product.price,
      'category': product.category,
      'image': imageUrl,
      'rating': {
        'rate': product.rating,
        'count': product.ratingCount,
      },
      'isPromoted': product.isPromoted,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> updateProduct(ProductEntity product, File? imageFile) async {
    String imageUrl = product.image;

    if (imageFile != null) {
      final ref = storage.ref().child('products/${product.id}');
      await ref.putFile(imageFile);
      imageUrl = await ref.getDownloadURL();
    }

    await firestore.collection('products').doc(product.id).update({
      'title': product.title,
      'description': product.description,
      'price': product.price,
      'category': product.category,
      'image': imageUrl,
      'isPromoted': product.isPromoted,
      'updatedAt': FieldValue.serverTimestamp(),
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
