class UserModel {
  final int counts;
  final List<UserItem> results;

  UserModel({
    required this.counts,
    required this.results,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    int count = json['count'];
    List<dynamic> resultsList = json['results'];
    final result = resultsList.map((item) => UserItem.fromJson(item)).toList();

    return UserModel(
      counts: count,
      results: result,
    );
  }

  int getCount() {
    return counts;
  }

  List<UserItem> getResults() {
    return results;
  }
}

class UserItem {
  final int id;
  final String profile;
  final String phoneNumber;
  final String fullName;
  final String dateOfBirth;
  final String gender;
  final MapInfo mapInfo;
  final bool isSuperuser;
  final bool isStaff;

  UserItem({
    required this.id,
    required this.profile,
    required this.phoneNumber,
    required this.fullName,
    required this.dateOfBirth,
    required this.gender,
    required this.mapInfo,
    required this.isSuperuser,
    required this.isStaff,
  });

  factory UserItem.fromJson(Map<String, dynamic> json) {
    return UserItem(
      id: json['id'],
      profile: json['profile'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      fullName: json['full_name'] ?? '',
      dateOfBirth: json['date_of_birth'] ?? '',
      gender: json['gender'],
      mapInfo: MapInfo.fromJson(json['map_info'] ?? {}),
      isSuperuser: json['is_superuser'],
      isStaff: json['is_staff'],
    );
  }
}

class MapInfo {
  final String name;

  MapInfo({
    required this.name,
  });

  factory MapInfo.fromJson(Map<String, dynamic> json) {
    return MapInfo(
      name: json['name'] ?? '',
    );
  }
}
