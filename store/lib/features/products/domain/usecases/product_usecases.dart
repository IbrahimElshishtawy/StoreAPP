import 'package:dartz/dartz.dart';
import 'package:store/core/error/failures.dart';
import 'package:store/features/products/domain/entities/product_entity.dart';
import 'package:store/features/products/domain/repositories/product_repository.dart';

class GetProductsUseCase {
  final ProductRepository repository;
  GetProductsUseCase(this.repository);

  Future<Either<Failure, List<ProductEntity>>> call() async {
    return await repository.getProducts();
  }
}

class GetProductsByCategoryUseCase {
  final ProductRepository repository;
  GetProductsByCategoryUseCase(this.repository);

  Future<Either<Failure, List<ProductEntity>>> call(String category) async {
    return await repository.getProductsByCategory(category);
  }
}
