import 'dart:convert';
import 'package:store/models/prodect_model.dart';
import 'package:http/http.dart' as http;
// import package http to make http requests

class GetAllProductSerive {
  Future<List<Product_model>> getallproduct() async {
    http.Response requestdata = await http.get(
      Uri.parse('https://fakestoreapi.com/products'),
    );

    // make a get request to the api
    List<dynamic> data = jsonDecode(requestdata.body);
    // decode the response body to a list of dynamic objects
    List<Product_model> productsList = [];
    // create an empty list of Product_model
    for (int i = 0; i < data.length; i++) {
      // loop through the data and convert each item to a Product_model object
      productsList.add(Product_model.fromJson(data[i] as Map<String, dynamic>));
      // add the Product_model object to the list
    }
    return productsList;
    // return the list of Product_model objects
  }
}
