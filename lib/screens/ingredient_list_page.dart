import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'ingredient_page.dart'; // Page pour ajouter/modifier un ingrédient
import 'dart:ui'; // Pour utiliser BackdropFilter

class IngredientListPage extends StatefulWidget {
  final String shopId;

  IngredientListPage({required this.shopId});

  @override
  _IngredientListPageState createState() => _IngredientListPageState();
}

class _IngredientListPageState extends State<IngredientListPage> {
  String searchQuery = '';
  TextEditingController _searchController = TextEditingController();

  // Fonction pour naviguer vers la page d'ajout ou de modification d'un ingrédient
  void navigateToIngredientPage(BuildContext context, {String? ingredientId}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => IngredientPage(
          shopId: widget.shopId,
          ingredientId: ingredientId,
        ),
      ),
    );
  }

  // Fonction pour supprimer un ingrédient avec confirmation
  void deleteIngredient(String ingredientId, String ingredientName) async {
    // Afficher une boîte de dialogue de confirmation
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Êtes-vous sûr ?'),
          content: Text('Voulez-vous vraiment supprimer l\'ingrédient "$ingredientName" ?'),
          actions: [
            TextButton(
              child: Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop();  // Fermer la boîte de dialogue
              },
            ),
            TextButton(
              child: Text('Supprimer'),
              onPressed: () async {
                try {
                  await FirebaseFirestore.instance
                      .collection('shops')
                      .doc(widget.shopId)
                      .collection('ingredients')
                      .doc(ingredientId)
                      .delete();

                  // Afficher un Snackbar pour confirmer la suppression
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('L\'ingrédient "$ingredientName" a été supprimé avec succès.'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  Navigator.of(context).pop(); // Fermer la boîte de dialogue après suppression
                } catch (e) {
                  // Afficher un Snackbar pour les erreurs
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Erreur lors de la suppression de l'ingrédient."),
                      backgroundColor: Colors.red,
                    ),
                  );
                  Navigator.of(context).pop(); // Fermer la boîte de dialogue après l'erreur
                }
              },
            ),
          ],
        );
      },
    );
  }

  // Fonction pour afficher la barre de recherche
  void startSearch(BuildContext context) async {
    final result = await showSearch<String>(context: context, delegate: IngredientSearchDelegate(shopId: widget.shopId));
    if (result != null) {
      setState(() {
        searchQuery = result;
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste des Ingrédients'),
        actions: [
          // Ajout d'un champ de recherche dans l'AppBar
          Container(
            width: 250,
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Rechercher...',
                border: InputBorder.none,
                icon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => navigateToIngredientPage(context),
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
          Positioned.fill(
            child: BackdropFilter(                                      //bch nbadel l'image flou
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Container(
                color: Colors.black.withOpacity(0.4),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: StreamBuilder<QuerySnapshot>(      
              stream: FirebaseFirestore.instance
                  .collection('shops')
                  .doc(widget.shopId)
                  .collection('ingredients')                                       //yemchy yochouf l collection ing fl firestore , 
                  .where('name', isGreaterThanOrEqualTo: searchQuery)              //yifalterhom bl nom, w baad yo93od yaaml f mise à jour ll interface kl ma ttbadel
                  .where('name', isLessThanOrEqualTo: searchQuery + '\uf8ff')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                      child: Text('No ingredient found !',
                          style: TextStyle(color: Colors.white)));
                }

                final ingredients = snapshot.data!.docs;

                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1,
                  ),
                  itemCount: ingredients.length,
                  itemBuilder: (context, index) {
                    final ingredientId = ingredients[index].id;
                    final data = ingredients[index].data() as Map<String, dynamic>;
                    return Card(
                      color: Colors.white.withOpacity(0.8),
                      elevation: 5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
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
                                onPressed: () =>
                                    navigateToIngredientPage(context, ingredientId: ingredientId),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () => deleteIngredient(ingredientId, data['name']),
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

class IngredientSearchDelegate extends SearchDelegate<String> {
  final String shopId;

  IngredientSearchDelegate({required this.shopId});

  @override
  List<Widget> buildActions(BuildContext context) {         //declari bch tfasakh l rech
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {                                // bch narja3 b tweli bch nokhrej ml rech
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {      //yaffichi les résultats de la recherche sous forme de grille.
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('shops')
          .doc(shopId)
          .collection('ingredients')
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThanOrEqualTo: query + '\uf8ff')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No ingredient found !'));
        }

        final ingredients = snapshot.data!.docs;
        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1,
          ),
          itemCount: ingredients.length,
          itemBuilder: (context, index) {
            final ingredientId = ingredients[index].id;
            final data = ingredients[index].data() as Map<String, dynamic>;
            return Card(
              color: Colors.white.withOpacity(0.8),
              elevation: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: data['image'] != null && data['image'] != ''
                        ? Image.network(data['image'], fit: BoxFit.cover)
                        : Icon(Icons.image_not_supported),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      data['name'],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();  // Pas de suggestions
  }
}
