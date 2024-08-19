import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:paramedix/api/api_endpoints.dart';
import 'package:paramedix/api/middleware.dart';
import 'package:paramedix/api/models/profile/favorite_model.dart';
import 'package:paramedix/api/models/profile/profile_model.dart';

class ProfileService {
  final middleware = Middleware();

  //User
  Future<http.Response> getUsers() async {
    final response = await middleware.middlewareRequest(ApiEndpoints.baseUrl + ApiEndpoints.users, method: 'GET');
    return response;
  }

  Future<http.Response> updateUsers(int id, updateUserData, fileKey, file) async {
    try {
      final response = await middleware.middlewareRequest(
        ApiEndpoints.baseUrl + ApiEndpoints.users + '/$id',
        method: 'PUT',
        body: updateUserData,
        fileKey: fileKey,
        file: file,
      );
      return response;
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  //Profile
  Future<ProfileModel> getProfile() async {
    try {
      final response = await middleware.middlewareRequest(ApiEndpoints.baseUrl + ApiEndpoints.profile, method: 'GET');
      if (response.statusCode == 200) {
        final userData = jsonDecode(utf8.decode(response.bodyBytes));
        return ProfileModel.fromJson(userData);
      } else {
        throw Exception('Failed to load user data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  //Favorite
  Future<http.Response> postFavorite(int educationId) async {
    final response = await middleware.middlewareRequest(ApiEndpoints.baseUrl + ApiEndpoints.favorites, method: 'POST', body: {
      "education": educationId
    });
    try {
      return response;
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<int> getsFavoriteCount() async {
    final response = await middleware.middlewareRequest(ApiEndpoints.baseUrl + ApiEndpoints.favorites, method: 'GET');
    try {
      if (response.statusCode == 200) {
        final dataCount = jsonDecode(utf8.decode(response.bodyBytes));
        return FavoriteModel.fromJson(dataCount).getCount();
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<FavoriteItem>> getsFavorite(page, pageSize) async {
    final response = await middleware.middlewareRequest(ApiEndpoints.baseUrl + ApiEndpoints.favorites + "?page=$page&page_size=$pageSize", method: 'GET');
    try {
      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        return FavoriteModel.fromJson(data).getResults();
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<http.Response> deleteFavorite(int educationId) async {
    final response = await middleware.middlewareRequest(ApiEndpoints.baseUrl + ApiEndpoints.deletefavorite + '/$educationId', method: 'DELETE');
    try {
      return response;
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
