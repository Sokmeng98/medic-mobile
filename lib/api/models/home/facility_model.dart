class FacilityModel {
  final List<FacilityItem> results;

  FacilityModel({
    required this.results,
  });

  factory FacilityModel.fromJson(Map<String, dynamic> json) {
    List<dynamic> resultsList = json['results'];
    final result = resultsList.map((item) => FacilityItem.fromJson(item)).toList();

    return FacilityModel(
      results: result,
    );
  }

  List<FacilityItem> getResultsNearbyFacility() {
    return results;
  }
}

class FacilityItem {
  final int id;
  final String image;
  final String name;
  final String description;
  final double distance;
  final List contacts;
  final int location;
  final LocationInfo locationInfo;
  final List services;
  final List<dynamic> serviceInfo;
  final bool isActive;

  FacilityItem({
    required this.id,
    required this.image,
    required this.name,
    required this.description,
    required this.distance,
    required this.contacts,
    required this.location,
    required this.locationInfo,
    required this.services,
    required this.serviceInfo,
    required this.isActive,
  });

  factory FacilityItem.fromJson(Map<String, dynamic> json) {
    return FacilityItem(
      id: json['id'],
      image: json['image'],
      name: json['name'],
      description: json['description'],
      distance: json['distance'],
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
