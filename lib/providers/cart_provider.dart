import 'package:flutter/material.dart';
import '../models/cart_item.dart';

class CartProvider with ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  void addToCart(CartItem item) {
    // Check if item with same name and size exists, then update quantity
    final index = _items.indexWhere(
      (i) => i.name == item.name && i.size == item.size,
    );

    if (index != -1) {
      _items[index] = CartItem(
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

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
