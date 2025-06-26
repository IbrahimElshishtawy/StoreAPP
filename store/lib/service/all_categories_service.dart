import 'dart:convert';
import 'package:store/helper/api.dart';

class AllCategoriesService {
  Future<List<String>> getAllCategories() async {
    final responseData = await Api().get(
      url: 'https://fakestoreapi.com/products/categories',
    );

    if (responseData is List) {
      return responseData.map((item) => item.toString()).toList();
    } else {
      throw Exception("Unexpected response format: expected List");
    }
  }
}
