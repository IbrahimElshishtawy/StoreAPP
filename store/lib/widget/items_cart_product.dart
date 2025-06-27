import 'package:flutter/material.dart';
import 'package:store/models/prodect_model.dart';

class CartProvider extends ChangeNotifier {
  final List<ProductModel> _items = [];
  final Map<String, int> _quantities = {};

  List<ProductModel> get items => _items;
  Map<String, int> get quantities => _quantities;

  void addItem(ProductModel product) {
    if (!_items.contains(product)) {
      _items.add(product);
      _quantities[product.id] = 1;
    } else {
      _quantities[product.id] = (_quantities[product.id] ?? 1) + 1;
    }
    notifyListeners();
  }

  void increaseQuantity(String productId) {
    _quantities[productId] = (_quantities[productId] ?? 1) + 1;
    notifyListeners();
  }

  void decreaseQuantity(String productId) {
    if (_quantities.containsKey(productId)) {
      if (_quantities[productId]! > 1) {
        _quantities[productId] = _quantities[productId]! - 1;
      } else {
        _quantities.remove(productId);
        _items.removeWhere((item) => item.id == productId);
      }
      notifyListeners();
    }
  }

  void removeFromCart(ProductModel product) {
    _items.remove(product);
    _quantities.remove(product.id);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    _quantities.clear();
    notifyListeners();
  }

  double get totalPrice {
    double total = 0.0;
    for (var product in _items) {
      final qty = _quantities[product.id] ?? 1;
      total += (product.price ?? 0) * qty;
    }
    return total;
  }

  List<Map<String, dynamic>> get cartItemsForOrder {
    return _items.map((product) {
      final qty = _quantities[product.id] ?? 1;
      return {
        'id': product.id,
        'title': product.title,
        'price': product.price,
        'imageUrl': product.imageUrl,
        'quantity': qty,
      };
    }).toList();
  }
}
