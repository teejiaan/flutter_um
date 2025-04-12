import 'package:flutter/material.dart';
import '../models/cart_item.dart';

class CartProvider with ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;
  void updateQuantity(CartItem item, int newQuantity) {
    final index = _items.indexWhere(
      (e) => e.name == item.name && e.size == item.size,
    );
    if (index != -1) {
      _items[index] = CartItem(
        id: _items[index].id,
        name: item.name,
        imageUrl: item.imageUrl,
        price: item.price,
        quantity: newQuantity,
        size: item.size,
      );
      notifyListeners();
    }
  }

  void removeItem(CartItem item) {
    _items.removeWhere((e) => e.name == item.name && e.size == item.size);
    notifyListeners();
  }

  void addToCart(CartItem item) {
    // Check if item with same name and size exists, then update quantity
    final index = _items.indexWhere(
      (i) => i.name == item.name && i.size == item.size,
    );

    if (index != -1) {
      _items[index] = CartItem(
        id: _items[index].id,
        name: _items[index].name,
        imageUrl: _items[index].imageUrl,
        price: _items[index].price,
        quantity: _items[index].quantity + item.quantity,
        size: _items[index].size,
      );
    } else {
      _items.add(item);
    }

    notifyListeners();
  }

  double get totalAmount {
    return items.fold(0, (sum, item) => sum + (item.price * item.quantity));
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
