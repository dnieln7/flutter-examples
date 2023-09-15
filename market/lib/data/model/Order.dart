import 'package:flutter/foundation.dart';
import 'package:market/data/model/CartItem.dart';

class Order {
  String id;
  final double amount;
  final List<CartItem> products;
  final DateTime date;

  Order({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.date,
  });
}
