import 'package:http/http.dart' as http;

class Api {
  Future<dynamic> get({required String url}) async {
    // Yo ur implementation here
    http.Response response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception(
        'Failed to load data, status code: ${response.statusCode}',
      );
    }
  }
}
