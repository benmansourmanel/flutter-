import 'package:flutter/material.dart';
import 'meal_form_page.dart';
import 'recipe_page.dart';
import '../models/meal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';

class MealsRecipesPage extends StatefulWidget {
  const MealsRecipesPage({super.key});

  @override
  _MealsRecipesPageState createState() => _MealsRecipesPageState();
}

class _MealsRecipesPageState extends State<MealsRecipesPage> {
  List<Meal> meals = [];
  String searchQuery = '';
  String? selectedCategory; // Add a variable to store the selected category

  @override
  void initState() {
    super.initState();
    fetchMeals();
  }

  void fetchMeals() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('meals').get();
      setState(() {
        meals = snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return Meal.fromMap({
            ...data,
            'id': doc.id,
          });
        }).toList();
      });
    } catch (e) {
      print("Error fetching meals: $e");
    }
  }

  void addMeal(Meal meal) async {
    try {
      await FirebaseFirestore.instance.collection('meals').add(meal.toMap());
      setState(() {
        meals.add(meal);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Meal added successfully!')),
      );
      Navigator.pop(context);
    } catch (e) {
      print("Error adding meal: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add meal. Please try again.')),
      );
    }
  }

  void modifyMeal(int index, Meal updatedMeal) async {
    try {
      await FirebaseFirestore.instance.collection('meals').doc(meals[index].id).update(updatedMeal.toMap());
      setState(() {
        meals[index] = updatedMeal;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Meal modified successfully!')),
      );
      Navigator.pop(context);
    } catch (e) {
      print("Error modifying meal: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to modify meal. Please try again.')),
      );
    }
  }

  void deleteMeal(int index) async {
    try {
      await FirebaseFirestore.instance.collection('meals').doc(meals[index].id).delete();
      setState(() {
        meals.removeAt(index);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Meal deleted successfully!')),
      );
    } catch (e) {
      print("Error deleting meal: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete meal. Please try again.')),
      );
    }
  }

  void _onSearchChanged(String query) {
    setState(() {
      searchQuery = query;
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredMeals = meals.where((meal) {
      final matchesSearch = meal.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
          meal.description.toLowerCase().contains(searchQuery.toLowerCase());
      final matchesCategory = selectedCategory == null || meal.category == selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();

    // Get unique categories from the list of meals for the dropdown options
    final categories = meals.map((meal) => meal.category).toSet().toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meals & Recipes'),
        backgroundColor: Color(0xff23AA49),
      ),
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.jpg'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.5),
                  BlendMode.dstATop,
                ),
              ),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(
                          labelText: 'Search',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: _onSearchChanged,
                      ),
                    ),
                    const SizedBox(width: 10),
                    DropdownButton<String>(
                      value: selectedCategory,
                      hint: const Text('Category'),
                      items: categories.map((category) {
                        return DropdownMenuItem<String>(
                          value: category,
                          child: Text(category),
                        );
                      }).toList()
                        ..insert(
                          0,
                          const DropdownMenuItem(
                            value: null,
                            child: Text('All'),
                          ),
                        ),
                      onChanged: (value) {
                        setState(() {
                          selectedCategory = value;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                filteredMeals.isEmpty
                    ? Center(child: Text("No meals found!"))
                    : Expanded(
                  child: ListView.builder(
                    itemCount: filteredMeals.length,
                    itemBuilder: (context, index) {
                      return Card(
                        color: Colors.white.withOpacity(0.8),
                        child: ListTile(
                          leading: filteredMeals[index].imagePath.isNotEmpty && File(filteredMeals[index].imagePath).existsSync()
                              ? Image.file(
                            File(filteredMeals[index].imagePath),
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          )
                              : Icon(Icons.image, size: 50),
                          title: Text(filteredMeals[index].name),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(filteredMeals[index].description),
                              Text('Category: ${filteredMeals[index].category}', style: TextStyle(fontSize: 12, color: Colors.grey)),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit, color: Colors.grey[800]),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MealFormPage(
                                        onSubmit: (modifiedMeal) => modifyMeal(index, modifiedMeal),
                                        meal: filteredMeals[index],
                                      ),
                                    ),
                                  );
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.grey[800]),
                                onPressed: () => deleteMeal(index),
                              ),
                              IconButton(
                                icon: Icon(Icons.restaurant_menu, color: Colors.grey[800]),
                                onPressed: () async {
                                  DocumentSnapshot mealDoc = await FirebaseFirestore.instance
                                      .collection('meals')
                                      .doc(filteredMeals[index].id)
                                      .get();

                                  if (mealDoc.exists) {
                                    final mealData = mealDoc.data() as Map<String, dynamic>;
                                    final recipes = mealData['recipes'];

                                    if (recipes != null && recipes.isNotEmpty) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => RecipePage(
                                            meal: filteredMeals[index],
                                            mealId: filteredMeals[index].id,
                                            isEditing: false,
                                          ),
                                        ),
                                      );
                                    } else {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => RecipePage(
                                            meal: filteredMeals[index],
                                            mealId: filteredMeals[index].id,
                                            isEditing: true,
                                          ),
                                        ),
                                      );
                                    }
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MealFormPage(onSubmit: addMeal),
            ),
          );
        },
        backgroundColor: Color(0xff23AA49),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
