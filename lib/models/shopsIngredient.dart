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
class Ingredient {
  String id;
  String name;
  String quantity;
  String price;
  String? imageUrl;

  Ingredient({
    required this.id,
    required this.name,
    required this.quantity,
    required this.price,
    this.imageUrl,
  });

  factory Ingredient.fromMap(Map<String, dynamic> map) {
    return Ingredient(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      quantity: map['quantity'] ?? '',
      price: map['price'] ?? '',
      imageUrl: map['imageUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'price': price,
      'imageUrl': imageUrl,
    };
  }

  Ingredient copyWith({
    String? id,
    String? name,
    String? quantity,
    String? price,
    String? imageUrl,
  }) {
    return Ingredient(
      id: id ?? this.id,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  // Setters
  set setName(String name) => this.name = name;
  set setQuantity(String quantity) => this.quantity = quantity;
  set setPrice(String price) => this.price = price;
  set setImageUrl(String? imageUrl) => this.imageUrl = imageUrl;
}

