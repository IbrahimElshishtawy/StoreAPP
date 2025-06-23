import 'package:store/helper/api.dart';
import 'package:store/models/prodect_model.dart';

class UpdataProduct {
  Future<Product_model> updataProduct({
    required String title,
    required String description,
    required double price,
    required String image,
    required String category,
    String? token,
    required int id,
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
