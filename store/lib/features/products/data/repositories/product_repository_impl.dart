import 'package:dartz/dartz.dart';
import 'package:store/core/error/failures.dart';
import 'package:store/features/products/data/models/product_model.dart';
import 'package:store/features/products/domain/entities/product_entity.dart';
import 'package:store/features/products/domain/repositories/product_repository.dart';
import 'package:store/features/products/data/datasources/product_remote_data_source.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;

  ProductRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<ProductEntity>>> getProducts() async {
    try {
      final productModels = await remoteDataSource.getProducts();
      return Right(productModels.map((model) => _mapModelToEntity(model)).toList());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> getProductsByCategory(String category) async {
    try {
      final productModels = await remoteDataSource.getProductsByCategory(category);
      return Right(productModels.map((model) => _mapModelToEntity(model)).toList());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  ProductEntity _mapModelToEntity(ProductModel model) {
    return ProductEntity(
      id: model.id,
      title: model.title ?? '',
      category: model.category ?? '',
      price: model.price ?? 0.0,
      image: model.imageUrl ?? '',
      description: model.description ?? '',
      rating: model.rating?.rate ?? 0.0,
      ratingCount: model.rating?.count ?? 0,
      isPromoted: model.isPromoted ?? false,
      hasVr: model.hasVr ?? false,
      dealTag: model.dealTag,
      originalPrice: model.originalPrice,
      arModelUrl: model.arModelUrl,
    );
  }
}
