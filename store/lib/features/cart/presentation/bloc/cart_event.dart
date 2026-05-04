import 'package:store/features/cart/domain/entities/cart_item.dart';

abstract class CartEvent {}

class AddToCart extends CartEvent {
  final CartItem item;
  AddToCart(this.item);
}

class RemoveFromCart extends CartEvent {
  final String productId;
  RemoveFromCart(this.productId);
}

class UpdateQuantity extends CartEvent {
  final String productId;
  final int quantity;
  UpdateQuantity(this.productId, this.quantity);
}

class ClearCart extends CartEvent {}
