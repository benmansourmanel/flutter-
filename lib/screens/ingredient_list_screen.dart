import 'package:flutter/material.dart';
import '../models/ingredient.dart';

class IngredientListScreen extends StatelessWidget {
  final String category;
  final String shopName;

  // Listes des ingrédients pour les catégories "Fruits", "Vegetables", "Meats", "Spices", "Dairy", et "Charcuterie"
  final List<Ingredient> fruits = [
    Ingredient(name: 'Banane', price: 4.3, quantity: 250, image: 'assets/images/banane.png'),
    Ingredient(name: 'Apple', price: 1.9, quantity: 250, image: 'assets/images/apple.png'),
    Ingredient(name: 'Mandarin', price: 1.2, quantity: 250, image: 'assets/images/mandarin.png'),
  ];

  final List<Ingredient> vegetables = [
    Ingredient(name: 'Red Pepper', price: 0.78, quantity: 250, image: 'assets/images/red_pepper.png'),
    Ingredient(name: 'Tomato', price: 0.96, quantity: 250, image: 'assets/images/tomato.png'),
    Ingredient(name: 'Potato', price: 0.98, quantity: 250, image: 'assets/images/potato.png'),
  ];

  final List<Ingredient> meats = [
    Ingredient(name: 'Escalope', price: 5.3, quantity: 250, image: 'assets/images/escalope.png'),
    Ingredient(name: 'Packaged Chicken', price: 14.7, quantity: 1000, image: 'assets/images/chicken.png'),
    Ingredient(name: 'Meat', price: 39.8, quantity: 1000, image: 'assets/images/meat.png'),
    Ingredient(name: 'Eggs 6 pieces', price: 2.3, quantity: 6, image: 'assets/images/eggs6p.png'),
    Ingredient(name: 'Eggs 8 pieces', price: 3.4, quantity: 8, image: 'assets/images/eggs8p.png'),
  ];

  final List<Ingredient> spices = [
    Ingredient(name: 'Clove', price: 2.3, quantity: 100, image: 'assets/images/clove.png'),
    Ingredient(name: 'Paprika', price: 4.2, quantity: 100, image: 'assets/images/paprika.png'),
    Ingredient(name: 'Vanilla Flower', price: 1.4, quantity: 100, image: 'assets/images/vanilla-flower.png'),
    Ingredient(name: 'Nutmegs', price: 2.7, quantity: 100, image: 'assets/images/nutmegs.png'),
  ];

  final List<Ingredient> dairy = [
    Ingredient(name: 'Butter', price: 1.7, quantity: 100, image: 'assets/images/butter.png'),
    Ingredient(name: 'Milk Piece', price: 1.5, quantity: 1, image: 'assets/images/fresh_milk.png'),
    Ingredient(name: 'Yagourt', price: 0.7, quantity: 100, image: 'assets/images/yagourt.png'),
    Ingredient(name: 'Slice Cheese', price: 2.5, quantity: 1, image: 'assets/images/slice_cheese.png'),
    Ingredient(name: 'Camembert', price: 3.8, quantity: 100, image: 'assets/images/camembert.png'),
  ];

  // Liste des ingrédients pour la catégorie "Charcuterie"
  final List<Ingredient> charcuterie = [
    Ingredient(name: 'ham', price: 1.9, quantity: 100, image: 'assets/images/ham.png'),
    Ingredient(name: ' Tuurkey Ham', price: 2.7, quantity: 100, image: 'assets/images/turkey_ham.png'),
    Ingredient(name: 'Salami', price: 13.0, quantity: 100, image: 'assets/images/salami.png'),
    Ingredient(name: 'Beef Salami ', price: 3.450, quantity: 100, image: 'assets/images/salami_.png'),
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
    } else if (category == "Spices") {
      selectedIngredients = spices;
    } else if (category == "Dairy") {
      selectedIngredients = dairy;
    } else if (category == "Charcuterie") { // Vérifiez si la catégorie est "Charcuterie"
      selectedIngredients = charcuterie;
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
                    leading: Image.asset(
                      ingredient.image,
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                    ),
                    title: Text(
                      ingredient.name,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text("Prix: ${ingredient.price} DT | Quantité: ${ingredient.quantity} g"),
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
