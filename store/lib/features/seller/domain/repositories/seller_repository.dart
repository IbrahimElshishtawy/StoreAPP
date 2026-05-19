import 'package:dartz/dartz.dart';
import 'package:store/core/error/failures.dart';
import 'package:store/features/products/domain/entities/product_entity.dart';
import 'package:store/features/seller/domain/entities/seller_stats.dart';
import 'dart:io';

abstract class SellerRepository {
  Future<Either<Failure, SellerStats>> getSellerStats(String sellerId);
  Future<Either<Failure, Unit>> addProduct(ProductEntity product, File? imageFile);
  Future<Either<Failure, Unit>> updateProduct(ProductEntity product, File? imageFile);
  Future<Either<Failure, Unit>> deleteProduct(String productId);
}
