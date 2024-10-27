class CartItemModel {
  late final String imagePath;
  late final String name;
  late final String price;
  CartItemModel(
      {required this.imagePath, required this.name, required this.price});
  static final cartItemList = [
    CartItemModel(
        imagePath: "assets/images/pepper_red.png",
        name: "Bell Pepper Red",
        price: "250g, 0.740DT"),
    CartItemModel(
        imagePath: "assets/images/butternut.png",
        name: "Butternut Squash ",
        price: "250g, 0.970DT"),
    CartItemModel(
        imagePath: "assets/images/ginger.png",
        name: "Arabic Ginger",
        price: "250g, 8.3DT"),
    CartItemModel(
        imagePath: "assets/images/carrots.png",
        name: "Organic Carrots",
        price: "250, 0.860DT"),
    CartItemModel(
        imagePath: "assets/images/tomato.png",
        name: "Tomato",
        price: "250g, 0.590DT"),
    CartItemModel(
        imagePath: "assets/images/orange.png",
        name: "orange juice",
        price: "250g, 0.690DT"),
         CartItemModel(
    imagePath: "assets/images/potato.png",
        name: "potato",
        price: "250g, 0.690DT"),
         CartItemModel(
   imagePath: "assets/images/lemon.png",
        name: "lemon",
        price: "250g, 0.990DT"),
         CartItemModel(
    imagePath: "assets/images/cucember.png",
        name: "cucember",
        price: "250g, 1.12DT"),
     CartItemModel(
  imagePath: "assets/images/lettuce.png",
        name: "lettuce",
        price: "piece, 1.23DT"),
  ];
}
