import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Api {
  /// GET request
  Future<dynamic> get({required String url}) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('GET failed: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('GET error: $e');
    }
  }

  /// POST request
  Future<dynamic> post({
    required String url,
    required dynamic body,
    String? token,
  }) async {
    try {
      final headers = <String, String>{
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };

      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return jsonDecode(response.body);
      } else {
        throw Exception('POST failed: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      throw Exception('POST error: $e');
    }
  }

  /// PUT request
  Future<dynamic> put({
    required String url,
    required dynamic body,
    String? token,
  }) async {
    try {
      final headers = <String, String>{
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };

      final response = await http.put(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return jsonDecode(response.body);
      } else {
        throw Exception('PUT failed: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      throw Exception('PUT error: $e');
    }
  }
}
