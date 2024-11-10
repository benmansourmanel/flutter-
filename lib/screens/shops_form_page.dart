import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/shopsIngredient.dart';

class ShopFormPage extends StatefulWidget {
  final Shop? shop;
  final Function(Shop) onSubmit;

  const ShopFormPage({this.shop, required this.onSubmit, super.key});

  @override
  _ShopFormPageState createState() => _ShopFormPageState();
}

class _ShopFormPageState extends State<ShopFormPage> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker picker = ImagePicker();
  String name = '';
  String location = '';
  List<Category> categories = [];
  XFile? pickedFile;

  @override
  void initState() {
    super.initState();
    if (widget.shop != null) {
      name = widget.shop!.name;
      location = widget.shop!.location;
      categories = widget.shop!.categories;
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
        id: widget.shop?.id ?? '',
        name: name,
        location: location,
        categories: categories,
        imageUrl: pickedFile?.path,
      ));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.shop == null ? 'Add Shop' : 'Modify Shop'),
        backgroundColor: Color(0xff23AA49),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Name'),
                initialValue: name,
                validator: (value) {
                  if (value!.isEmpty) return 'Please enter a shop name.';
                  return null;
                },
                onSaved: (value) => name = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Location'),
                initialValue: location,
                validator: (value) {
                  if (value!.isEmpty) return 'Please enter a location.';
                  return null;
                },
                onSaved: (value) => location = value!,
              ),
              // Add additional form fields for categories and other fields as needed
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _pickImage,
                child: const Text('Upload Image'),
              ),
              if (pickedFile != null)
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Image.file(File(pickedFile!.path)),
                ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(backgroundColor: Color(0xff23AA49)),
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
