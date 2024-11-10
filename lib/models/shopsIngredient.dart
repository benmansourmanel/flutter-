class Shop {
  final String id;
  final String name;
  final String location;
  final List<Category> categories;
  final String? imageUrl;

  Shop({
    required this.id,
    required this.name,
    required this.location,
    required this.categories,
    this.imageUrl,
  });

  factory Shop.fromMap(Map<String, dynamic> map) {
    return Shop(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      location: map['location'] ?? '',
      categories: List<Category>.from(map['categories']?.map((x) => Category.fromMap(x)) ?? []),
      imageUrl: map['imageUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'categories': categories.map((x) => x.toMap()).toList(),
      'imageUrl': imageUrl,
    };
  }
}

class Category {
  final String name;

  Category({required this.name});

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(name: map['name']);
  }

  Map<String, dynamic> toMap() {
    return {'name': name};
  }
}
