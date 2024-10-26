import 'package:flutter/material.dart';
import 'ingredients_screen.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Shops"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Nombre de colonnes dans la grille
            crossAxisSpacing: 16.0, // Espacement horizontal entre les cartes
            mainAxisSpacing: 16.0, // Espacement vertical entre les cartes
            childAspectRatio: 0.8, // Ratio pour ajuster la taille des cartes
          ),
          itemCount: shopItems.length,
          itemBuilder: (context, index) {
            final shop = shopItems[index];
            return _buildShopItem(context, shop['name']!, shop['logoPath']!);
          },
        ),
      ),
    );
  }

  // Liste des points de vente avec nom et logo
  static const List<Map<String, String>> shopItems = [
    const {"name": "Monoprix", "logoPath": "assets/images/monoprix_logo.png"},
    const {"name": "MG", "logoPath": "assets/images/mg_logo.png"},
    const {"name": "Toumis Garden", "logoPath": "assets/images/toumis_garden_logo.png"},
  ];

  Widget _buildShopItem(BuildContext context, String shopName, String logoPath) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => IngredientsScreen(shopName: shopName),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 4,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  logoPath,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                shopName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => IngredientsScreen(shopName: shopName),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                  textStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  backgroundColor: const Color(0xff23AA49),
                ),
                child: const Text("View Ingredients"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
