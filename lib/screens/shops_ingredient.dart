import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/shopsIngredient.dart';
import '../screens/shops_form_page.dart';

class ShopsIngredientPage extends StatefulWidget {
  const ShopsIngredientPage({super.key});

  @override
  _ShopsIngredientPageState createState() => _ShopsIngredientPageState();
}

class _ShopsIngredientPageState extends State<ShopsIngredientPage> {
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
          return Shop.fromMap(data, doc.id);
        }).toList();
      });
    } catch (e) {
      print("Erreur lors de la récupération des shops : $e");
    }
  }

  void _navigateToShopForm({Shop? shop}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ShopFormPage(
          shop: shop,
          onSubmit: (newShop) {
            // Logique pour ajouter ou mettre à jour le shop dans Firestore
            if (shop == null) {
              FirebaseFirestore.instance.collection('shops').add(newShop.toMap());
            } else {
              FirebaseFirestore.instance.collection('shops').doc(newShop.id).update(newShop.toMap());
            }
            fetchShops(); // Rafraîchir la liste après la soumission
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shops & Ingredients'),
        backgroundColor: const Color(0xff23AA49),
      ),
      body: shops.isEmpty
          ? const Center(child: Text("Aucun shop trouvé !"))
          : ListView.builder(
              itemCount: shops.length,
              itemBuilder: (context, index) {
                return Card(
                  color: Colors.white.withOpacity(0.8),
                  child: ListTile(
                    leading: const Icon(Icons.store, size: 50),
                    title: Text(shops[index].name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(shops[index].location),
                        Text(
                          'Ingrédients : ${shops[index].ingredients.map((ingredient) => ingredient.nameIngredient).join(', ')}',
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                    onTap: () => _navigateToShopForm(shop: shops[index]),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToShopForm(),
        backgroundColor: const Color(0xff23AA49),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
