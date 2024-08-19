import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:paramedix/api/api_endpoints.dart';
import 'package:paramedix/api/middleware.dart';
import 'package:paramedix/api/models/home/appointment_model.dart';
import 'package:paramedix/api/models/home/category_model.dart';
import 'package:paramedix/api/models/clinic_model.dart';
import 'package:paramedix/api/models/home/education_model.dart';
import 'package:paramedix/api/models/home/facility_model.dart';
import 'package:paramedix/api/models/home/location_model.dart';
import 'package:paramedix/api/models/home/questionnaire_model.dart';
import 'package:paramedix/api/models/home/services_model.dart';
import 'package:paramedix/api/models/home/user_model.dart';

class HomeService {
  final middleware = Middleware();

  //Education Categories
  Future<List<CategoryItem>> getsEducationCategories() async {
    final response = await middleware.middlewareRequest(ApiEndpoints.baseUrl + ApiEndpoints.educationCategories, method: 'GET');
    try {
      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        return CategoryModel.fromJson(data).getResults();
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  //Education
  Future<int> getsEducationCount(category) async {
    final response = await middleware.middlewareRequest(ApiEndpoints.baseUrl + ApiEndpoints.educations + "?category=$category", method: 'GET');
    try {
      if (response.statusCode == 200) {
        final dataCount = jsonDecode(utf8.decode(response.bodyBytes));
        return EducationModel.fromJson(dataCount).getCount();
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<EducationItem>> getsEducationSearch(category, pageSize) async {
    final response = await middleware.middlewareRequest(ApiEndpoints.baseUrl + ApiEndpoints.educations + "?category=$category&page_size=$pageSize", method: 'GET');
    try {
      if (response.statusCode == 200) {
        final dataSearch = jsonDecode(utf8.decode(response.bodyBytes));
        return EducationModel.fromJson(dataSearch).getResults();
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<EducationItem>> getsEducation(category, page, pageSize) async {
    final response = await middleware.middlewareRequest(ApiEndpoints.baseUrl + ApiEndpoints.educations + "?category=$category&page=$page&page_size=$pageSize", method: 'GET');
    try {
      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        return EducationModel.fromJson(data).getResults();
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  //Questionnaire Categories
  Future<List<CategoryItem>> getsQuestionnaireCategories() async {
    final response = await middleware.middlewareRequest(ApiEndpoints.baseUrl + ApiEndpoints.questionnaireCategories, method: 'GET');
    try {
      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        return CategoryModel.fromJson(data).getResults();
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  //HIV Questionnaire
  Future<List<QuestionnaireItem>> getsHivQuestionnaire(category) async {
    final response = await middleware.middlewareRequest(ApiEndpoints.baseUrl + ApiEndpoints.questionnaires + "?category=$category", method: 'GET');
    try {
      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        return QuestionnaireModel.fromJson(data).getResults();
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  //Counseling Categories
  Future<List<CategoryItem>> getsCounselingCategories() async {
    final response = await middleware.middlewareRequest(ApiEndpoints.baseUrl + ApiEndpoints.counselingCategories, method: 'GET');
    try {
      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        return CategoryModel.fromJson(data).getResults();
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  //Counseling
  Future<int> getsServiceCount() async {
    final response = await middleware.middlewareRequest(ApiEndpoints.baseUrl + ApiEndpoints.services, method: 'GET');
    try {
      if (response.statusCode == 200) {
        final dataCount = jsonDecode(utf8.decode(response.bodyBytes));
        return ServicesModel.fromJson(dataCount).getCount();
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<ServicesItem>> getsService(pageSize) async {
    final response = await middleware.middlewareRequest(ApiEndpoints.baseUrl + ApiEndpoints.services + "?page_size=$pageSize", method: 'GET');
    try {
      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        return ServicesModel.fromJson(data).getResultsService();
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<int> getsLocationCount() async {
    final response = await middleware.middlewareRequest(ApiEndpoints.baseUrl + ApiEndpoints.locations, method: 'GET');
    try {
      if (response.statusCode == 200) {
        final dataCount = jsonDecode(utf8.decode(response.bodyBytes));
        return LocationModel.fromJson(dataCount).getCount();
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<LocationItem>> getsLocation(pageSize) async {
    final response = await middleware.middlewareRequest(ApiEndpoints.baseUrl + ApiEndpoints.locations + "?page_size=$pageSize", method: 'GET');
    try {
      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        return LocationModel.fromJson(data).getResultsLocation();
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  //Find Facility
  Future<List<FacilityItem>> getsNearbyFacility(service, location, latitute, longitude) async {
    final response = await middleware.middlewareRequest(ApiEndpoints.baseUrl + ApiEndpoints.clinics + "?services=$service&location=$location&current_latitude=$latitute&current_longitude=$longitude", method: 'GET');
    try {
      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        return FacilityModel.fromJson(data).getResultsNearbyFacility();
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<FacilityItem>> getsNearbyFacilityService(service, latitute, longitude) async {
    final response = await middleware.middlewareRequest(ApiEndpoints.baseUrl + ApiEndpoints.clinics + "?service=$service&current_latitude=$latitute&current_longitude=$longitude", method: 'GET');
    try {
      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        return FacilityModel.fromJson(data).getResultsNearbyFacility();
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<FacilityItem>> getsNearbyFacilityLocation(location, latitute, longitude) async {
    final response = await middleware.middlewareRequest(ApiEndpoints.baseUrl + ApiEndpoints.clinics + "?location=$location&current_latitude=$latitute&current_longitude=$longitude", method: 'GET');
    try {
      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        return FacilityModel.fromJson(data).getResultsNearbyFacility();
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  //Appointment Categories
  Future<List<CategoryItem>> getsAppointmentCategories() async {
    final response = await middleware.middlewareRequest(ApiEndpoints.baseUrl + ApiEndpoints.appointmentCategories, method: 'GET');
    try {
      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        return CategoryModel.fromJson(data).getResults();
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  //Appointments
  Future<http.Response> updateAppointments(int id, updateAppointmentData) async {
    try {
      final response = await middleware.middlewareRequest(
        ApiEndpoints.baseUrl + ApiEndpoints.appointments + '/$id',
        method: 'PUT',
        body: updateAppointmentData,
      );
      return response;
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  //Meet Our Doctor
  Future<http.Response> postMeetOurDoctorAppointment(int type, int specialist, String date, int map) async {
    final response = await middleware.middlewareRequest(ApiEndpoints.baseUrl + ApiEndpoints.appointments, method: 'POST', body: {
      'type': 1,
      'specialist': specialist,
      'date': date,
      'map': map,
    });
    return response;
  }

  //Specialist
  Future<List<UserItem>> getsSpecialist() async {
    final response = await middleware.middlewareRequest(ApiEndpoints.baseUrl + ApiEndpoints.users + "?is_staff=true", method: 'GET');
    try {
      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        return UserModel.fromJson(data).getResults();
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<ClinicItem>> getsFacility() async {
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

  //Doctor Info
  Future<int> getsDoctorInfoCount() async {
    final response = await middleware.middlewareRequest(ApiEndpoints.baseUrl + ApiEndpoints.users + "?is_staff=true", method: 'GET');
    try {
      if (response.statusCode == 200) {
        final dataCount = jsonDecode(utf8.decode(response.bodyBytes));
        return UserModel.fromJson(dataCount).getCount();
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<UserItem>> getsDoctorInfo(page, pageSize) async {
    final response = await middleware.middlewareRequest(ApiEndpoints.baseUrl + ApiEndpoints.users + "?is_staff=true&page=$page&page_size=$pageSize", method: 'GET');
    try {
      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        return UserModel.fromJson(data).getResults();
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  //HIV Test
  Future<http.Response> postHIVTestingAppointment(int type, String date, int map) async {
    final response = await middleware.middlewareRequest(ApiEndpoints.baseUrl + ApiEndpoints.appointments, method: 'POST', body: {
      'type': 2,
      'date': date,
      'map': map,
    });
    return response;
  }

  //Appointment History
  Future<int> getsUpcomingAppointmentCount() async {
    final response = await middleware.middlewareRequest(ApiEndpoints.baseUrl + ApiEndpoints.appointmentsUpcoming, method: 'GET');
    try {
      if (response.statusCode == 200) {
        final dataCount = jsonDecode(utf8.decode(response.bodyBytes));
        return AppointmentModel.fromJson(dataCount).getCount();
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<AppointmentItem>> getsUpcomingAppointment() async {
    final response = await middleware.middlewareRequest(ApiEndpoints.baseUrl + ApiEndpoints.appointmentsUpcoming, method: 'GET');
    try {
      if (response.statusCode == 200) {
        final dataCount = jsonDecode(utf8.decode(response.bodyBytes));
        return AppointmentModel.fromJson(dataCount).getResults();
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<int> getsPreviousAppointmentCount() async {
    final response = await middleware.middlewareRequest(ApiEndpoints.baseUrl + ApiEndpoints.appointmentsPrevious, method: 'GET');
    try {
      if (response.statusCode == 200) {
        final dataCount = jsonDecode(utf8.decode(response.bodyBytes));
        return AppointmentModel.fromJson(dataCount).getCount();
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<AppointmentItem>> getsPreviousAppointment(page, pageSize) async {
    final response = await middleware.middlewareRequest(ApiEndpoints.baseUrl + ApiEndpoints.appointmentsPrevious + "?page=$page&page_size=$pageSize", method: 'GET');
    try {
      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        return AppointmentModel.fromJson(data).getResults();
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
