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
        price: "250g, 0.740\DT"),
    VegetableItemModel(
        imagePath: "assets/images/butternut.png",
        name: "Butternut Squash ",
        price: "250g, 0.970\DT"),
    VegetableItemModel(
        imagePath: "assets/images/ginger.png",
        name: "Arabic Ginger",
        price: "250g, 8.3\DT"),
    VegetableItemModel(
        imagePath: "assets/images/carrots.png",
        name: "Organic Carrots",
        price: "250, 0.860\DT"),
    VegetableItemModel(
        imagePath: "assets/images/tomato.png",
        name: "Tomato",
        price: "250g, 0.590\DT"),
    VegetableItemModel(
        imagePath: "assets/images/potato.png",
        name: "Potato ",
        price: "250g, 0.690\DT"),
    VegetableItemModel(
        imagePath: "assets/images/lemon.png",
        name: "Lemon",
        price: "250g, 0.990\DT"),
    VegetableItemModel(
        imagePath: "assets/images/cucember.png",
        name: "Cucembers",
        price: "250, 1.12\DT"),
         VegetableItemModel(
        imagePath: "assets/images/lettuce.png",
        name: "lettuce",
        price: "pice, 1.23\DT"),
  ];
}
