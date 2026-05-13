import 'package:dartz/dartz.dart';
import 'package:store/core/error/failures.dart';
import 'package:store/features/products/domain/entities/product_entity.dart';
import 'package:store/features/seller/domain/repositories/seller_repository.dart';

class UploadProduct {
  final SellerRepository repository;
  UploadProduct(this.repository);

  Future<Either<Failure, void>> call(ProductEntity product) async {
    return await repository.uploadProduct(product);
  }
}
