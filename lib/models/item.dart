class Item {
  final int quantity;
  final String name;

  Item({required this.name, required this.quantity});

  late final int _price = quantity * 12;
  get priceOfItem => _price;
}
