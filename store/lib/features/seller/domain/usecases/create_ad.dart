import 'package:dartz/dartz.dart';
import 'package:store/core/error/failures.dart';
import 'package:store/features/seller/domain/repositories/seller_repository.dart';

class CreateAd {
  final SellerRepository repository;
  CreateAd(this.repository);

  Future<Either<Failure, void>> call(String productId, double budget) async {
    return await repository.createAd(productId, budget);
  }
}
