import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:paramedix/main.dart';
import 'package:paramedix/api/api_endpoints.dart';
import 'package:paramedix/components/router.dart';

class Middleware {
  Map<String, String> headers = {
    'Content-Type': 'application/json'
  };

  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<String?> getRefreshToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('refreshToken');
  }

  //Refresh Token
  Future<http.Response> refreshToken() async {
    final String? refreshToken = await getRefreshToken();
    print("Resfresh token: $refreshToken");
    final response = http.post(Uri.parse(ApiEndpoints.baseUrl + ApiEndpoints.refreshtoken), body: {
      'refresh': refreshToken,
    });
    return response;
  }

  Future<http.Response> sendRequest(Uri uri, String method, Map<String, dynamic>? body, String? fileKey, String? file) async {
    if (file != null && fileKey != null) {
      // If a file and fileKey are provided, create a multipart request
      final request = http.MultipartRequest(method, uri)..headers.addAll(headers);

      if (body != null) {
        for (var entry in body.entries) {
          request.fields[entry.key] = entry.value.toString();
        }
      }
      // Add the file to the request with the specified key
      print("file: $file");
      request.files.add(await http.MultipartFile.fromPath(fileKey, file, contentType: new MediaType('image', 'jpeg')));

      final streamedResponse = await request.send();
      return http.Response.fromStream(streamedResponse);
    } else {
      switch (method) {
        case 'GET':
          return await http.get(uri, headers: headers);
        case 'POST':
          return await http.post(uri, headers: headers, body: jsonEncode(body));
        case 'PUT':
          return await http.put(uri, headers: headers, body: jsonEncode(body));
        case 'DELETE':
          return await http.delete(uri, headers: headers);
        default:
          throw Exception('Unsupported HTTP method: $method');
      }
    }
  }

  Future<http.Response> middlewareRequest(String url, {String method = 'GET', body, fileKey, file}) async {
    final middleware = Middleware();
    final String? token = await getToken();

    headers['Authorization'] = 'Bearer $token';

    final Uri uri = Uri.parse(url);
    final response = await sendRequest(uri, method, body, fileKey, file);

    if (response.statusCode == 401) {
      // Token expired, refresh and retry.
      print("Token expired");
      final response = await middleware.refreshToken();
      if (response.statusCode == 200) {
        print("Refresh token");
        Map<String, dynamic> data = jsonDecode(response.body);
        headers['Authorization'] = 'Bearer ${data['access']}';
        return sendRequest(uri, method, body, fileKey, file);
      } else {
        print("Request failed with status code: ${response.statusCode}");
        Navigator.pushNamed(navigatorKey.currentContext!, loginRoute);
      }
    }
    return response;
  }
}
