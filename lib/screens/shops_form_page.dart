import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../models/shopsIngredient.dart';

class ShopFormPage extends StatefulWidget {
  final Shop? shop; // Shop existant à modifier, le cas échéant
  final Function(Shop) onSubmit; // Fonction appelée lors de la soumission

  const ShopFormPage({this.shop, required this.onSubmit, super.key});

  @override
  _ShopFormPageState createState() => _ShopFormPageState();
}

class _ShopFormPageState extends State<ShopFormPage> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker picker = ImagePicker();
  String name = '';
  String location = '';
  XFile? pickedFile;

  @override
  void initState() {
    super.initState();
    // Pré-remplir les champs si un shop existant est fourni
    if (widget.shop != null) {
      name = widget.shop!.name;
      location = widget.shop!.location;
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        this.pickedFile = pickedFile;
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      widget.onSubmit(Shop(
        id: widget.shop?.id ?? '', // ID pour un shop existant
        name: name,
        location: location,
        ingredients: widget.shop?.ingredients ?? [], // Liste des ingrédients (vide si nouveau shop)
      ));
      Navigator.pop(context); // Retour après soumission
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.shop == null ? 'Add shop' : 'Modify shop'),
        backgroundColor: const Color(0xff23AA49),
      ),
      body: Stack(
        children: [
          // Image de fond
          Opacity(
            opacity: 0.3,
            child: Image.asset(
              'assets/images/store.jpg', // Chemin de l'image de fond
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          // Contenu du formulaire
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(labelText: ' Shop Name'),
                    initialValue: name,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please write shop name...';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      name = value!;
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Location'),
                    initialValue: location,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please write the location..';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      location = value!;
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _pickImage,
                    child: const Text('Upload image'),
                  ),
                  if (pickedFile != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Image.file(File(pickedFile!.path)),
                    ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff23AA49),
                    ),
                    child: const Text('Submit'),
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
