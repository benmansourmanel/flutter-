import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'ingredient_list_page.dart'; // Assurez-vous d'importer la page de la liste des ingrédients
import 'dart:ui'; // Pour utiliser le BackdropFilter

class IngredientPage extends StatefulWidget {
  final String shopId;
  final String? ingredientId;

  IngredientPage({required this.shopId, this.ingredientId});

  @override
  _IngredientPageState createState() => _IngredientPageState();
}

class _IngredientPageState extends State<IngredientPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();

  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    if (widget.ingredientId != null) {
      _isEditing = true;
      _loadIngredientData();
    }
  }

  void _loadIngredientData() async {
    try {
      DocumentSnapshot ingredientSnapshot = await FirebaseFirestore.instance
          .collection('shops')
          .doc(widget.shopId)
          .collection('ingredients')
          .doc(widget.ingredientId)
          .get();

      if (ingredientSnapshot.exists) {
        var data = ingredientSnapshot.data() as Map<String, dynamic>;
        _nameController.text = data['name'];
        _priceController.text = data['price'].toString();
        _quantityController.text = data['quantity'].toString();
        _imageController.text = data['image'] ?? '';
      }
    } catch (e) {
      print("Error loading data : $e");
    }
  }

  void saveIngredient() async {
    if (_formKey.currentState!.validate()) {
      try {
        final ingredientData = {
          'name': _nameController.text,
          'price': double.parse(_priceController.text),
          'quantity': int.parse(_quantityController.text),
          'image': _imageController.text.isEmpty ? null : _imageController.text,
        };

        if (_isEditing) {
          await FirebaseFirestore.instance
              .collection('shops')
              .doc(widget.shopId)
              .collection('ingredients')
              .doc(widget.ingredientId)
              .update(ingredientData);
        } else {
          await FirebaseFirestore.instance
              .collection('shops')
              .doc(widget.shopId)
              .collection('ingredients')
              .add(ingredientData);
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ingredient ${_isEditing ? "Modified" : "Added"} successfully!')),
        );

        Navigator.pop(context);
      } catch (e) {
        print("Error saving ingredient: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving ingredient.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Modify Ingredient' : 'Add Ingredient'),
      ),
      body: Stack(
        children: [
          // Image Background with Blur Effect
          Positioned.fill(
            child: Image.asset(
              'assets/images/store.png',
              fit: BoxFit.cover,
            ),
          ),
          // Apply BackdropFilter for blur effect
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0), // Définir l'intensité du flou
              child: Container(
                color: Colors.black.withOpacity(0.4), // Ajoute une teinte sombre pour améliorer la lisibilité
              ),
            ),
          ),
          // Content of the page
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Nom',
                      labelStyle: TextStyle(color: Colors.black), // Couleur du label
                    ),
                    style: TextStyle(color: Colors.black), // Couleur du texte
                    validator: (value) => value == null || value.isEmpty ? 'Enter name ingredient!' : null,
                  ),
                  TextFormField(
                    controller: _priceController,
                    decoration: InputDecoration(
                      labelText: 'Price/DT',
                      labelStyle: TextStyle(color: Colors.black), // Couleur du label
                    ),
                    style: TextStyle(color: Colors.black), // Couleur du texte
                    keyboardType: TextInputType.number,
                    validator: (value) => value == null || value.isEmpty ? 'Add price!' : null,
                  ),
                  TextFormField(
                    controller: _quantityController,
                    decoration: InputDecoration(
                      labelText: 'Quantity/g',
                      labelStyle: TextStyle(color: Colors.black), // Couleur du label
                    ),
                    style: TextStyle(color: Colors.black), // Couleur du texte
                    keyboardType: TextInputType.number,
                    validator: (value) => value == null || value.isEmpty ? 'Add quantity!' : null,
                  ),
                  TextFormField(
                    controller: _imageController,
                    decoration: InputDecoration(
                      labelText: 'URL image (optional)',
                      labelStyle: TextStyle(color: Colors.black), // Couleur du label
                    ),
                    style: TextStyle(color: Colors.black), // Couleur du texte
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: saveIngredient,
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                    ),
                    child: Text(
                      _isEditing ? 'Modify' : 'Add',
                      style: TextStyle(color: Colors.black), // Couleur du texte du bouton
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => IngredientListPage(shopId: widget.shopId),
                        ),
                      );
                    },
                    child: Text(
                      'View Ingredient List',
                      style: TextStyle(color: Colors.black), // Couleur du texte
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
