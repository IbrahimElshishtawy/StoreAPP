import 'package:dartz/dartz.dart';
import 'package:store/core/error/failures.dart';
import 'package:store/features/products/domain/entities/product_entity.dart';
import 'package:store/features/products/domain/repositories/product_repository.dart';
import 'package:store/features/products/data/datasources/product_remote_data_source.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;

  ProductRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<ProductEntity>>> getProducts() async {
    return const Right([]);
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> getProductsByCategory(String category) async {
    return const Right([]);
  }
}
