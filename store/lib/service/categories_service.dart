import 'dart:convert';

import 'package:http/http.dart';
import 'package:store/helper/api.dart';
import 'package:store/models/prodect_model.dart';

class CategoriesService {
  Future<List<Product_model>> getallproduct({
    required String categoryname,
  }) async {
    Response response = await Api().get(
      url: 'https://fakestoreapi.com/products/category/$categoryname',
    );

    // make a get request to the api

    List<dynamic> data = jsonDecode(response.body);
    // decode the response body to a list of dynamic objects
    List<Product_model> productsList = [];
    // create an empty list of Product_model
    for (int i = 0; i < data.length; i++) {
      // loop through the data and convert each item to a Product_model object
      productsList.add(Product_model.fromJson(data[i] as Map<String, dynamic>));
      // add the Product_model object to the list
    }
    // return the list of Product_model objects
    return productsList;
  }
}
