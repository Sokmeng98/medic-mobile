import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:paramedix/api/api_endpoints.dart';
import 'package:paramedix/api/middleware.dart';

class AuthService {
  final middleware = Middleware();

  //Log In
  Future<http.Response> postLogin(String phoneNumber, String password) async {
    try {
      final response = await http.post(Uri.parse(ApiEndpoints.baseUrl + ApiEndpoints.login), body: {
        'phone_number': phoneNumber,
        'password': password,
      });
      return response;
    } catch (e) {
      // handle network error
      return http.Response('Error: $e', 500);
    }
  }

  //Sign Up & Create Account
  Future<http.Response> postUsers(String phoneNumber, String fullName, String dateOfBirth, String gender, String password) async {
    try {
      final response = await http.post(Uri.parse(ApiEndpoints.baseUrl + ApiEndpoints.users), body: {
        'phone_number': phoneNumber,
        'full_name': fullName,
        'date_of_birth': dateOfBirth,
        'gender': gender,
        'is_superuser': 'false',
        'password': password,
      });
      return response;
    } catch (e) {
      // handle network error
      return http.Response('Error: $e', 500);
    }
  }

  //Forget Password
  Future<http.Response> postForgetPassword(String phoneNumber) async {
    try {
      final response = await http.post(Uri.parse(ApiEndpoints.baseUrl + ApiEndpoints.forgetPassword), body: {
        'phone_number': phoneNumber,
      });
      return response;
    } catch (e) {
      return http.Response('Error: $e', 500);
    }
  }

  // Verify otp
  Future<http.Response> postVerifiedOTP(String phoneNumber, String otp) async {
    try {
      final response = await http.post(Uri.parse(ApiEndpoints.baseUrl + ApiEndpoints.verifiedOTP), body: {
        'phone_number': phoneNumber,
        'otp': otp,
      });
      return response;
    } catch (e) {
      return http.Response('Error: $e', 500);
    }
  }

  //Reset Password
  Future<http.Response> postResetPassword(String phoneNumber, String password) async {
    final response = await middleware.middlewareRequest(ApiEndpoints.baseUrl + ApiEndpoints.resetPassword, method: 'POST', body: {
      'phone_number': phoneNumber,
      'password': password,
    });
    return response;
  }

  //Change Password
  Future<http.Response> updateChangePassword(String phoneNumber, String password) async {
    final response = await middleware.middlewareRequest(ApiEndpoints.baseUrl + ApiEndpoints.changePassword + '/:id', method: 'PUT', body: {
      'phone_number': phoneNumber,
      'password': password
    });
    return response;
  }
}
