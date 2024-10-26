import 'package:flutter/material.dart';
import 'ingredient_list_screen.dart';

class IngredientsScreen extends StatelessWidget {
  final String shopName;

  IngredientsScreen({required this.shopName});

  final Map<String, Map<String, String>> shopCategories = const {
    "Monoprix": {
      "Fruits": "assets/images/fruits.png",
      "Vegetables": "assets/images/vegetables.png",
      "Meats": "assets/images/meat.png",
      "Dairy": "assets/images/dairy.png",
      "Spices": "assets/images/spices.png",
    },
    "MG": {
      "Fruits": "assets/images/fruits.png",
      "Vegetables": "assets/images/vegetables.png",
      "Meats": "assets/images/meat.png",
      "Dairy": "assets/images/dairy.png",
      "Charcuterie": "assets/images/charcuterie.png",
    },
    "Toumis Garden": {
      "Fruits": "assets/images/fruits.png",
      "Vegetables": "assets/images/vegetables.png",
    },
  };

  @override
  Widget build(BuildContext context) {
    final categories = shopCategories[shopName] ?? {};

    return Scaffold(
      appBar: AppBar(
        title: Text("$shopName Categories"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Deux colonnes pour la grille
            crossAxisSpacing: 16.0, // Espacement horizontal entre les cartes
            mainAxisSpacing: 16.0, // Espacement vertical entre les cartes
            childAspectRatio: 1, // Ratio pour ajuster la taille des cartes
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories.keys.elementAt(index);
            final imagePath = categories[category];

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => IngredientListScreen(
                      category: category,
                      shopName: shopName,
                    ),
                  ),
                );
              },
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: imagePath != null
                          ? Image.asset(
                              imagePath,
                              fit: BoxFit.cover,
                            )
                          : const Icon(Icons.image_not_supported),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        category,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
