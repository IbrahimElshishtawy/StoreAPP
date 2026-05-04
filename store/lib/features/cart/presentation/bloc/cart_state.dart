import 'package:store/features/cart/domain/entities/cart_item.dart';

class CartState {
  final List<CartItem> items;
  final double totalAmount;

  CartState({this.items = const [], this.totalAmount = 0.0});
}
