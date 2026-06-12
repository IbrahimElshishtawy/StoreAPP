import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  final FirebaseAuth auth;

  SellerRemoteDataSourceImpl({
    required this.firestore,
    required this.storage,
    required this.auth,
  });

  @override
  Future<SellerStats> getSellerStats() async {
    // Mock data with enriched statistics for now as it aggregates many things
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
    String imageUrl = product.image;
    if (imageFile != null) {
      final ref = storage.ref().child('products/${DateTime.now().toIso8601String()}');
      await ref.putFile(imageFile);
      imageUrl = await ref.getDownloadURL();
    }

    await firestore.collection('products').add({
      'sellerId': auth.currentUser?.uid,
      'title': product.title,
      'price': product.price,
      'description': product.description,
      'category': product.category,
      'image': imageUrl,
      'rating': product.rating,
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
