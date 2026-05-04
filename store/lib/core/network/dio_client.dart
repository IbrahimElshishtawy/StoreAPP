import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DioClient {
  final Dio dio;
  final SharedPreferences sharedPreferences;

  DioClient(this.dio, this.sharedPreferences) {
    dio.options.baseUrl = 'https://api.example.com';
    dio.options.connectTimeout = const Duration(seconds: 10);
    dio.options.receiveTimeout = const Duration(seconds: 10);
  }
}
