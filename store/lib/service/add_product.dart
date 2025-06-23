import 'package:store/helper/api.dart';
import 'package:store/models/prodect_model.dart';

class AddProduct {
  Future<Product_model> addproduct({
    required String title,
    required String description,
    required double price,
    required String image,
    required String category,
    String? token,
  }) async {
    Map<String, dynamic> data = await Api().post(
      url: 'https://fakestoreapi.com/products',
      body: {
        'title': title,
        'price': price,
        'description': description,
        'image': image,
        'category': category,
      },
      token: null,
    );
    return Product_model.fromJson(data);
  }
}
