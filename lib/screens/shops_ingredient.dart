import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/shopsIngredient.dart';
import 'shops_form_page.dart';
import 'ingredient_page.dart';

class ShopsPage extends StatefulWidget {
  const ShopsPage({super.key});                          
                                                                   //StatefulWidget
  @override
  _ShopsPageState createState() => _ShopsPageState();
}

class _ShopsPageState extends State<ShopsPage> {
  List<Shop> shops = [];
  List<Shop> filteredShops = [];                                // filteredShops: une liste filtrée de magasins selon la recherche de l'utilisateur.
  TextEditingController _searchController = TextEditingController();  //_searchController: un contrôleur pour gérer l'entrée de texte de recherche.

  @override
  void initState() {
    super.initState();
    fetchShops();
    _searchController.addListener(_filterShops);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
//récupère tous les magasins de la collection 'shops' dans Firestore et les transforme en objets Shop 
// w baad yaaml mise à jour d'etat du widget avec les magasins récupérés et les magasins filtrés.
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
        filteredShops = shops; // Initialize filteredShops with all shops
      });
    } catch (e) {
      print("Error fetching shops: $e");
    }
  }

  void _filterShops() {
    setState(() {
      String query = _searchController.text.toLowerCase();
      filteredShops = shops.where((shop) {
        return shop.name.toLowerCase().contains(query) ||
               shop.location.toLowerCase().contains(query);
      }).toList();
    });
  }

  void addShop(Shop shop) async {
    try {
      await FirebaseFirestore.instance.collection('shops').add(shop.toMap());
      setState(() {
        shops.add(shop);
        _filterShops(); // Update the filtered list after adding
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
        _filterShops(); // Update the filtered list after modification
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
        _filterShops(); // Update the filtered list after deletion
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Shop deleted successfully!')));
    } catch (e) {
      print("Error deleting shop: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to delete shop. Please try again.')));
    }
  }
//bch navigate vers la page des ingrédients d'un magasin spécifique
  void _navigateToIngredientPage(String shopId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => IngredientPage(shopId: shopId),
      ),
    );
  }
//interface UI
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
                image: AssetImage('assets/images/shopsback.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GridView.builder(                        //grid view
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                    childAspectRatio: 3 / 2,
                  ),
                  itemCount: filteredShops.length,
                  itemBuilder: (context, index) {
                    return Card(
                      color: Colors.white.withOpacity(0.8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            filteredShops[index].name,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            filteredShops[index].location,
                            style: TextStyle(color: Colors.black54),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: Icon(Icons.food_bank, color: Colors.green),
                                onPressed: () => _navigateToIngredientPage(filteredShops[index].id),
                              ),
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ShopFormPage(
                                        shop: filteredShops[index],
                                        onSubmit: (modifiedShop) => modifyShop(shops.indexOf(filteredShops[index]), modifiedShop),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () => deleteShop(shops.indexOf(filteredShops[index])),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
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
