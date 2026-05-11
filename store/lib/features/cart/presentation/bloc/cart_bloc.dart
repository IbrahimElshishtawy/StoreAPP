import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/features/cart/presentation/bloc/cart_event.dart';
import 'package:store/features/cart/presentation/bloc/cart_state.dart';
import 'package:store/features/cart/domain/entities/cart_item.dart';

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

      emit(CartState(
        items: updatedItems,
        totalAmount: _calculateTotal(updatedItems),
      ));
    });

    on<RemoveFromCart>((event, emit) {
      final updatedItems = state.items.where((item) => item.product.id != event.productId).toList();
      emit(CartState(
        items: updatedItems,
        totalAmount: _calculateTotal(updatedItems),
      ));
    });

    on<UpdateQuantity>((event, emit) {
      final updatedItems = state.items.map((item) {
        if (item.product.id == event.productId) {
          return CartItem(product: item.product, quantity: event.quantity);
        }
        return item;
      }).toList();

      emit(CartState(
        items: updatedItems,
        totalAmount: _calculateTotal(updatedItems),
      ));
    });

    on<ClearCart>((event, emit) {
      emit(CartState());
    });
  }

  double _calculateTotal(List<CartItem> items) {
    return items.fold(0, (sum, item) => sum + (item.product.price * item.quantity));
  }
}
