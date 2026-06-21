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
    final ordersSnapshot = await firestore.collection('orders').get();
    final productsSnapshot = await firestore.collection('products').limit(5).get();

    double totalSales = 0;
    for (var doc in ordersSnapshot.docs) {
      totalSales += (doc.data()['totalAmount'] ?? 0).toDouble();
    }

    List<ProductEntity> bestSellers = productsSnapshot.docs.map((doc) {
      return ProductModel.fromJson(doc.data(), doc.id);
    }).toList();

    return SellerStats(
      totalSales: totalSales,
      totalProfit: totalSales * 0.3,
      totalOrders: ordersSnapshot.docs.length,
      dailySales: [120, 250, 180, 350, 280, 450, 400],
      bestSellingProducts: bestSellers,
      behavior: CustomerBehavior(visits: 2500, conversions: ordersSnapshot.docs.length),
    );
  }

  @override
  Future<void> addProduct(ProductEntity product, File? imageFile) async {
    String imageUrl = product.image;
    if (imageFile != null) {
      final ref = storage.ref().child('products/${DateTime.now().toIso8601String()}');
      await ref.putFile(imageFile);
      imageUrl = await ref.getDownloadURL();
    }

    final productModel = ProductModel(
      id: '',
      title: product.title,
      description: product.description,
      price: product.price,
      image: imageUrl,
      category: product.category,
      rating: product.rating,
      isPromoted: product.isPromoted,
    );

    await firestore.collection('products').add(productModel.toJson());
  }

  @override
  Future<void> updateProduct(ProductEntity product, File? imageFile) async {
    String imageUrl = product.image;
    if (imageFile != null) {
      final ref = storage.ref().child('products/${product.id}');
      await ref.putFile(imageFile);
      imageUrl = await ref.getDownloadURL();
    }

    final data = {
      'title': product.title,
      'description': product.description,
      'price': product.price,
      'image': imageUrl,
      'category': product.category,
      'isPromoted': product.isPromoted,
    };

    await firestore.collection('products').doc(product.id).update(data);
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
