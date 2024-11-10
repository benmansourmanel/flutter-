import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:mealmate/screens/categoryDetailPage.dart';
import '../models/shopsIngredient.dart';
import 'shops_form_page.dart'; // Assurez-vous que le chemin d'importation est correct.

class ShopsPage extends StatefulWidget {
  const ShopsPage({super.key});

  @override
  _ShopsPageState createState() => _ShopsPageState();
}

class _ShopsPageState extends State<ShopsPage> {
  List<Shop> shops = [];

  @override
  void initState() {
    super.initState();
    fetchShops();
  }

  void fetchShops() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('shops').get();
      setState(() {
        shops = snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return Shop.fromMap({
            ...data,
            'id': doc.id,
          });
        }).toList();
      });
    } catch (e) {
      print("Error fetching shops: $e");
    }
  }

  void addShop(Shop shop) async {
    try {
      await FirebaseFirestore.instance.collection('shops').add(shop.toMap());
      setState(() {
        shops.add(shop);
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Shop added successfully!')));
      Navigator.pop(context);
    } catch (e) {
      print("Error adding shop: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to add shop. Please try again.')));
    }
  }

  void modifyShop(int index, Shop updatedShop) async {
    try {
      await FirebaseFirestore.instance.collection('shops').doc(shops[index].id).update(updatedShop.toMap());
      setState(() {
        shops[index] = updatedShop;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Shop modified successfully!')));
      Navigator.pop(context);
    } catch (e) {
      print("Error modifying shop: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to modify shop. Please try again.')));
    }
  }

  void deleteShop(int index) async {
    try {
      await FirebaseFirestore.instance.collection('shops').doc(shops[index].id).delete();
      setState(() {
        shops.removeAt(index);
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Shop deleted successfully!')));
    } catch (e) {
      print("Error deleting shop: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to delete shop. Please try again.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shops'),
        backgroundColor: Color(0xff23AA49),
      ),
      body: ListView.builder(
        itemCount: shops.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(shops[index].name),
            subtitle: Text(shops[index].location),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ShopFormPage(
                          shop: shops[index],
                          onSubmit: (modifiedShop) => modifyShop(index, modifiedShop),
                        ),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => deleteShop(index),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ShopFormPage(onSubmit: addShop),
            ),
          );
        },
        backgroundColor: Color(0xff23AA49),
        child: const Icon(Icons.add),
      ),
    );
  }
}
