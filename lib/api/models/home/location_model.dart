import 'dart:developer';

class LocationModel {
  final int counts;
  final List<LocationItem> results;

  LocationModel({
    required this.counts,
    required this.results,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    int count = json['count'];
    List<dynamic> resultsList = json['results'];
    final result = resultsList.map((item) => LocationItem.fromJson(item)).toList();

    return LocationModel(
      counts: count,
      results: result,
    );
  }

  int getCount() {
    return counts;
  }

  List<LocationItem> getResultsLocation() {
    return results;
  }
}

class Location {
  List<String> coordinates;
  Location({required this.coordinates});

  factory Location.fromJson(Map<String, dynamic> json) {
    log(json['coordinates']);
    return Location(coordinates: json['coordinates']);
  }
}

class LocationItem {
  final int id;
  final String name;
  final String address;
  final bool isActive;
  final double lat;
  final double long;

  LocationItem({
    required this.id,
    required this.name,
    required this.address,
    required this.isActive,
    required this.lat,
    required this.long,
  });

  factory LocationItem.fromJson(Map<String, dynamic> json) {
    return LocationItem(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      isActive: json['is_active'],
      lat: json['location']['coordinates'][0],
      long: json['location']['coordinates'][1],
    );
  }
}
