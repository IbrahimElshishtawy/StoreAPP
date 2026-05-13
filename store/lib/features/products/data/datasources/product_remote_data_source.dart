import 'package:store/core/network/dio_client.dart';
import 'package:store/features/products/domain/entities/product_entity.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductEntity>> getProducts();
  Future<List<ProductEntity>> getProductsByCategory(String category);
  Future<List<String>> getCategories();
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final DioClient dioClient;

  ProductRemoteDataSourceImpl(this.dioClient);

  @override
  Future<List<ProductEntity>> getProducts() async {
    final response = await dioClient.dio.get('/products');
    if (response.statusCode == 200) {
      final List data = response.data;
      return data.map((json) => _mapToEntity(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  @override
  Future<List<ProductEntity>> getProductsByCategory(String category) async {
    final response = await dioClient.dio.get('/products/category/$category');
    if (response.statusCode == 200) {
      final List data = response.data;
      return data.map((json) => _mapToEntity(json)).toList();
    } else {
      throw Exception('Failed to load products by category');
    }
  }

  @override
  Future<List<String>> getCategories() async {
    final response = await dioClient.dio.get('/products/categories');
    if (response.statusCode == 200) {
      return List<String>.from(response.data);
    } else {
      throw Exception('Failed to load categories');
    }
  }

  ProductEntity _mapToEntity(Map<String, dynamic> json) {
    return ProductEntity(
      id: json['id'].toString(),
      title: json['title'],
      category: json['category'],
      price: (json['price'] as num).toDouble(),
      image: json['image'],
      description: json['description'],
      rating: (json['rating']['rate'] as num).toDouble(),
      ratingCount: json['rating']['count'],
    );
  }
}
