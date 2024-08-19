class ServicesModel {
  final int counts;
  final List<ServicesItem> results;

  ServicesModel({
    required this.counts,
    required this.results,
  });

  factory ServicesModel.fromJson(Map<String, dynamic> json) {
    int count = json['count'];
    List<dynamic> resultsList = json['results'];
    final result = resultsList.map((item) => ServicesItem.fromJson(item)).toList();

    return ServicesModel(
      counts: count,
      results: result,
    );
  }

  int getCount() {
    return counts;
  }

  List<ServicesItem> getResultsService() {
    return results;
  }
}

class ServicesItem {
  final int id;
  final String icon;
  final String name;
  final bool isActive;

  ServicesItem({
    required this.id,
    required this.icon,
    required this.name,
    required this.isActive,
  });

  factory ServicesItem.fromJson(Map<String, dynamic> json) {
    return ServicesItem(
      id: json['id'],
      icon: json['icon'],
      name: json['name'],
      isActive: json['is_active'],
    );
  }
}
