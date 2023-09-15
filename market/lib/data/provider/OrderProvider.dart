import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:market/data/model/CartItem.dart';
import 'package:market/data/model/Order.dart';
import 'package:market/service/ApiConfig.dart';

class OrderProvider with ChangeNotifier {
  String _token;
  String _userId;
  List<Order> _items;

  OrderProvider(this._token, this._userId, this._items);

  List<Order> get orders => [..._items];

  Future<bool> fetchFromNetwork() async {
    final String requestUrl =
        ApiConfig.db_url + '/orders/$_userId.json?auth=$_token';

    try {
      final response = await http.get(requestUrl);

      if (response.statusCode >= 400) {
        throw Exception('Could not fetch');
      }

      if (response.body == "null") {
        _items = [];
        return true;
      }

      final decoded = json.decode(response.body) as Map<String, dynamic>;
      final List<Order> list = [];

      decoded.forEach((id, data) => {
            list.add(
              Order(
                id: id,
                amount: data['amount'],
                date: DateTime.parse(data['date']),
                products: (data['products'] as List<dynamic>)
                    .map(
                      (p) => CartItem(
                        id: p['id'],
                        title: p['title'],
                        quantity: p['quantity'],
                        price: p['price'],
                      ),
                    )
                    .toList(),
              ),
            ),
          });

      _items = list.reversed.toList();

      return true;
    } catch (error) {
      throw error;
    }
  }

  Future<void> add(List<CartItem> products, double total) async {
    final String requestUrl =
        ApiConfig.db_url + '/orders/$_userId.json?auth=$_token';
    final order = Order(
      id: '',
      amount: total,
      products: products,
      date: DateTime.now(),
    );
    final body = {
      'amount': order.amount,
      'date': order.date.toIso8601String(),
      'products': order.products
          .map((p) => {
                'id': p.id,
                'title': p.title,
                'quantity': p.quantity,
                'price': p.price,
              })
          .toList(),
    };

    try {
      final response = await http.post(requestUrl, body: json.encode(body));
      final decoded = json.decode(response.body);

      order.id = decoded['name'];
      _items.insert(0, order);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
