import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'ingredient_list_page.dart'; // Make sure to import your ingredient list page

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
      print("Erreur lors du chargement des données : $e");
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
          SnackBar(content: Text('Ingrédient ${_isEditing ? "modifié" : "ajouté"} avec succès !')),
        );

        Navigator.pop(context);
      } catch (e) {
        print("Erreur lors de l'enregistrement de l'ingrédient : $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de l\'enregistrement de l\'ingrédient.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Modifier un ingrédient' : 'Ajouter un ingrédient'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Nom'),
                validator: (value) => value == null || value.isEmpty ? 'Entrez le nom de l\'ingrédient' : null,
              ),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(labelText: 'Prix/250g'),
                keyboardType: TextInputType.number,
                validator: (value) => value == null || value.isEmpty ? 'Ajoutez le prix' : null,
              ),
              TextFormField(
                controller: _quantityController,
                decoration: InputDecoration(labelText: 'Quantité par 250g'),
                keyboardType: TextInputType.number,
                validator: (value) => value == null || value.isEmpty ? 'Ajoutez la quantité' : null,
              ),
              TextFormField(
                controller: _imageController,
                decoration: InputDecoration(labelText: 'URL de l\'image (optionnel)'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: saveIngredient,
                child: Text(_isEditing ? 'Modifier' : 'Ajouter'),
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
                child: Text('Voir la liste des ingrédients'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
