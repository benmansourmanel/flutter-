import 'package:flutter/material.dart';
import '../utils/routes.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9), // Transparent effect here
          border: Border.all(color: Colors.transparent),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color(0xff23AA49),
              ),
              child: const Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            ListTile(
              title: const Text(
                'Meals & Recepies',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w500,
                  color: Colors.green,
                ),
              ),
              leading: Image.asset(
                'assets/images/meals.png',
                width: 27, // ajustez la taille selon vos besoins
                height: 27,
              ),
              onTap: () {
                Navigator.pushNamed(context, MyRoutes.mealsrecipesRoute);
              },
            ),
            // Add more ListTiles for other items
          ListTile(
              title: const Text(
                'Shops & Ingredient',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w500,
                  color: Colors.green,
                ),
              ),
              leading: Image.asset(
                'assets/images/shops.png',
                width: 27, // ajustez la taille selon vos besoins
                height: 27,
              ),
              onTap: () {
                Navigator.pushNamed(context, MyRoutes.shopsingredientRoute);
              },
            ),

          ],
        ),
      ),
    );
  }
}
