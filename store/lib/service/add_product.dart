import 'package:store/helper/api.dart';
import 'package:store/models/prodect_model.dart';

class AddProduct {
  Future<ProductModel> addProduct({
    required String title,
    required String description,
    required double price,
    required String image,
    required String category,
    String? token,
  }) async {
    final responseData = await Api().post(
      url: 'https://fakestoreapi.com/products',
      body: {
        'title': title,
        'price': price,
        'description': description,
        'image': image,
        'category': category,
      },
      token: token,
    );

    if (responseData is Map<String, dynamic>) {
      return ProductModel.fromJson(responseData);
    } else {
      throw Exception("Invalid response data: Expected Map<String, dynamic>");
    }
  }
}
