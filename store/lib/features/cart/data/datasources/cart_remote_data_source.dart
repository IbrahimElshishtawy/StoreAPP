import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:store/core/network/payment_service.dart';
import 'package:store/features/cart/domain/entities/cart_item.dart';

abstract class CartRemoteDataSource {
  Future<void> placeOrder({
    required List<CartItem> items,
    required double totalAmount,
    required String paymentMethod,
    double discountApplied = 0.0,
  });
}

class CartRemoteDataSourceImpl implements CartRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  final PaymentService paymentService;

  CartRemoteDataSourceImpl({
    required this.firestore,
    required this.auth,
    required this.paymentService,
  });

  @override
  Future<void> placeOrder({
    required List<CartItem> items,
    required double totalAmount,
    required String paymentMethod,
    double discountApplied = 0.0,
  }) async {
    final user = auth.currentUser;
    if (user == null) throw Exception("User not authenticated");

    final bool paymentSuccess = paymentMethod == 'Stripe'
        ? await paymentService.processStripePayment(totalAmount)
        : await paymentService.processPayPalPayment(totalAmount);

    if (!paymentSuccess) throw Exception("Payment failed");

    final orderRef = firestore.collection('orders').doc();
    final itemsData = items
        .map(
          (item) => {
            'id': item.product.id,
            'title': item.product.title,
            'price': item.product.price,
            'quantity': item.quantity,
          },
        )
        .toList();

    await orderRef.set({
      'orderId': orderRef.id,
      'userId': user.uid,
      'items': itemsData,
      'totalPrice': totalAmount,
      'discountApplied': discountApplied,
      'paymentMethod': paymentMethod,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}
