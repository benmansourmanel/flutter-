import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../models/meal.dart';

class MealFormPage extends StatefulWidget {
  final Meal? meal; // Existing meal to modify, if any
  final Function(Meal) onSubmit; // Function to call on form submission

  const MealFormPage({this.meal, required this.onSubmit, super.key});

  @override
  _MealFormPageState createState() => _MealFormPageState();
}

class _MealFormPageState extends State<MealFormPage> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker picker = ImagePicker();
  String name = '';
  String description = '';
  String category = 'Breakfast';
  XFile? pickedFile;
  final categories = ['Breakfast', 'Lunch', 'Dinner', 'Dessert'];

  @override
  void initState() {
    super.initState();
    // Pre-fill fields if modifying an existing meal
    if (widget.meal != null) {
      name = widget.meal!.name;
      description = widget.meal!.description;
      category = widget.meal!.category;
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        this.pickedFile = pickedFile; // Update pickedFile state
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save(); // Save form state
      widget.onSubmit(Meal(
        id: widget.meal?.id ?? '', // Include ID for existing meal
        name: name,
        description: description,
        category: category,
        imagePath: pickedFile?.path ?? '', // Optional imagePath
      ));
      Navigator.pop(context); // Navigate back after submission
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.meal == null ? 'Add Meal' : 'Modify Meal'),
        backgroundColor: Color(0xff23AA49),
      ),
      body: Stack(
        children: [
          // Background image
          Opacity(
            opacity: 0.3, // Adjust opacity as needed
            child: Image.asset(
              'assets/images/background.jpg', // Path to your background image
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          // Form content
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Name'),
                    initialValue: name,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a meal name.';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      name = value!;
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Description'),
                    initialValue: description,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a description.';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      description = value!;
                    },
                  ),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'Category'),
                    value: category,
                    items: categories.map((String category) {
                      return DropdownMenuItem<String>(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        category = value!;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a category.';
                      }
                      return null;
                    },
                  ),
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
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff23AA49),
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
