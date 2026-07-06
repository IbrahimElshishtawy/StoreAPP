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
        totalSales += (doc.data()['totalAmount'] as num?)?.toDouble() ?? 0.0;
      }

      // Mocking some stats that would ideally be calculated from complex queries or cloud functions
      return SellerStats(
        totalSales: totalSales,
        totalProfit: totalSales * 0.3, // 30% profit margin
        totalOrders: totalOrders,
        dailySales: [120, 250, 180, 350, 280, 450, 400],
        bestSellingProducts: productsSnapshot.docs
            .take(5)
            .map((doc) => _mapDocToEntity(doc))
            .toList(),
        behavior: CustomerBehavior(visits: 2500, conversions: totalOrders),
      );
    } catch (e) {
      throw Exception('Failed to load seller stats: $e');
    }
  }

  @override
  Future<void> addProduct(ProductEntity product, File? imageFile) async {
    try {
      String imageUrl = product.image;

      if (imageFile != null) {
        final ref = storage.ref().child('products/${DateTime.now().toIso8601String()}');
        await ref.putFile(imageFile);
        imageUrl = await ref.getDownloadURL();
      }

      await firestore.collection('products').add({
        'title': product.title,
        'price': product.price,
        'description': product.description,
        'category': product.category,
        'image': imageUrl,
        'rating': {'rate': product.rating, 'count': product.ratingCount},
        'isPromoted': product.isPromoted,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to add product: $e');
    }
  }

  @override
  Future<void> updateProduct(ProductEntity product, File? imageFile) async {
    try {
      String imageUrl = product.image;

      if (imageFile != null) {
        final ref = storage.ref().child('products/${product.id}');
        await ref.putFile(imageFile);
        imageUrl = await ref.getDownloadURL();
      }

      await firestore.collection('products').doc(product.id).update({
        'title': product.title,
        'price': product.price,
        'description': product.description,
        'category': product.category,
        'image': imageUrl,
        'rating': {'rate': product.rating, 'count': product.ratingCount},
        'isPromoted': product.isPromoted,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to update product: $e');
    }
  }

  @override
  Future<void> deleteProduct(String productId) async {
    try {
      await firestore.collection('products').doc(productId).delete();
    } catch (e) {
      throw Exception('Failed to delete product: $e');
    }
  }

  @override
  Future<void> promoteProduct(String productId) async {
    try {
      await firestore.collection('products').doc(productId).update({
        'isPromoted': true,
        'promotedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to promote product: $e');
    }
  }

  ProductEntity _mapDocToEntity(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ProductEntity(
      id: doc.id,
      title: data['title'] ?? '',
      price: (data['price'] as num?)?.toDouble() ?? 0.0,
      description: data['description'] ?? '',
      category: data['category'] ?? '',
      image: data['image'] ?? '',
      rating: (data['rating']?['rate'] as num?)?.toDouble() ?? 0.0,
      ratingCount: data['rating']?['count'] ?? 0,
      isPromoted: data['isPromoted'] ?? false,
    );
  }
}
