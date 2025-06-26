import 'package:store/helper/api.dart';
import 'package:store/models/prodect_model.dart';

class CategoriesService {
  Future<List<ProductModel>> getAllProductsByCategory({
    required String categoryName,
  }) async {
    try {
      final data = await Api().get(
        url: 'https://fakestoreapi.com/products/category/$categoryName',
      );

      if (data is List) {
        // تحويل البيانات إلى قائمة من ProductModel
        return data
            .map((item) => ProductModel.fromJson(item))
            .toList()
            .cast<ProductModel>();
      } else {
        throw Exception("❌ Expected a list but got ${data.runtimeType}");
      }
    } catch (e) {
      throw Exception("❌ Error fetching products by category: $e");
    }
  }
}
