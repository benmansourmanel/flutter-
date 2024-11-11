import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'ingredient_page.dart';  // Page pour ajouter/modifier un ingrédient
import 'dart:ui'; // Pour utiliser BackdropFilter

class IngredientListPage extends StatelessWidget {
  final String shopId;

  IngredientListPage({required this.shopId});

  // Fonction pour naviguer vers la page d'ajout ou de modification d'un ingrédient
  void navigateToIngredientPage(BuildContext context, {String? ingredientId}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => IngredientPage(
          shopId: shopId,
          ingredientId: ingredientId,
        ),
      ),
    );
  }

  // Fonction pour supprimer un ingrédient
  void deleteIngredient(String ingredientId) async {
    try {
      await FirebaseFirestore.instance
          .collection('shops')
          .doc(shopId)
          .collection('ingredients')
          .doc(ingredientId)
          .delete();
      print('Ingrédient supprimé avec succès');
    } catch (e) {
      print("Erreur lors de la suppression de l'ingrédient : $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste des Ingrédients'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => navigateToIngredientPage(context), // Naviguer vers la page d'ajout
          ),
        ],
      ),
      body: Stack(
        children: [
          // Image Background with Blur Effect
          Positioned.fill(
            child: Image.asset(
              'assets/images/welcome_bg.png',
              fit: BoxFit.cover,
            ),
          ),
          // Apply BackdropFilter for blur effect
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0), // Définir l'intensité du flou
              child: Container(
                color: Colors.black.withOpacity(0.4), // Ajoute une teinte sombre pour améliorer la lisibilité
              ),
            ),
          ),
          // Content of the page
          Padding(
            padding: EdgeInsets.all(16.0),
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('shops')
                  .doc(shopId)
                  .collection('ingredients')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('Aucun ingrédient trouvé !', style: TextStyle(color: Colors.white)));
                }
                final ingredients = snapshot.data!.docs;

                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Nombre de colonnes dans la grille
                    crossAxisSpacing: 10, // Espacement horizontal entre les éléments
                    mainAxisSpacing: 10, // Espacement vertical entre les éléments
                    childAspectRatio: 1, // Ratio de la taille des éléments
                  ),
                  itemCount: ingredients.length,
                  itemBuilder: (context, index) {
                    final ingredientId = ingredients[index].id;
                    final data = ingredients[index].data() as Map<String, dynamic>;
                    return Card(
                      color: Colors.white.withOpacity(0.8), // Fond semi-transparent pour les éléments
                      elevation: 5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Image de l'ingrédient
                          Expanded(
                            child: data['image'] != null && data['image'] != ''
                                ? Image.network(
                                    data['image'],
                                    fit: BoxFit.cover,
                                  )
                                : Icon(Icons.image_not_supported),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              data['name'],
                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Prix : ${data['price']} DT\nQuantité : ${data['quantity']}',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit, color: Colors.blue),
                                onPressed: () => navigateToIngredientPage(context, ingredientId: ingredientId),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () => deleteIngredient(ingredientId),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
