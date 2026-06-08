import 'package:dartz/dartz.dart';
import 'package:store/core/error/failures.dart';
import 'package:store/features/cart/domain/entities/cart_item.dart';
import 'package:store/features/cart/domain/repositories/cart_repository.dart';

class PlaceOrderUseCase {
  final CartRepository repository;

  PlaceOrderUseCase(this.repository);

  Future<Either<Failure, void>> call({
    required List<CartItem> items,
    required double totalAmount,
    required String paymentMethod,
  }) async {
    return await repository.placeOrder(
      items: items,
      totalAmount: totalAmount,
      paymentMethod: paymentMethod,
    );
  }
}
