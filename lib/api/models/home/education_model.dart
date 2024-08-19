class EducationModel {
  final int counts;
  final List<EducationItem> results;

  EducationModel({
    required this.counts,
    required this.results,
  });

  factory EducationModel.fromJson(Map<String, dynamic> json) {
    int count = json['count'];
    List<dynamic> resultsList = json['results'];
    final result = resultsList.map((item) => EducationItem.fromJson(item)).toList();

    return EducationModel(
      counts: count,
      results: result,
    );
  }

  int getCount() {
    return counts;
  }

  List<EducationItem> getResults() {
    return results;
  }
}

class EducationItem {
  final int id;
  final int category;
  final String title;
  final String description;
  final String? image;
  final String? video;
  final String createdAt;
  final String updatedAt;
  final TagInfo tagInfo;
  final int view;
  bool isFavorite;
  final bool isActive;

  EducationItem({
    required this.id,
    required this.category,
    required this.title,
    required this.description,
    required this.image,
    required this.video,
    required this.createdAt,
    required this.updatedAt,
    required this.tagInfo,
    required this.view,
    required this.isFavorite,
    required this.isActive,
  });

  factory EducationItem.fromJson(Map<String, dynamic> json) {
    return EducationItem(
      id: json['id'],
      category: json['category'],
      title: json['title'],
      description: json['description'],
      image: json['image'],
      video: json['video'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      tagInfo: TagInfo.fromJson(json['tag_info'] ?? {}),
      view: json['view'],
      isFavorite: json['is_favorite'],
      isActive: json['is_active'],
    );
  }
}

class TagInfo {
  final String name;

  TagInfo({
    required this.name,
  });

  factory TagInfo.fromJson(Map<String, dynamic> json) {
    return TagInfo(
      name: json['name'] ?? 'N/A',
    );
  }
}
