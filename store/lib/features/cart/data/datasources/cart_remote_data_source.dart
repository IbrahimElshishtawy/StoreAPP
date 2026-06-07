import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:store/features/cart/domain/entities/cart_item.dart';

abstract class CartRemoteDataSource {
  Future<void> placeOrder({
    required List<CartItem> items,
    required double totalAmount,
    required String paymentMethod,
  });
}

class CartRemoteDataSourceImpl implements CartRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  CartRemoteDataSourceImpl({required this.firestore, required this.auth});

  @override
  Future<void> placeOrder({
    required List<CartItem> items,
    required double totalAmount,
    required String paymentMethod,
  }) async {
    final user = auth.currentUser;
    if (user == null) throw Exception("User not authenticated");

    final orderRef = firestore.collection('orders').doc();
    final itemsMap = items.map((item) => {
      'id': item.product.id,
      'title': item.product.title,
      'price': item.product.price,
      'quantity': item.quantity,
    }).toList();

    await orderRef.set({
      'orderId': orderRef.id,
      'userId': user.uid,
      'items': itemsMap,
      'totalPrice': totalAmount,
      'paymentMethod': paymentMethod,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}
