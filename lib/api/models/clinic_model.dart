class ClinicModel {
  final List<ClinicItem> results;

  ClinicModel({
    required this.results,
  });

  factory ClinicModel.fromJson(Map<String, dynamic> json) {
    List<dynamic> resultsList = json['results'];
    final result = resultsList.map((item) => ClinicItem.fromJson(item)).toList();

    return ClinicModel(
      results: result,
    );
  }

  List<ClinicItem> getResults() {
    return results;
  }
}

class ClinicItem {
  final int id;
  final String image;
  final String name;
  final String description;
  final List contacts;
  final int location;
  final LocationInfo locationInfo;
  final List services;
  final List<dynamic> serviceInfo;
  final bool isActive;

  ClinicItem({
    required this.id,
    required this.image,
    required this.name,
    required this.description,
    required this.contacts,
    required this.location,
    required this.locationInfo,
    required this.services,
    required this.serviceInfo,
    required this.isActive,
  });

  factory ClinicItem.fromJson(Map<String, dynamic> json) {
    return ClinicItem(
      id: json['id'],
      image: json['image'],
      name: json['name'],
      description: json['description'],
      contacts: json['contacts'],
      location: json['location'],
      locationInfo: LocationInfo.fromJson(json['location_info']),
      services: json['services'],
      serviceInfo: json['services_info'].map((item) => ServiceInfo.fromJson(item)).toList(),
      isActive: json['is_active'],
    );
  }
}

class LocationInfo {
  final int id;
  final String name;
  final String address;

  LocationInfo({
    required this.id,
    required this.name,
    required this.address,
  });

  factory LocationInfo.fromJson(Map<String, dynamic> json) {
    return LocationInfo(
      id: json['id'],
      name: json['name'],
      address: json['address'],
    );
  }
}

class ServiceInfo {
  final int id;
  final String name;
  final String icon;

  ServiceInfo({
    required this.id,
    required this.name,
    required this.icon,
  });

  factory ServiceInfo.fromJson(Map<String, dynamic> json) {
    return ServiceInfo(
      id: json['id'],
      name: json['name'],
      icon: json['icon'],
    );
  }
}
