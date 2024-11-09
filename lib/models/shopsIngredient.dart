class Shop {
  final String id;
  final String name;
  final String location;
  final List<Ingredient> ingredients;

  Shop({
    required this.id,
    required this.name,
    required this.location,
    required this.ingredients,
  });

  // Méthode `fromMap` pour convertir une map Firestore en instance de Shop
  factory Shop.fromMap(Map<String, dynamic> data, String documentId) {
    return Shop(
      id: documentId,
      name: data['name'] ?? '',
      location: data['location'] ?? '',
      ingredients: (data['ingredients'] as List<dynamic>?)?.map((ingredientData) {
            return Ingredient.fromMap(ingredientData as Map<String, dynamic>);
          }).toList() ?? [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'location': location,
      'ingredients': ingredients.map((ingredient) => ingredient.toMap()).toList(),
    };
  }
}

class Ingredient {
  final String nameIngredient;
  final double price;
  final int quantity;
  final Category category;

  Ingredient({
    required this.nameIngredient,
    required this.price,
    required this.quantity,
    required this.category,
  });

  factory Ingredient.fromMap(Map<String, dynamic> data) {
    return Ingredient(
      nameIngredient: data['nameIngredient'] ?? '',
      price: data['price']?.toDouble() ?? 0.0,
      quantity: data['quantity'] ?? 0,
      category: Category.values.firstWhere(
        (e) => e.toString() == 'Category.${data['category']}',
        orElse: () => Category.fruit,
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nameIngredient': nameIngredient,
      'price': price,
      'quantity': quantity,
      'category': category.toString().split('.').last,
    };
  }
}

enum Category { fruit, vegetables, dairy, spices, charcuterie }
