import 'package:flutter/material.dart';
import 'ingredients_screen.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Shops")),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildShopItem(context, "Monoprix", "assets/images/monoprix_logo.png"),
          _buildShopItem(context, "MG", "assets/images/mg_logo.png"),
          _buildShopItem(context, "Toumis Garden", "assets/images/toumis_garden_logo.png"),
        ],
      ),
    );
  }

  Widget _buildShopItem(BuildContext context, String shopName, String logoPath) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: Image.asset(
          logoPath,
          width: 50,
          height: 50,
          fit: BoxFit.contain,
        ),
        title: Text(
          shopName,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => IngredientsScreen(shopName: shopName),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            textStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            backgroundColor: const Color(0xff23AA49),
          ),
          child: const Text("View Ingredients"),
        ),
      ),
    );
  }
}
