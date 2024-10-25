import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/splash.dart';
import 'screens/welcome.dart';
import 'screens/registration.dart';
import 'screens/dashboard.dart';
import 'screens/vegetables.dart';
import 'screens/vegetable_detail.dart';
import 'screens/cart.dart';
import 'screens/shop_screen.dart';
import 'screens/ingredients_screen.dart';
import 'utils/routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Grocery App",
      theme: ThemeData(fontFamily: GoogleFonts.lato().fontFamily),
      initialRoute: "/",
      routes: {
        "/": (context) => const SplashScreen(),
        MyRoutes.welcomeRoute: (context) => const WelcomeScreen(),
        MyRoutes.registrationRoute: (context) => const RegistrationScreen(),
        MyRoutes.dashboardRoute: (context) => const DashboardScreen(),
        MyRoutes.vegetablesRoute: (context) => const VegetablesScreen(),
        MyRoutes.vegetableDetailRoute: (context) => const VegetableDetailScreen(),
        MyRoutes.cartRoute: (context) => const CartScreen(),
        MyRoutes.shopsRoute: (context) => const ShopScreen(),
        MyRoutes.ingredientsRoute: (context) => IngredientsScreen(shopName: "Monoprix"),
      },
    );
  }
}
