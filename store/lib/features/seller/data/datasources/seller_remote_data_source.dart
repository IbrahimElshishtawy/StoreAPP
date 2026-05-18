import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:store/features/products/domain/entities/product_entity.dart';
import 'package:store/features/seller/domain/entities/seller_stats.dart';

abstract class SellerRemoteDataSource {
  Future<SellerStats> getSellerStats();
  Future<void> addProduct(ProductEntity product, File? imageFile);
  Future<void> updateProduct(ProductEntity product, File? imageFile);
  Future<void> deleteProduct(String productId);
}

class SellerRemoteDataSourceImpl implements SellerRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseStorage storage;

  SellerRemoteDataSourceImpl({required this.firestore, required this.storage});

  @override
  Future<void> addProduct(ProductEntity product, File? imageFile) async {
    String imageUrl = product.image;

    if (imageFile != null) {
      imageUrl = await _uploadImage(imageFile);
    }

    await firestore.collection('products').add({
      'name': product.title,
      'description': product.description,
      'price': product.price,
      'imageUrl': imageUrl,
      'category': product.category,
      'createdAt': Timestamp.now(),
    });
  }

  Future<String> _uploadImage(File file) async {
    final fileName = DateTime.now().millisecondsSinceEpoch.toString();
    final ref = storage.ref().child('product_images/$fileName.jpg');
    final uploadTask = await ref.putFile(file);
    return await uploadTask.ref.getDownloadURL();
  }

  @override
  Future<void> deleteProduct(String productId) async {
    await firestore.collection('products').doc(productId).delete();
  }

  @override
  Future<SellerStats> getSellerStats() async {
    // Mocking stats from Firestore for now or calculating them
    return SellerStats(
      totalSales: 12500.0,
      totalOrders: 45,
      dailySales: [100, 200, 150, 300, 250, 400, 350],
    );
  }

  @override
  Future<void> updateProduct(ProductEntity product, File? imageFile) async {
    String imageUrl = product.image;

    if (imageFile != null) {
      imageUrl = await _uploadImage(imageFile);
    }

    await firestore.collection('products').doc(product.id).update({
      'name': product.title,
      'description': product.description,
      'price': product.price,
      'imageUrl': imageUrl,
      'category': product.category,
    });
  }
}
