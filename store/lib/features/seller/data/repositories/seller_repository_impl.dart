import 'package:dartz/dartz.dart';
import 'package:store/core/error/failures.dart';
import 'package:store/features/products/domain/entities/product_entity.dart';
import 'package:store/features/products/data/models/product_model.dart';
import 'package:store/features/seller/domain/entities/seller_stats.dart';
import 'package:store/features/seller/domain/repositories/seller_repository.dart';
import 'package:store/features/seller/data/datasources/seller_remote_data_source.dart';

class SellerRepositoryImpl implements SellerRepository {
  final SellerRemoteDataSource remoteDataSource;
  SellerRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, void>> uploadProduct(ProductEntity product) async {
    try {
      final model = ProductModel(
        id: product.id,
        title: product.title,
        category: product.category,
        price: product.price,
        image: product.image,
        description: product.description,
        rating: product.rating,
        ratingCount: product.ratingCount,
      );
      await remoteDataSource.uploadProduct(model);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> createAd(String productId, double budget) async {
    try {
      await remoteDataSource.createAd(productId, budget);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, SellerStats>> getSalesReport() async {
    try {
      final report = await remoteDataSource.getSalesReport();
      return Right(report);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
