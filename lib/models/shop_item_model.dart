class ShopItemModel {
  final String imagePath;
  final String name;
  final String price;

  ShopItemModel({
    required this.imagePath,
    required this.name,
    required this.price,
  });

  static final List<ShopItemModel> shopItemList = [
    ShopItemModel(
      imagePath: "assets/images/pepper_red.png",
      name: "Bell Pepper Red",
      price: "250g, 0.740 DT", // Changed \DT to DT
    ),
    ShopItemModel(
      imagePath: "assets/images/butternut.png",
      name: "Butternut Squash",
      price: "250g, 0.970 DT",
    ),
    ShopItemModel(
      imagePath: "assets/images/ginger.png",
      name: "Arabic Ginger",
      price: "250g, 8.3 DT",
    ),
    // Add more items as necessary
  ];
}
