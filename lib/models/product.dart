class Product {
  final int? id;
  final String name;
  final String? description;
  final double price;
  final int quantity;

  Product({
    this.id,
    required this.name,
    this.description,
    required this.price,
    required this.quantity,
  });

  Map<String, Object?> toMap() => {
    'id': id,
    'name': name,
    'description': description,
    'price': price,
    'quantity': quantity,
  };

  factory Product.fromMap(Map<String, Object?> map) => Product(
    id: map['id'] as int?,
    name: map['name'] as String,
    description: map['description'] as String?,
    price: (map['price'] as num).toDouble(),
    quantity: (map['quantity'] as int),
  );
}
