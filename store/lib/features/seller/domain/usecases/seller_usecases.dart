import 'package:dartz/dartz.dart';
import 'package:store/core/error/failures.dart';
import 'package:store/features/products/domain/entities/product_entity.dart';
import 'package:store/features/seller/domain/repositories/seller_repository.dart';

class AddProductUseCase {
  final SellerRepository repository;
  AddProductUseCase(this.repository);

  Future<Either<Failure, Unit>> call(ProductEntity product) async {
    return await repository.addProduct(product);
  }
}

class UpdateProductUseCase {
  final SellerRepository repository;
  UpdateProductUseCase(this.repository);

  Future<Either<Failure, Unit>> call(ProductEntity product) async {
    return await repository.updateProduct(product);
  }
}

class DeleteProductUseCase {
  final SellerRepository repository;
  DeleteProductUseCase(this.repository);

  Future<Either<Failure, Unit>> call(String productId) async {
    return await repository.deleteProduct(productId);
  }
}
