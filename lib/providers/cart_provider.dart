import 'package:flutter/foundation.dart';
import '../helpers/db_helper.dart';
import '../models/cart_item.dart';
import '../models/product.dart';

class CartProvider with ChangeNotifier {
  List<CartItem> _items = [];

  List<CartItem> get items => _items;

  // Getter untuk menghitung jumlah total item (digunakan oleh badge di catalog_page.dart)
  int get itemCount {
    return _items.fold(0, (sum, item) => sum + item.quantity);
  }

  // Getter untuk menghitung total harga keranjang
  double get totalPrice {
    return _items.fold(0.0, (sum, item) => sum + (item.price * item.quantity));
  }

  // Memuat item keranjang dari database SQLite
  Future<void> fetchAndSetCart() async {
    _items = await DBHelper.getCartItems();
    notifyListeners();
  }

  // Menambahkan produk ke keranjang
  Future<void> addToCart(Product product) async {
    final existingIndex = _items.indexWhere((item) => item.productId == product.id);

    if (existingIndex >= 0) {
      final existingItem = _items[existingIndex];
      final newQuantity = existingItem.quantity + 1;
      
      await DBHelper.updateCartQuantity(existingItem.id!, newQuantity);
      _items[existingIndex] = CartItem(
        id: existingItem.id,
        productId: existingItem.productId,
        name: existingItem.name,
        price: existingItem.price,
        quantity: newQuantity,
        imagePath: existingItem.imagePath,
      );
    } else {
      final newItem = CartItem(
        productId: product.id!,
        name: product.name,
        price: product.price,
        quantity: 1,
        imagePath: product.imagePath,
      );
      await DBHelper.insertCartItem(newItem);
      await fetchAndSetCart();
    }
    notifyListeners();
  }

  // Menambah kuantitas item (+1)
  Future<void> incrementQuantity(CartItem item) async {
    final newQuantity = item.quantity + 1;
    await DBHelper.updateCartQuantity(item.id!, newQuantity);
    
    final index = _items.indexWhere((element) => element.id == item.id);
    if (index >= 0) {
      _items[index] = CartItem(
        id: item.id,
        productId: item.productId,
        name: item.name,
        price: item.price,
        quantity: newQuantity,
        imagePath: item.imagePath,
      );
      notifyListeners();
    }
  }

  // Mengurangi kuantitas item (-1)
  Future<void> decrementQuantity(CartItem item) async {
    if (item.quantity > 1) {
      final newQuantity = item.quantity - 1;
      await DBHelper.updateCartQuantity(item.id!, newQuantity);
      
      final index = _items.indexWhere((element) => element.id == item.id);
      if (index >= 0) {
        _items[index] = CartItem(
          id: item.id,
          productId: item.productId,
          name: item.name,
          price: item.price,
          quantity: newQuantity,
          imagePath: item.imagePath,
        );
        notifyListeners();
      }
    } else {
      // Jika sisa 1 lalu dikurangi, hapus item dari keranjang
      await DBHelper.deleteCartItem(item.id!);
      _items.removeWhere((element) => element.id == item.id);
      notifyListeners();
    }
  }
}