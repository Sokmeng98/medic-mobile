import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:paramedix/api/api_endpoints.dart';
import 'package:paramedix/api/middleware.dart';
import 'package:paramedix/api/models/notification_model.dart';

class NotificationServiceUrl {
  final middleware = Middleware();

  Future<http.Response> postRegisterDevice(String devicePlatform, String deviceToken) async {
    try {
      final response = await middleware.middlewareRequest(ApiEndpoints.baseUrl + ApiEndpoints.registerDevice, method: 'POST', body: {
        'token': deviceToken,
        'platform': devicePlatform,
      });
      return response;
    } catch (e) {
      // handle network error
      return http.Response('Error: $e', 500);
    }
  }

  Future<http.Response> deleteRegisterDevice(String subscriptionID) async {
    try {
      final response = await middleware.middlewareRequest(ApiEndpoints.baseUrl + ApiEndpoints.deleteRegisterDevice + "?token=$subscriptionID", method: 'DELETE');
      return response;
    } catch (e) {
      // handle network error
      return http.Response('Error: $e', 500);
    }
  }

  Future<int> getsNotificationCount(user) async {
    final response = await middleware.middlewareRequest(ApiEndpoints.baseUrl + ApiEndpoints.notification + "?user=$user", method: 'GET');
    try {
      if (response.statusCode == 200) {
        final dataCount = jsonDecode(utf8.decode(response.bodyBytes));
        return NotificationModel.fromJson(dataCount).getCount();
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<NotificationItem>> getsNotification(user, page, pageSize) async {
    final response = await middleware.middlewareRequest(ApiEndpoints.baseUrl + ApiEndpoints.notification + "?user=$user&page=$page&page_size=$pageSize", method: 'GET');
    try {
      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        return NotificationModel.fromJson(data).getResults();
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
