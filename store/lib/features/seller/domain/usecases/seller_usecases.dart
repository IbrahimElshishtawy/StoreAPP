import 'package:dartz/dartz.dart';
import 'package:store/core/error/failures.dart';
import 'package:store/features/products/domain/entities/product_entity.dart';
import 'package:store/features/seller/domain/entities/seller_stats.dart';
import 'package:store/features/seller/domain/repositories/seller_repository.dart';

class GetSellerStatsUseCase {
  final SellerRepository repository;
  GetSellerStatsUseCase(this.repository);

  Future<Either<Failure, SellerStats>> call() async {
    return await repository.getSellerStats();
  }
}

class AddProductUseCase {
  final SellerRepository repository;
  AddProductUseCase(this.repository);

  Future<Either<Failure, void>> call(ProductEntity product, File? imageFile) async {
    return await repository.addProduct(product, imageFile);
  }
}

class UpdateProductUseCase {
  final SellerRepository repository;
  UpdateProductUseCase(this.repository);

  Future<Either<Failure, void>> call(ProductEntity product, File? imageFile) async {
    return await repository.updateProduct(product, imageFile);
  }
}

class DeleteProductUseCase {
  final SellerRepository repository;
  DeleteProductUseCase(this.repository);

  Future<Either<Failure, void>> call(String productId) async {
    return await repository.deleteProduct(productId);
  }
}
