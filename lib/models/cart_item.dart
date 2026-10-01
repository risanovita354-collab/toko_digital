class CartItem {
  final int? id;
  final int productId;
  final String name;
  final double price;
  final int quantity;
  final String imagePath;

  CartItem({
    this.id,
    required this.productId,
    required this.name,
    required this.price,
    required this.quantity,
    required this.imagePath,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'product_id': productId,
      'name': name,
      'price': price,
      'quantity': quantity,
      'image_path': imagePath,
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      id: map['id'],
      productId: map['product_id'],
      name: map['name'],
      price: map['price'],
      quantity: map['quantity'],
      imagePath: map['image_path'] ?? 'assets/images/tumbler 1.png',
    );
  }
}