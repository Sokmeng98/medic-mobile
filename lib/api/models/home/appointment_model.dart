class AppointmentModel {
  final int counts;
  final List<AppointmentItem> results;

  AppointmentModel({
    required this.counts,
    required this.results,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    int count = json['count'];
    List<dynamic> resultsList = json['results'];
    final result = resultsList.map((item) => AppointmentItem.fromJson(item)).toList();

    return AppointmentModel(
      counts: count,
      results: result,
    );
  }

  int getCount() {
    return counts;
  }

  List<AppointmentItem> getResults() {
    return results;
  }
}

class AppointmentItem {
  final int id;
  final int user;
  final int type;
  final String date;
  final int specialist;
  final SpecialistInfo specialistInfo;
  final int map;
  final MapInfo mapInfo;
  final String status;
  final bool isActive;

  AppointmentItem({
    required this.id,
    required this.user,
    required this.type,
    required this.date,
    required this.specialist,
    required this.specialistInfo,
    required this.map,
    required this.mapInfo,
    required this.status,
    required this.isActive,
  });

  factory AppointmentItem.fromJson(Map<String, dynamic> json) {
    return AppointmentItem(
      id: json['id'],
      user: json['user'],
      type: json['type'],
      date: json['date'],
      specialist: json['specialist'] ?? 0,
      specialistInfo: SpecialistInfo.fromJson(json['specialist_info'] ?? {}),
      map: json['map'],
      mapInfo: MapInfo.fromJson(json['map_info']),
      status: json['status'],
      isActive: json['is_active'],
    );
  }
}

class SpecialistInfo {
  final String fullName;

  SpecialistInfo({
    required this.fullName,
  });

  factory SpecialistInfo.fromJson(Map<String, dynamic> json) {
    return SpecialistInfo(
      fullName: json['full_name'] ?? 'N/A',
    );
  }
}

class MapInfo {
  final int id;
  final String name;

  MapInfo({
    required this.id,
    required this.name,
  });

  factory MapInfo.fromJson(Map<String, dynamic> json) {
    return MapInfo(
      id: json['id'],
      name: json['name'],
    );
  }
}
