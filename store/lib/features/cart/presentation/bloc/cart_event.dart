import 'package:store/features/products/domain/entities/product_entity.dart';
import 'package:store/features/cart/domain/entities/cart_item.dart';

abstract class CartEvent {}

class AddToCart extends CartEvent {
  final ProductEntity product;
  AddToCart(this.product);
}

class RemoveFromCart extends CartEvent {
  final CartItem item;
  RemoveFromCart(this.item);
}

class UpdateQuantity extends CartEvent {
  final CartItem item;
  final int quantity;
  UpdateQuantity(this.item, this.quantity);
}

class ClearCart extends CartEvent {}
