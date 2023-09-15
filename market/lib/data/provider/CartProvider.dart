import 'package:flutter/foundation.dart';
import 'package:market/data/model/CartItem.dart';

class CartProvider with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => {..._items};

  int get cartSize => _items.length;

  double get total {
    var total = 0.0;

    _items.forEach((key, value) => total += (value.price * value.quantity));

    return total;
  }

  void add(String id, double price, String title) {
    if (_items.containsKey(id)) {
      _items.update(
        id,
        (old) => CartItem(
          id: old.id,
          title: old.title,
          quantity: old.quantity + 1,
          price: old.price,
        ),
      );
    } else {
      _items.putIfAbsent(
        id,
        () => CartItem(
          id: DateTime.now().toString(),
          title: title,
          quantity: 1,
          price: price,
        ),
      );
    }

    notifyListeners();
  }

  void delete(String id) {
    _items.remove(id);

    notifyListeners();
  }

  void decreaseItemCount(String id) {
    if (!_items.containsKey(id)) {
      return;
    }

    if (_items[id].quantity > 1) {
      _items.update(
        id,
        (existing) => CartItem(
          id: existing.id,
          title: existing.title,
          quantity: (existing.quantity - 1),
          price: existing.price,
        ),
      );
    } else {
      _items.remove(id);
    }

    notifyListeners();
  }

  void emptyCart() {
    _items = {};
    notifyListeners();
  }
}
