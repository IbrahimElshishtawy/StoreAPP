// ignore_for_file: unused_local_variable
import 'dart:convert';
import 'package:store/helper/api.dart';

class AllCategoriesService {
  Future<List<dynamic>> getAllCategories() async {
    List<dynamic> data = await Api().get(
      url: 'https://fakestoreapi.com/products/categories',
    );
    return data;
    // make a get request to the api and return the list of categories
  }
}
