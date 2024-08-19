class CategoryModel {
  final List<CategoryItem> results;

  CategoryModel({
    required this.results,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    List<dynamic> resultsList = json['results'];
    final result = resultsList.map((item) => CategoryItem.fromJson(item)).toList();

    return CategoryModel(
      results: result,
    );
  }

  // Method to extract "results" from data
  List<CategoryItem> getResults() {
    return results;
  }
}

class CategoryItem {
  final int id;
  final String name;
  final String description;
  final String image;
  final bool isActive;

  CategoryItem({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.isActive,
  });

  factory CategoryItem.fromJson(Map<String, dynamic> json) {
    return CategoryItem(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      image: json['image'],
      isActive: json['is_active'],
    );
  }
}
