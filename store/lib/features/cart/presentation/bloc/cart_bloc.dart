import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/features/cart/domain/entities/cart_item.dart';
import 'package:store/features/cart/domain/usecases/place_order_usecase.dart';
import 'package:store/features/cart/presentation/bloc/cart_event.dart';
import 'package:store/features/cart/presentation/bloc/cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final PlaceOrderUseCase placeOrderUseCase;

  CartBloc({required this.placeOrderUseCase}) : super(CartState()) {
    on<AddToCart>((event, emit) {
      final updatedItems = List<CartItem>.from(state.items);
      final index = updatedItems.indexWhere((i) => i.product.id == event.item.product.id);

      if (index >= 0) {
        updatedItems[index] = CartItem(
          product: updatedItems[index].product,
          quantity: updatedItems[index].quantity + event.item.quantity,
        );
      } else {
        updatedItems.add(event.item);
      }

      emit(state.copyWith(
        items: updatedItems,
        totalAmount: _calculateTotal(updatedItems),
        status: CartStatus.initial,
      ));
    });

    on<RemoveFromCart>((event, emit) {
      final updatedItems = state.items.where((i) => i.product.id != event.productId).toList();
      emit(state.copyWith(
        items: updatedItems,
        totalAmount: _calculateTotal(updatedItems),
        status: CartStatus.initial,
      ));
    });

    on<UpdateQuantity>((event, emit) {
      final updatedItems = List<CartItem>.from(state.items);
      final index = updatedItems.indexWhere((i) => i.product.id == event.productId);

      if (index >= 0) {
        updatedItems[index] = CartItem(
          product: updatedItems[index].product,
          quantity: event.quantity,
        );
        emit(state.copyWith(
          items: updatedItems,
          totalAmount: _calculateTotal(updatedItems),
          status: CartStatus.initial,
        ));
      }
    });

    on<ApplyDiscountCode>((event, emit) {
      double discount = 0.0;
      if (event.code == 'SAVE10') {
        discount = state.totalAmount * 0.1;
      }
      emit(state.copyWith(
        discountCode: event.code,
        discountAmount: discount,
        status: CartStatus.initial,
      ));
    });

    on<PlaceOrderRequested>((event, emit) async {
      if (state.items.isEmpty) {
        emit(state.copyWith(status: CartStatus.error, errorMessage: "Cart is empty"));
        return;
      }

      emit(state.copyWith(status: CartStatus.loading));

      final result = await placeOrderUseCase(
        items: state.items,
        totalAmount: state.finalAmount,
        paymentMethod: event.paymentMethod,
      );

      result.fold(
        (failure) => emit(state.copyWith(status: CartStatus.error, errorMessage: failure.message)),
        (_) {
          emit(CartState(status: CartStatus.success));
        },
      );
    });

    on<ClearCart>((event, emit) {
      emit(CartState());
    });
  }

  double _calculateTotal(List<CartItem> items) {
    return items.fold(0, (sum, item) => sum + (item.product.price * item.quantity));
  }
}
