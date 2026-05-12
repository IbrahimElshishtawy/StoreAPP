import 'package:store/features/cart/domain/entities/cart_item.dart';

class CartState {
  final List<CartItem> items;
  final double totalAmount;
  final String? discountCode;
  final double discountAmount;

  CartState({
    this.items = const [],
    this.totalAmount = 0.0,
    this.discountCode,
    this.discountAmount = 0.0,
  });

  double get finalAmount => totalAmount - discountAmount;

  CartState copyWith({
    List<CartItem>? items,
    double? totalAmount,
    String? discountCode,
    double? discountAmount,
  }) {
    return CartState(
      items: items ?? this.items,
      totalAmount: totalAmount ?? this.totalAmount,
      discountCode: discountCode ?? this.discountCode,
      discountAmount: discountAmount ?? this.discountAmount,
    );
  }
}
