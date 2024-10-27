class VegetableItemModel {
  late final String imagePath;
  late final String name;
  late final String price;
  VegetableItemModel(
      {required this.imagePath, required this.name, required this.price});
  static final vegetableItemList = [
    VegetableItemModel(
        imagePath: "assets/images/pepper_red.png",
        name: "Bell Pepper Red",
        price: "250g, 0.740DT"),
    VegetableItemModel(
        imagePath: "assets/images/butternut.png",
        name: "Butternut Squash ",
        price: "250g, 0.970DT"),
    VegetableItemModel(
        imagePath: "assets/images/ginger.png",
        name: "Arabic Ginger",
        price: "250g, 8.3DT"),
    VegetableItemModel(
        imagePath: "assets/images/carrots.png",
        name: "Organic Carrots",
        price: "250, 0.860DT"),
    VegetableItemModel(
        imagePath: "assets/images/tomato.png",
        name: "Tomato",
        price: "250g, 0.590DT"),
    VegetableItemModel(
        imagePath: "assets/images/potato.png",
        name: "Potato ",
        price: "250g, 0.690DT"),
    VegetableItemModel(
        imagePath: "assets/images/lemon.png",
        name: "Lemon",
        price: "250g, 0.990DT"),
    VegetableItemModel(
        imagePath: "assets/images/cucember.png",
        name: "Cucembers",
        price: "250, 1.12DT"),
         VegetableItemModel(
        imagePath: "assets/images/lettuce.png",
        name: "lettuce",
        price: "pice, 1.23DT"),
  ];
}
