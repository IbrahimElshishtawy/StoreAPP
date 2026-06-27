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

  SellerRemoteDataSourceImpl({FirebaseFirestore? firestore, FirebaseStorage? storage})
      : firestore = firestore ?? FirebaseFirestore.instance,
        storage = storage ?? FirebaseStorage.instance;

  @override
  Future<SellerStats> getSellerStats() async {
    try {
      // In a real app, we'd filter by sellerId. For this demo, we aggregate all.
      final ordersSnapshot = await firestore.collection('orders').get();
      final productsSnapshot = await firestore.collection('products').get();

      double totalSales = 0;
      int totalOrders = ordersSnapshot.docs.length;

      for (var doc in ordersSnapshot.docs) {
        totalSales += (doc.data()['totalAmount'] ?? 0).toDouble();
      }

      double totalProfit = totalSales * 0.3; // Assuming 30% profit margin for simulation

      List<ProductEntity> bestSelling = productsSnapshot.docs
          .map((doc) => ProductModel.fromJson(doc.data(), doc.id))
          .take(3)
          .toList();

      return SellerStats(
        totalSales: totalSales,
        totalProfit: totalProfit,
        totalOrders: totalOrders,
        dailySales: [120, 250, 180, 350, 280, 450, totalSales / 30], // Mocked trend
        bestSellingProducts: bestSelling,
        behavior: CustomerBehavior(visits: 2500, conversions: totalOrders),
      );
    } catch (e) {
      throw Exception("Failed to fetch seller stats: $e");
    }
  }

  @override
  Future<void> addProduct(ProductEntity product, File? imageFile) async {
    String imageUrl = product.image;
    if (imageFile != null) {
      final ref = storage.ref().child('products/${DateTime.now().millisecondsSinceEpoch}.jpg');
      await ref.putFile(imageFile);
      imageUrl = await ref.getDownloadURL();
    }

    final productModel = ProductModel(
      id: '',
      title: product.title,
      category: product.category,
      price: product.price,
      image: imageUrl,
      description: product.description,
      rating: product.rating,
      ratingCount: product.ratingCount,
      isPromoted: product.isPromoted,
    );

    await firestore.collection('products').add(productModel.toJson());
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
      'category': product.category,
      'price': product.price,
      'image': imageUrl,
      'description': product.description,
      'isPromoted': product.isPromoted,
    });
  }

  @override
  Future<void> deleteProduct(String productId) async {
    await firestore.collection('products').doc(productId).delete();
  }

  @override
  Future<void> promoteProduct(String productId) async {
    await firestore.collection('products').doc(productId).update({'isPromoted': true});
  }
}
