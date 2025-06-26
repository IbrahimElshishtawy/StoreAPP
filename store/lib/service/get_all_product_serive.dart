import 'package:store/helper/api.dart';
import 'package:store/models/prodect_model.dart';

class GetAllProductService {
  Future<List<ProductModel>> getAllProducts() async {
    try {
      final data = await Api().get(url: 'https://fakestoreapi.com/products');

      if (data is List) {
        return data
            .map((item) => ProductModel.fromJson(item))
            .toList()
            .cast<ProductModel>();
      } else {
        throw Exception("❌ Expected a list but got ${data.runtimeType}");
      }
    } catch (e) {
      throw Exception("❌ Error fetching products: $e");
    }
  }
}
