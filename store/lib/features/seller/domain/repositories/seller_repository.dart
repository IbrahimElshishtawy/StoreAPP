import 'package:dartz/dartz.dart';
import 'package:store/core/error/failures.dart';
import 'package:store/features/seller/domain/entities/seller_stats.dart';
import 'package:store/features/products/domain/entities/product_entity.dart';

abstract class SellerRepository {
  Future<Either<Failure, SellerStats>> getSellerStats();
  Future<Either<Failure, Unit>> addProduct(ProductEntity product);
  Future<Either<Failure, Unit>> updateProduct(ProductEntity product);
  Future<Either<Failure, Unit>> deleteProduct(String productId);
}
