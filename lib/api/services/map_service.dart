import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:paramedix/api/api_endpoints.dart';
import 'package:paramedix/api/middleware.dart';
import 'package:paramedix/api/models/clinic_model.dart';

class MapService {
  final middleware = Middleware();

  //Clinics
  Future<List<ClinicItem>> getClinics() async {
    final response = await middleware.middlewareRequest(ApiEndpoints.baseUrl + ApiEndpoints.clinics, method: 'GET');
    try {
      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        return ClinicModel.fromJson(data).getResults();
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<dynamic> getClinicById(id) async {
    final response = await middleware.middlewareRequest(ApiEndpoints.baseUrl + ApiEndpoints.clinics + '/$id', method: 'GET');
    return jsonDecode(utf8.decode(response.bodyBytes));
  }

  Future<List> getLocations() async {
    final response = await middleware.middlewareRequest(ApiEndpoints.baseUrl + ApiEndpoints.locations, method: 'GET');
    return jsonDecode(utf8.decode(response.bodyBytes))['results'];
  }

  //Phone Systems
  Future<http.Response> getsPhoneSystems() async {
    final response = await middleware.middlewareRequest(ApiEndpoints.baseUrl + ApiEndpoints.phoneSystems, method: 'GET');
    return response;
  }

  Future<http.Response> getPhoneSystems() async {
    final response = await middleware.middlewareRequest(ApiEndpoints.baseUrl + ApiEndpoints.phoneSystems, method: 'GET');
    return response;
  }

  //Contacts
  Future<http.Response> getsContacts() async {
    final response = await middleware.middlewareRequest(ApiEndpoints.baseUrl + ApiEndpoints.contacts, method: 'GET');
    return response;
  }

  Future<http.Response> getContacts() async {
    final response = await middleware.middlewareRequest(ApiEndpoints.baseUrl + ApiEndpoints.contacts, method: 'GET');
    return response;
  }

  //Services
  Future<http.Response> getsServices() async {
    final response = await middleware.middlewareRequest(ApiEndpoints.baseUrl + ApiEndpoints.services, method: 'GET');
    return response;
  }

  Future<http.Response> getServices() async {
    final response = await middleware.middlewareRequest(ApiEndpoints.baseUrl + ApiEndpoints.services, method: 'GET');
    return response;
  }
}
