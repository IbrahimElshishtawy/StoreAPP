import 'package:store/core/network/dio_client.dart';

abstract class ProductRemoteDataSource {
  // Add remote data source methods here
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final DioClient dioClient;

  ProductRemoteDataSourceImpl(this.dioClient);
}
