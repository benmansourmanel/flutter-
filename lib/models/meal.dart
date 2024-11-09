class Meal {
  final String id; // Unique identifier for the meal
  final String name;
  final String description;
  final String category;
  final String imagePath;
  final List<Map<String, dynamic>> recipes;

  Meal({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    this.imagePath = '',
    this.recipes = const [],
  });

  // Method to convert a Meal instance to a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id, // Include the id in the map
      'name': name,
      'description': description,
      'category': category,
      'imagePath': imagePath,
      'recipes': recipes,
    };
  }

  // Method to convert a dynamic map to a string map
  static Map<String, String> convertDynamicMapToStringMap(Map<String, dynamic> dynamicMap) {
    return dynamicMap.map((key, value) => MapEntry(key, value.toString()));
  }

  // Factory method to create a Meal instance from a Map
  factory Meal.fromMap(Map<String, dynamic> data) {
    return Meal(
      id: data['id'] ?? '', // Ensure id is retrieved
      name: data['name'],
      description: data['description'],
      category: data['category'],
      imagePath: data['imagePath'] ?? '',
      recipes: List<Map<String, dynamic>>.from(data['recipes'] ?? []),
    );
  }
}
