import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mealmate/models/shopsIngredient.dart';
import 'package:mealmate/screens/ingredient_list_page.dart';
import 'package:mealmate/screens/shops_ingredient.dart';
// Import generated Firebase options
import 'screens/vegetables.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/dashboard.dart';
import 'screens/registration.dart';
import 'screens/welcome.dart';
import 'screens/meals_recipes.dart';
import 'utils/routes.dart';
import 'screens/login_page.dart'; // Import the login page

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "MealMate",
      theme: ThemeData(fontFamily: GoogleFonts.lato().fontFamily),
      initialRoute: "/login", // Set login page as the initial route
      routes: {
        "/login": (context) => const LoginPage(),
        MyRoutes.welcomeRoute: (context) => const WelcomeScreen(),
        MyRoutes.registrationRoute: (context) => const RegistrationScreen(),
        MyRoutes.dashboardRoute: (context) => const DashboardScreen(),
        MyRoutes.vegetablesRoute: (context) => const VegetablesScreen(),
        MyRoutes.mealsrecipesRoute: (context) => const MealsRecipesPage(),
        MyRoutes.shopsingredientRoute: (context) => const ShopsPage(),
        MyRoutes.ingredientListRoute:(context) => IngredientListPage(shopId: '',),
         
        // Add other routes as needed
      },
    );
  }
}
