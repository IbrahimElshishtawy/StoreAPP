import 'package:dartz/dartz.dart';
import 'package:store/core/error/failures.dart';
import 'package:store/features/cart/domain/entities/cart_item.dart';

abstract class CartRepository {
  Future<Either<Failure, void>> placeOrder({
    required List<CartItem> items,
    required double totalAmount,
    required String paymentMethod,
    double discountApplied = 0.0,
  });
}
