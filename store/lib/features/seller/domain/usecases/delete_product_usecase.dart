import 'package:dartz/dartz.dart';
import 'package:store/core/error/failures.dart';
import 'package:store/features/seller/domain/repositories/seller_repository.dart';

class DeleteProductUseCase {
  final SellerRepository repository;

  DeleteProductUseCase(this.repository);

  Future<Either<Failure, Unit>> call(String productId) async {
    return await repository.deleteProduct(productId);
  }
}
