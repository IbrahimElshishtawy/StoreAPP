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
    try {
      final response = await dioClient.dio.get('/products');
      if (response.statusCode == 200) {
        final List data = response.data;
        return data.map((json) => _mapJsonToModel(json)).toList();
      }
      return [];
    } catch (e) {
      throw Exception('Failed to load products');
    }
  }

  @override
  Future<List<ProductModel>> getProductsByCategory(String category) async {
    try {
      final response = await dioClient.dio.get('/products/category/$category');
      if (response.statusCode == 200) {
        final List data = response.data;
        return data.map((json) => _mapJsonToModel(json)).toList();
      }
      return [];
    } catch (e) {
      throw Exception('Failed to load products by category');
    }
  }

  ProductModel _mapJsonToModel(Map<String, dynamic> json) {
    final int? id = json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '');
    final double price = (json['price'] as num?)?.toDouble() ?? 0.0;

    return ProductModel(
      id: json['id']?.toString() ?? '',
      title: json['title'],
      category: json['category'],
      price: price,
      imageUrl: json['image'],
      description: json['description'],
      rating: json['rating'] != null ? RatingModel.fromJson(json['rating']) : null,
      isPromoted: id != null ? id % 5 == 0 : false,
      hasVr: id != null ? id % 3 == 0 : false,
      dealTag: id != null && id % 7 == 0 ? 'Special Offer' : null,
      originalPrice: price > 0 ? price * 1.2 : null,
      arModelUrl: 'assets/models/product.glb',
    );
  }
}
