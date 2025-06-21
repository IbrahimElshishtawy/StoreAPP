import 'dart:convert';

import 'package:http/http.dart' as http;

class AllCategoriesService {
  Future<List<dynamic>> getAllCategories() async {
    http.Response response = await http.get(
      Uri.parse('https://fakestoreapi.com/products/categories'),
    );
    // Make a GET request to the API to fetch all categories
    List<dynamic> data = jsonDecode(response.body);
    // Decode the response body to a list of dynamic objects
    return data;
  }
}
