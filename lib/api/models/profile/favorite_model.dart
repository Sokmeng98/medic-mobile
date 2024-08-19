class FavoriteModel {
  final int counts;
  final List<FavoriteItem> results;

  FavoriteModel({
    required this.counts,
    required this.results,
  });

  factory FavoriteModel.fromJson(Map<String, dynamic> json) {
    int count = json['count'];
    List<dynamic> resultsList = json['results'];
    final result = resultsList.map((item) => FavoriteItem.fromJson(item)).toList();

    return FavoriteModel(
      counts: count,
      results: result,
    );
  }

  int getCount() {
    return counts;
  }

  List<FavoriteItem> getResults() {
    return results;
  }
}

class FavoriteItem {
  final int id;
  final int user;
  final int education;
  final EducationFavorite educationFavorite;

  FavoriteItem({
    required this.id,
    required this.user,
    required this.education,
    required this.educationFavorite,
  });

  factory FavoriteItem.fromJson(Map<String, dynamic> json) {
    return FavoriteItem(
      id: json['id'],
      user: json['user'],
      education: json['education'],
      educationFavorite: EducationFavorite.fromJson(json['education_favorite']),
    );
  }
}

class EducationFavorite {
  final int id;
  final String title;
  final String description;
  final String? image;
  final String video;
  final bool isActive;

  EducationFavorite({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.video,
    required this.isActive,
  });

  factory EducationFavorite.fromJson(Map<String, dynamic> json) {
    return EducationFavorite(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      image: json['image'],
      video: json['video'],
      isActive: json['is_active'],
    );
  }
}
