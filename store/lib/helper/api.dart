// ignore_for_file: unnecessary_brace_in_string_interps
import 'dart:convert';
import 'package:flutter/material.dart';
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

  Future<dynamic> post({
    required String url,
    @required dynamic body,
    @required dynamic token,
  }) async {
    Map<String, String> headers = {};
    if (token != null) {
      headers.addAll({'Authorization': 'Bearer $token'});
    }

    http.Response response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: body,
    );

    if (response.statusCode != 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception(
        'Failed to post data, status code: ${response.statusCode} with body: ${response.body}',
      );
    }
  }

  Future<dynamic> put({
    required String url,
    @required dynamic body,
    @required dynamic token,
  }) async {
    Map<String, String> headers = {};
    headers.addAll({'Content-Type': 'application/x-www-form-urlencoded'});
    if (token != null) {
      headers.addAll({'Authorization': 'Bearer $token'});
    }

    http.Response response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: body,
    );

    if (response.statusCode != 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception(
        'Failed to post data, status code: ${response.statusCode} with body: ${response.body}',
      );
    }
  }
}
