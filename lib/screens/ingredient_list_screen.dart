import 'package:flutter/material.dart';
import '../models/ingredient.dart';

class IngredientListScreen extends StatelessWidget {
  final String category;
  final String shopName;

  // Listes des ingrédients pour les catégories "Fruits", "Vegetables", et "Meats"
  final List<Ingredient> fruits = [
    Ingredient(name: 'Banane', price: 4.3, quantity: 250),
    Ingredient(name: 'Pomme', price: 1.9, quantity: 250),
    Ingredient(name: 'Mandarine', price: 1.2, quantity: 250),
  ];

  final List<Ingredient> vegetables = [
    Ingredient(name: 'Red Pepper', price: 0.78, quantity: 250),
    Ingredient(name: 'Tomato', price: 0.96, quantity: 250),
    Ingredient(name: 'Potato', price: 0.98, quantity: 250),
  ];

  final List<Ingredient> meats = [
    Ingredient(name: 'Escalope', price: 5.3, quantity: 250),
    Ingredient(name: 'packaged chicken', price: 14.7, quantity: 1000),
    Ingredient(name: 'Meat', price: 23.7, quantity: 500),
    Ingredient(name: 'Eggs 6 pieces', price: 2.3, quantity: 6),
    Ingredient(name: 'Eggs 8 pieces', price: 3.4, quantity: 8),
  ];

  IngredientListScreen({required this.category, required this.shopName});

  @override
  Widget build(BuildContext context) {
    // Choisir la liste d'ingrédients en fonction de la catégorie
    final List<Ingredient> selectedIngredients;
    if (category == "Fruits") {
      selectedIngredients = fruits;
    } else if (category == "Vegetables") {
      selectedIngredients = vegetables;
    } else if (category == "Meats") {
      selectedIngredients = meats;
    } else {
      selectedIngredients = [];
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("$category - $shopName"),
      ),
      body: selectedIngredients.isNotEmpty
          ? ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: selectedIngredients.length,
              itemBuilder: (context, index) {
                final ingredient = selectedIngredients[index];

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    title: Text(
                      ingredient.name,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text("Prix: ${ingredient.price} DT | Quantité: ${ingredient.quantity} ${ingredient.quantity > 1 ? 'g' : 'pièces'}"),
                  ),
                );
              },
            )
          : Center(
              child: Text(
                "Aucun ingrédient trouvé pour cette catégorie",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            ),
    );
  }
}
