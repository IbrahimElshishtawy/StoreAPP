import 'package:store/features/cart/domain/entities/cart_item.dart';
import 'package:store/features/cart/domain/entities/coupon.dart';

class CartState {
  final List<CartItem> items;
  final double totalAmount;
  final Coupon? appliedCoupon;
  final String? error;

  CartState({
    this.items = const [],
    this.totalAmount = 0.0,
    this.appliedCoupon,
    this.error,
  });

  double get discountedTotal {
    if (appliedCoupon == null) return totalAmount;
    return totalAmount * (1 - appliedCoupon!.discountPercent / 100);
  }

  CartState copyWith({
    List<CartItem>? items,
    double? totalAmount,
    Coupon? appliedCoupon,
    String? error,
  }) {
    return CartState(
      items: items ?? this.items,
      totalAmount: totalAmount ?? this.totalAmount,
      appliedCoupon: appliedCoupon ?? this.appliedCoupon,
      error: error,
    );
  }
}
