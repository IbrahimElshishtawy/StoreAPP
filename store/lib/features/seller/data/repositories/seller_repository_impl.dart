import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:store/core/error/failures.dart';
import 'package:store/features/products/domain/entities/product_entity.dart';
import 'package:store/features/seller/data/datasources/seller_remote_data_source.dart';
import 'package:store/features/seller/domain/entities/seller_stats.dart';
import 'package:store/features/seller/domain/repositories/seller_repository.dart';

class SellerRepositoryImpl implements SellerRepository {
  final SellerRemoteDataSource remoteDataSource;

  SellerRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, void>> addProduct(ProductEntity product, File? imageFile) async {
    try {
      await remoteDataSource.addProduct(product, imageFile);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteProduct(String productId) async {
    try {
      await remoteDataSource.deleteProduct(productId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, SellerStats>> getSellerStats() async {
    try {
      final stats = await remoteDataSource.getSellerStats();
      return Right(stats);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateProduct(ProductEntity product, File? imageFile) async {
    try {
      await remoteDataSource.updateProduct(product, imageFile);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
