import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/meal.dart';
import 'meals_recipes.dart'; // Import the MealsRecipesPage screen

class RecipePage extends StatefulWidget {
  final Meal meal;
  final String mealId;
  final bool isEditing;

  const RecipePage({
    required this.meal,
    required this.mealId,
    required this.isEditing,
    super.key,
  });

  @override
  _RecipePageState createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage> {
  final TextEditingController _descriptionController = TextEditingController();
  List<Map<String, String>> _ingredients = [];
  bool _isViewing = true;

  @override
  void initState() {
    super.initState();
    _isViewing = !widget.isEditing;

    if (widget.meal.recipes.isNotEmpty) {
      _descriptionController.text = widget.meal.recipes[0]['description'] ?? '';
      var dynamicIngredients = widget.meal.recipes[0]['ingredients'] ?? [];
      _ingredients = List<Map<String, String>>.from(
        dynamicIngredients.map((ingredient) => Meal.convertDynamicMapToStringMap(ingredient)),
      );
    }
  }

  void _addIngredient() {
    setState(() {
      _ingredients.add({'ingredient': '', 'quantity': ''});
    });
  }

  void _removeIngredient(int index) {
    setState(() {
      _ingredients.removeAt(index);
    });
  }

  Future<void> _saveRecipe() async {
    String description = _descriptionController.text;
    List<Map<String, String>> ingredients = List.from(_ingredients);

    // Validate that the description and ingredients are filled in
    if (description.isEmpty || ingredients.isEmpty ||
        ingredients.any((ingredient) => ingredient['ingredient']!.isEmpty || ingredient['quantity']!.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid description and at least one ingredient.')),
      );
      return; // Exit the method if validation fails
    }

    Map<String, dynamic> newRecipe = {
      'description': description,
      'ingredients': ingredients,
    };

    DocumentReference mealRef = FirebaseFirestore.instance.collection('meals').doc(widget.mealId);

    try {
      // Check if a recipe already exists for the meal
      DocumentSnapshot mealSnapshot = await mealRef.get();

      if (mealSnapshot.exists) {
        // If a recipe exists, update it
        await mealRef.update({
          'recipes': [newRecipe], // Replace the existing recipe with the new one
        });
      } else {
        // Handle the case where the meal document does not exist
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Meal not found!')),
        );
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Recipe updated successfully!')),
      );

      // Navigate back to the MealsRecipesPage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MealsRecipesPage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update recipe: $e')),
      );
    }
  }

  Future<void> _deleteRecipe() async {
    DocumentReference mealRef = FirebaseFirestore.instance.collection('meals').doc(widget.mealId);

    try {
      await mealRef.update({
        'recipes': [],
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Recipe deleted successfully!')),
      );

      // Navigate to MealsRecipesPage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MealsRecipesPage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete recipe: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipe Details'),
        backgroundColor: const Color(0xff23AA49),
      ),
      body: Stack(
        children: [
          // Background Image with transparency
          Opacity(
            opacity: 0.3, // Adjust the opacity for transparency
            child: Image.asset(
              'assets/images/cooking.png', // Make sure this path is correct
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          // Foreground content
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: _isViewing && widget.meal.recipes.isNotEmpty
                ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Recipe for ${widget.meal.name}',
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 10),
                Text(
                  'Description: ${widget.meal.recipes[0]['description']}',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Ingredients:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                ..._ingredients.map((ingredient) {
                  return Text(
                    '${ingredient['ingredient']} - ${ingredient['quantity']}',
                    style: const TextStyle(fontSize: 16),
                  );
                }),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _isViewing = false;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff23AA49),
                  ),
                  child: const Text('Modify Recipe', style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _deleteRecipe,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: const Text('Delete Recipe', style: TextStyle(color: Colors.white)),
                ),
              ],
            )
                : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Recipe Description',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Ingredients:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: _ingredients.length,
                    itemBuilder: (context, index) {
                      return Row(
                        children: [
                          Expanded(
                            child: TextField(
                              onChanged: (value) {
                                _ingredients[index]['ingredient'] = value;
                              },
                              decoration: InputDecoration(
                                labelText: 'Ingredient ${index + 1}',
                                border: const OutlineInputBorder(),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              onChanged: (value) {
                                _ingredients[index]['quantity'] = value;
                              },
                              decoration: InputDecoration(
                                labelText: 'Quantity',
                                border: const OutlineInputBorder(),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.clear, color: Colors.red),
                            onPressed: () => _removeIngredient(index),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: _saveRecipe,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff23AA49),
                      ),
                      child: const Text('Submit', style: TextStyle(color: Colors.white)),
                    ),
                    ElevatedButton(
                      onPressed: _addIngredient,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff23AA49),
                      ),
                      child: const Text('+', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}
