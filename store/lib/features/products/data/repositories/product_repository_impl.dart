import 'package:store/features/products/domain/repositories/product_repository.dart';
import 'package:store/features/products/data/datasources/product_remote_data_source.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;

  ProductRepositoryImpl(this.remoteDataSource);
}
