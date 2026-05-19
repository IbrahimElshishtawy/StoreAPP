import 'package:dartz/dartz.dart';
import 'package:store/core/error/failures.dart';
import 'package:store/features/products/domain/entities/product_entity.dart';
import 'package:store/features/seller/data/datasources/seller_remote_data_source.dart';
import 'package:store/features/seller/domain/entities/seller_stats.dart';
import 'package:store/features/seller/domain/repositories/seller_repository.dart';
import 'dart:io';

class SellerRepositoryImpl implements SellerRepository {
  final SellerRemoteDataSource remoteDataSource;

  SellerRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, SellerStats>> getSellerStats(String sellerId) async {
    try {
      final stats = await remoteDataSource.getSellerStats(sellerId);
      return Right(stats);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> addProduct(ProductEntity product, File? imageFile) async {
    try {
      await remoteDataSource.addProduct(product, imageFile);
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateProduct(ProductEntity product, File? imageFile) async {
    try {
      await remoteDataSource.updateProduct(product, imageFile);
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteProduct(String productId) async {
    try {
      await remoteDataSource.deleteProduct(productId);
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
