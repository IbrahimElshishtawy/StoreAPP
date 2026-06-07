import 'package:equatable/equatable.dart';
import 'package:store/features/cart/domain/entities/cart_item.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();
  @override
  List<Object?> get props => [];
}

class AddToCart extends CartEvent {
  final CartItem item;
  const AddToCart(this.item);
  @override
  List<Object?> get props => [item];
}

class RemoveFromCart extends CartEvent {
  final String productId;
  const RemoveFromCart(this.productId);
  @override
  List<Object?> get props => [productId];
}

class UpdateQuantity extends CartEvent {
  final String productId;
  final int quantity;
  const UpdateQuantity(this.productId, this.quantity);
  @override
  List<Object?> get props => [productId, quantity];
}

class ApplyDiscountCode extends CartEvent {
  final String code;
  const ApplyDiscountCode(this.code);
  @override
  List<Object?> get props => [code];
}

class PlaceOrderRequested extends CartEvent {
  final String paymentMethod;
  const PlaceOrderRequested({required this.paymentMethod});
  @override
  List<Object?> get props => [paymentMethod];
}

class ClearCart extends CartEvent {}
