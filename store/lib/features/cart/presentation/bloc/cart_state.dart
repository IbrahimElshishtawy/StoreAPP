import 'package:store/features/cart/domain/entities/cart_item.dart';

class CartState {
  final List<CartItem> items;
  final double discount;
  final String? coupon;

  CartState({
    this.items = const [],
    this.discount = 0.0,
    this.coupon,
  });

  double get subtotal => items.fold(0, (sum, item) => sum + (item.product.price * item.quantity));
  double get total => subtotal * (1 - discount);

  CartState copyWith({
    List<CartItem>? items,
    double? discount,
    String? coupon,
  }) {
    return CartState(
      items: items ?? this.items,
      discount: discount ?? this.discount,
      coupon: coupon ?? this.coupon,
    );
  }
}
