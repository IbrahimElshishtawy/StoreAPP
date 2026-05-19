import 'package:dartz/dartz.dart';
import 'package:store/core/error/failures.dart';
import 'package:store/features/products/domain/entities/product_entity.dart';
import 'package:store/features/seller/domain/repositories/seller_repository.dart';
import 'dart:io';

class UpdateProductUseCase {
  final SellerRepository repository;

  UpdateProductUseCase(this.repository);

  Future<Either<Failure, Unit>> call(ProductEntity product, File? imageFile) async {
    return await repository.updateProduct(product, imageFile);
  }
}
