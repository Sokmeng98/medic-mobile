class NotificationModel {
  final int counts;
  final List<NotificationItem> results;

  NotificationModel({
    required this.counts,
    required this.results,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    int count = json['count'];
    List<dynamic> resultsList = json['results'];
    final result = resultsList.map((item) => NotificationItem.fromJson(item)).toList();

    return NotificationModel(
      counts: count,
      results: result,
    );
  }

  int getCount() {
    return counts;
  }

  List<NotificationItem> getResults() {
    return results;
  }
}

class NotificationItem {
  final int id;
  final String type;
  final String message;
  final int appointment;
  final AppointmentInfo appointmentInfo;

  NotificationItem({
    required this.id,
    required this.type,
    required this.message,
    required this.appointment,
    required this.appointmentInfo,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      id: json['id'],
      type: json['type'],
      message: json['message'],
      appointment: json['appointment'],
      appointmentInfo: AppointmentInfo.fromJson(json['appointment_info']),
    );
  }
}

class AppointmentInfo {
  final int id;
  final int user;
  final int type;
  final String date;
  final SpecialistInfo specialistInfo;
  final int map;
  final MapInfo mapInfo;
  final String status;
  final bool isActive;

  AppointmentInfo({
    required this.id,
    required this.user,
    required this.type,
    required this.date,
    required this.specialistInfo,
    required this.map,
    required this.mapInfo,
    required this.status,
    required this.isActive,
  });

  factory AppointmentInfo.fromJson(Map<String, dynamic> json) {
    return AppointmentInfo(
      id: json['id'],
      user: json['user'],
      type: json['type'],
      date: json['date'],
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
