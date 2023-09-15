import 'package:flutter/material.dart';
import 'package:my_restaurant/data/model/Cart.dart';
import 'package:my_restaurant/data/model/Meal.dart';
import 'package:my_restaurant/data/model/Order.dart';

class CartProvider with ChangeNotifier {
  Order _order = Order(id: 0, fulfilled: false);

  Meal _entrance;
  Meal _middle;
  Meal _stew;
  Meal _dessert;
  Meal _drink;
  double _total = 0.0;

  Cart get cart {
    return Cart(
      entrance: _entrance,
      middle: _middle,
      stew: _stew,
      dessert: _dessert,
      drink: _drink,
      total: _total,
    );
  }

  int get cartCount {
    var count = 0;

    if (_entrance != null) {
      count += 1;
    }
    if (_middle != null) {
      count += 1;
    }
    if (_stew != null) {
      count += 1;
    }
    if (_dessert != null) {
      count += 1;
    }
    if (_drink != null) {
      count += 1;
    }

    return count;
  }

  bool get valid {
    return _entrance != null && _stew != null && _drink != null;
  }

  Order get order {
    return Order(
      id: 0,
      fulfilled: false,
      type: _order.type,
      extras: _order.extras,
      comments: _order.comments,
      client_name: _order.client_name,
      client_phone: _order.client_phone,
      client_address_street: _order.client_address_street,
      client_address_city: _order.client_address_city,
      client_address_pc: _order.client_address_pc,
      client_address_references: _order.client_address_references,
      entrance: _order.entrance,
      middle: _order.middle,
      stew: _order.stew,
      dessert: _order.dessert,
      drink: _order.drink,
      date: _order.date,
      total: _order.total,
    );
  }

  void add(Meal meal) {
    switch (meal.type) {
      case 'Entrance':
        _entrance = meal;
        break;
      case 'Middle':
        _middle = meal;
        break;
      case 'Stew':
        _stew = meal;
        break;
      case 'Dessert':
        _dessert = meal;
        break;
      case 'Drink':
        _drink = meal;
        break;
    }

    _total += meal.price;

    notifyListeners();
  }

  void remove(Meal meal) {
    switch (meal.type) {
      case 'Entrance':
        _entrance = null;
        break;
      case 'Middle':
        _middle = null;
        break;
      case 'Stew':
        _stew = null;
        break;
      case 'Dessert':
        _dessert = null;
        break;
      case 'Drink':
        _drink = null;
        break;
    }

    _total -= meal.price;

    notifyListeners();
  }

  void setReservation(Map<String, String> info) {
    final cart = this.cart;

    _order.client_name = info['name'];
    _order.client_phone = info['phone'];
    _order.extras = info['extras'];
    _order.comments = info['comments'];
    _order.type = 'reservation';
    _order.client_address_street = 'N/A';
    _order.client_address_city = 'N/A';
    _order.client_address_pc = 'N/A';
    _order.client_address_references = 'N/A';
    _order.date = DateTime.now().toIso8601String();
    _order.entrance = cart.entrance;
    _order.middle = cart.middle;
    _order.stew = cart.stew;
    _order.dessert = cart.dessert;
    _order.drink = cart.drink;
    _order.total = cart.total;

    notifyListeners();
  }

  void setDelivery(Map<String, String> info) {
    final cart = this.cart;

    _order.client_name = info['name'];
    _order.client_phone = info['phone'];
    _order.extras = info['extras'];
    _order.comments = info['comments'];
    _order.type = 'delivery';
    _order.client_address_street = info['street'];
    _order.client_address_city = info['city'];
    _order.client_address_pc = info['pc'];
    _order.client_address_references = info['references'];
    _order.date = DateTime.now().toIso8601String();
    _order.entrance = cart.entrance;
    _order.middle = cart.middle;
    _order.stew = cart.stew;
    _order.dessert = cart.dessert;
    _order.drink = cart.drink;
    _order.total = cart.total;

    notifyListeners();
  }

  void clearCart() {
    _order = Order(id: 0, fulfilled: false);
    _entrance = null;
    _middle = null;
    _stew = null;
    _dessert = null;
    _drink = null;
    _total = 0.0;

    notifyListeners();
  }
}
