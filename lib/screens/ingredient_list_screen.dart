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
    Ingredient(name: 'Meat', price: 39.8, quantity: 1000, image: 'assets/images/meats.png'),
    Ingredient(name: 'Eggs 6 pieces', price: 2.3, quantity: 6, image: 'assets/images/eggs6p.png'),
    Ingredient(name: 'Eggs 8 pieces', price: 3.4, quantity: 8, image: 'assets/images/eggs8p.png'),
  ];

  final List<Ingredient> spices = [
    Ingredient(name: 'Clove', price: 2.3, quantity: 100, image: 'assets/images/clove.png'),
    Ingredient(name: 'Paprika', price: 4.2, quantity: 100, image: 'assets/images/paprika.png'),
    Ingredient(name: 'Vanilla Flower', price: 1.4, quantity: 100, image: 'assets/images/vanilla-flower.png'),
    Ingredient(name: 'Nutmegs', price: 2.7, quantity: 100, image: 'assets/images/nutmegs.png'),
    Ingredient(name: 'Tomato Sauce ', price: 5.7, quantity:1000, image: 'assets/images/tomato_sauce.png'),
    Ingredient(name: 'Ravioli ', price: 7.2 , quantity:100, image: 'assets/images/ravioli.png'),
    Ingredient(name: 'Fusilli Pasta ', price: 1.3, quantity:500, image: 'assets/images/fusilli_pasta.png'),
    Ingredient(name: 'Spagetti Pasta ', price: 0.5, quantity:500, image: 'assets/images/spagetti.png'),
    Ingredient(name: 'Penne Pasta ', price: 0.5, quantity:500, image: 'assets/images/penne.png'),
    Ingredient(name: 'Rice ', price: 9.7, quantity:1000, image: 'assets/images/rice.png'),
    Ingredient(name: 'Noodels ', price: 1.7, quantity:1000, image: 'assets/images/noodels.png'),
    Ingredient(name: 'Olive Oil ', price: 3.7, quantity:1000, image: 'assets/images/olive_oil.png'),
  ];

  final List<Ingredient> dairy = [
    Ingredient(name: 'Butter', price: 1.7, quantity: 100, image: 'assets/images/butter.png'),
    Ingredient(name: 'Milk Piece', price: 1.5, quantity: 1, image: 'assets/images/fresh_milk.png'),
    Ingredient(name: 'Yagourt', price: 0.7, quantity: 100, image: 'assets/images/yagourt.png'),
    Ingredient(name: 'Slice Cheese', price: 2.5, quantity: 1, image: 'assets/images/slice_cheese.png'),
    Ingredient(name: 'Camembert', price: 3.8, quantity: 100, image: 'assets/images/camembert.png'),
    Ingredient(name: 'Sour Cream ', price: 2.9, quantity:250, image: 'assets/images/sour_cream.png'),
    Ingredient(name: 'Apple Yagourt', price: 0.89, quantity:1000, image: 'assets/images/appel_yag.png'),
    Ingredient(name: 'Feta Cheese ', price: 4.2, quantity:100, image: 'assets/images/feta.png'),
  ];

  // Liste des ingrédients pour la catégorie "Charcuterie"
  final List<Ingredient> charcuterie = [
    Ingredient(name: 'ham', price: 1.9, quantity: 100, image: 'assets/images/ham.png'),
    Ingredient(name: ' Tuurkey Ham', price: 2.7, quantity: 100, image: 'assets/images/turkey_ham.png'),
    Ingredient(name: 'Salami', price: 13.0, quantity: 100, image: 'assets/images/salami.png'),
    Ingredient(name: 'Beef Salami ', price: 3.450, quantity: 100, image: 'assets/images/salami_.png'),
  ];
  final List<Ingredient> driedFruits= [
    Ingredient(name: ' Dried Kiwi fruit', price: 3.4, quantity:100, image: 'assets/images/kiwi.png'),
    Ingredient(name: ' Dried apricotes fruit', price: 2.9, quantity:100, image: 'assets/images/apricots.png'),

  ];
  final List<Ingredient> sugarsAndCakeMixes=[
    Ingredient(name: 'Sugar', price: 2.6, quantity: 1000, image: 'assets/images/sugar.png'),
    Ingredient(name: 'Flour', price: 1.3, quantity: 1000, image: 'assets/images/flour.png'),
    Ingredient(name: 'Chocolate', price: 4.68, quantity: 250, image: 'assets/images/chocolate.png'),
    Ingredient(name: 'Chocolate Bar', price: 2.6, quantity: 300, image: 'assets/images/chocolate_bar.png'),
    Ingredient(name: ' Instant Yeast', price: 1.74, quantity: 250, image: 'assets/images/levure.png'),
    Ingredient(name: 'Ice Cream', price: 4.9, quantity: 500, image: 'assets/images/icecream.png'),
  ];
  IngredientListScreen({super.key, required this.category, required this.shopName});

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
    } else if (category == "Dried Fruits") {
        selectedIngredients = driedFruits;
    } else if (category == "Sugars and Cake Mixes"){
      selectedIngredients =sugarsAndCakeMixes;
    }
    
    else {
      selectedIngredients = [];
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("$category - $shopName"),
      ),
      body: selectedIngredients.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Deux colonnes pour la grille
                  crossAxisSpacing: 16.0, // Espacement horizontal entre les cartes
                  mainAxisSpacing: 16.0, // Espacement vertical entre les cartes
                  childAspectRatio: 0.75, // Ratio pour ajuster la taille des cartes
                ),
                itemCount: selectedIngredients.length,
                itemBuilder: (context, index) {
                  final ingredient = selectedIngredients[index];
                  return IngredientCard(ingredient: ingredient);
                },
              ),
            )
          : const Center(
              child: Text(
                "Aucun ingrédient trouvé pour cette catégorie",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            ),
    );
  }
}

// Widget pour afficher chaque carte d'ingrédient
class IngredientCard extends StatelessWidget {
  final Ingredient ingredient;

  const IngredientCard({super.key, required this.ingredient});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Image.asset(
              ingredient.image,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              children: [
                Text(
                  ingredient.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "${ingredient.quantity}g, ${ingredient.price} DT",
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add_circle, color: Colors.green),
            onPressed: () {
              // Action lors de l'ajout d'un ingrédient
            },
          ),
        ],
      ),
    );
  }
}