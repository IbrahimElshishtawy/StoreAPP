import 'package:dartz/dartz.dart';
import 'package:store/core/error/failures.dart';
import 'package:store/features/cart/data/datasources/cart_remote_data_source.dart';
import 'package:store/features/cart/domain/entities/cart_item.dart';
import 'package:store/features/cart/domain/repositories/cart_repository.dart';

class CartRepositoryImpl implements CartRepository {
  final CartRemoteDataSource remoteDataSource;

  CartRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, void>> placeOrder({
    required List<CartItem> items,
    required double totalAmount,
    required String paymentMethod,
    double discountApplied = 0.0,
  }) async {
    try {
      await remoteDataSource.placeOrder(
        items: items,
        totalAmount: totalAmount,
        paymentMethod: paymentMethod,
        discountApplied: discountApplied,
      );
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
