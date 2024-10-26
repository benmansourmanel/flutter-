// models/ingredient.dart

class Ingredient {
  final String name;
  final double price;
  final int quantity;
  final String image; // Décommentez pour l'utiliser

  Ingredient({
    required this.name,
    required this.price,
    required this.quantity,
    required this.image, // Assurez-vous de le rendre obligatoire
  });
}
