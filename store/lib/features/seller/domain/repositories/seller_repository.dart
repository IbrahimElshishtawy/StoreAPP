import 'package:dartz/dartz.dart';
import 'package:store/core/error/failures.dart';
import 'package:store/features/products/domain/entities/product_entity.dart';
import 'package:store/features/seller/domain/entities/seller_stats.dart';

abstract class SellerRepository {
  Future<Either<Failure, SellerStats>> getSellerStats();
  Future<Either<Failure, void>> addProduct(ProductEntity product, File? imageFile);
  Future<Either<Failure, void>> updateProduct(ProductEntity product, File? imageFile);
  Future<Either<Failure, void>> deleteProduct(String productId);
}
