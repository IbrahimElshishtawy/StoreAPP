import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DioClient {
  final Dio dio;
  final SharedPreferences sharedPreferences;

  DioClient(this.dio, this.sharedPreferences) {
    dio.options.baseUrl = 'https://api.example.com';
    dio.options.connectTimeout = const Duration(seconds: 10);
    dio.options.receiveTimeout = const Duration(seconds: 10);

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = sharedPreferences.getString('jwt_token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) {
          // Handle global errors here
          return handler.next(e);
        },
      ),
    );
  }
}
