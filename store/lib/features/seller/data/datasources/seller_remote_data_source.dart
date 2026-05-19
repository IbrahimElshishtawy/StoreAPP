import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:store/features/products/domain/entities/product_entity.dart';
import 'package:store/features/seller/domain/entities/seller_stats.dart';
import 'dart:io';

abstract class SellerRemoteDataSource {
  Future<SellerStats> getSellerStats(String sellerId);
  Future<void> addProduct(ProductEntity product, File? imageFile);
  Future<void> updateProduct(ProductEntity product, File? imageFile);
  Future<void> deleteProduct(String productId);
}

class SellerRemoteDataSourceImpl implements SellerRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseStorage storage;

  SellerRemoteDataSourceImpl({required this.firestore, required this.storage});

  @override
  Future<SellerStats> getSellerStats(String sellerId) async {
    // In a real app, we'd fetch this from Firestore
    // For now, simulate fetching
    await Future.delayed(const Duration(milliseconds: 500));
    return const SellerStats(
      totalSales: 15000.0,
      totalOrders: 50,
      dailySales: [120, 250, 180, 320, 270, 450, 380],
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
      'title': product.title,
      'price': product.price,
      'description': product.description,
      'category': product.category,
      'image': imageUrl,
      'rating': {'rate': product.rating, 'count': product.ratingCount},
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

    await firestore.collection('products').doc(product.id.toString()).update({
      'title': product.title,
      'price': product.price,
      'description': product.description,
      'category': product.category,
      'image': imageUrl,
    });
  }

  @override
  Future<void> deleteProduct(String productId) async {
    await firestore.collection('products').doc(productId).delete();
  }
}
