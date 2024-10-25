import 'package:flutter/material.dart';
import '../models/shop_item_model.dart';

class ShopItemWidget extends StatelessWidget {
  final ShopItemModel item;

  const ShopItemWidget({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.asset(item.imagePath),
      title: Text(item.name),
      subtitle: Text(item.price),
      trailing: IconButton(
        icon: const Icon(Icons.add_shopping_cart),
        onPressed: () {
          // Add logic to add the item to the cart
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${item.name} added to cart')), // Adjusted message
          );
        },
      ),
    );
  }
}
