import 'package:flutter/material.dart';
import 'ingredient_list_screen.dart';

class IngredientsScreen extends StatelessWidget {
  final String shopName;

  IngredientsScreen({required this.shopName});

  final Map<String, Map<String, String>> shopCategories = const {
    "Monoprix": {
      "Fruits": "assets/images/fruits.png",
      "Vegetables": "assets/images/vegetables.png",
      "Meats": "assets/images/meats.png",
      "Diary": "assets/images/dairy.png",
      "Spices": "assets/images/spices.png",
    },
    "MG": {
      "Fruits": "assets/images/fruits.png",
      "Vegetables": "assets/images/vegetables.png",
      "Meats": "assets/images/meats.png",
      "Diary": "assets/images/dairy.png",
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
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories.keys.elementAt(index);
          final imagePath = categories[category];

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              leading: imagePath != null
                  ? Image.asset(
                      imagePath,
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                    )
                  : null,
              title: Text(
                category,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
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
            ),
          );
        },
      ),
    );
  }
}
