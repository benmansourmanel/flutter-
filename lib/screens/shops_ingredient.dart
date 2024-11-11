import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/shopsIngredient.dart';
import 'shops_form_page.dart';
import 'ingredient_page.dart';

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

  void _navigateToIngredientPage(String shopId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => IngredientPage(shopId: shopId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shops'),
        backgroundColor: Color(0xff23AA49),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/shopsback.png'), // Chemin de l'image de fond
                fit: BoxFit.cover,
              ),
            ),
          ),
          GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Nombre de colonnes
              crossAxisSpacing: 10.0, // Espacement horizontal entre les grilles
              mainAxisSpacing: 10.0, // Espacement vertical entre les grilles
              childAspectRatio: 3 / 2, // Ratio de la taille des enfants
            ),
            itemCount: shops.length,
            itemBuilder: (context, index) {
              return Card(
                color: Colors.white.withOpacity(0.8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      shops[index].name,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      shops[index].location,
                      style: TextStyle(color: Colors.black54),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(Icons.food_bank, color: Colors.green),
                          onPressed: () => _navigateToIngredientPage(shops[index].id),
                        ),
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
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => deleteShop(index),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ],
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
