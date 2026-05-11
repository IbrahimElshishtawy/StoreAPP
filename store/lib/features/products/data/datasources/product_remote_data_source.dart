import 'package:store/core/network/dio_client.dart';
import 'package:store/features/products/data/models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts();
  Future<List<ProductModel>> getProductsByCategory(String category);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final DioClient dioClient;

  ProductRemoteDataSourceImpl(this.dioClient);

  @override
  Future<List<ProductModel>> getProducts() async {
    final response = await dioClient.dio.get('/products');
    if (response.statusCode == 200) {
      final List data = response.data;
      return data.map((json) => ProductModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  @override
  Future<List<ProductModel>> getProductsByCategory(String category) async {
    final response = await dioClient.dio.get('/products/category/$category');
    if (response.statusCode == 200) {
      final List data = response.data;
      return data.map((json) => ProductModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products by category');
    }
  }
}
