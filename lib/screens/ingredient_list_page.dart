import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'ingredient_page.dart';  // Page pour ajouter/modifier un ingrédient

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
      body: StreamBuilder<QuerySnapshot>(
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
            return Center(child: Text('Aucun ingrédient trouvé !'));
          }
          final ingredients = snapshot.data!.docs;

          return ListView.builder(
            itemCount: ingredients.length,
            itemBuilder: (context, index) {
              final ingredientId = ingredients[index].id;
              final data = ingredients[index].data() as Map<String, dynamic>;
              return ListTile(
                title: Text(data['name']),
                subtitle: Text('Prix : ${data['price']} | Quantité : ${data['quantity']}'),
                leading: data['image'] != null && data['image'] != ''
                    ? Image.network(data['image'], width: 50, height: 50)
                    : Icon(Icons.image_not_supported),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
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
              );
            },
          );
        },
      ),
    );
  }
}
