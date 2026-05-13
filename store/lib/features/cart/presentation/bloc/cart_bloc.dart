import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/features/cart/domain/entities/cart_item.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartState()) {
    on<AddToCart>((event, emit) {
      final updatedItems = List<CartItem>.from(state.items);
      final index = updatedItems.indexWhere((item) => item.product.id == event.item.product.id);
      if (index >= 0) {
        updatedItems[index] = CartItem(
          product: updatedItems[index].product,
          quantity: updatedItems[index].quantity + event.item.quantity,
        );
      } else {
        updatedItems.add(event.item);
      }
      emit(state.copyWith(items: updatedItems));
    });

    on<RemoveFromCart>((event, emit) {
      final updatedItems = state.items.where((item) => item.product.id != event.productId).toList();
      emit(state.copyWith(items: updatedItems));
    });

    on<UpdateQuantity>((event, emit) {
      final updatedItems = state.items.map((item) {
        if (item.product.id == event.productId) {
          return CartItem(product: item.product, quantity: event.quantity);
        }
        return item;
      }).toList();
      emit(state.copyWith(items: updatedItems));
    });

    on<ApplyCoupon>((event, emit) {
      if (event.coupon == 'DISCOUNT10') {
        emit(state.copyWith(discount: 0.1, coupon: event.coupon));
      } else if (event.coupon == 'FREE') {
        emit(state.copyWith(discount: 1.0, coupon: event.coupon));
      } else {
        emit(state.copyWith(discount: 0.0, coupon: null));
      }
    });

    on<ClearCart>((event, emit) {
      emit(CartState());
    });
  }
}
