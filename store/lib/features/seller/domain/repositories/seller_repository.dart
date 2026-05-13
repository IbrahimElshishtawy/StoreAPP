import 'package:dartz/dartz.dart';
import 'package:store/core/error/failures.dart';
import 'package:store/features/seller/domain/entities/seller_stats.dart';
import 'package:store/features/products/domain/entities/product_entity.dart';

abstract class SellerRepository {
  Future<Either<Failure, void>> uploadProduct(ProductEntity product);
  Future<Either<Failure, void>> createAd(String productId, double budget);
  Future<Either<Failure, SellerStats>> getSalesReport();
}
