import 'package:flutter/foundation.dart';
import 'package:my_restaurant/data/model/Meal.dart';

class Order {
  Order({
    @required this.id,
    @required this.fulfilled,
    this.type,
    this.extras,
    this.comments,
    this.client_name,
    this.client_phone,
    this.client_address_street,
    this.client_address_city,
    this.client_address_pc,
    this.client_address_references,
    this.entrance,
    this.middle,
    this.stew,
    this.dessert,
    this.drink,
    this.date,
    this.total,
  });

  factory Order.createOrder(Map<String, dynamic> data) {
    return Order(
      id: int.parse(data['id']),
      fulfilled: data['fulfilled'],
      type: data['type'],
      extras: data['extras'],
      comments: data['comments'],
      client_name: data['client_name'],
      client_phone: data['client_phone'],
      client_address_street: data['client_address_street'],
      client_address_city: data['client_address_city'],
      client_address_pc: data['client_address_pc'],
      client_address_references: data['client_address_references'],
      entrance: Meal(
        id: 0,
        name: data['entrance']['name'],
        description: data['entrance']['description'],
        price: double.parse('${data['entrance']['price']}'),
        picture: data['entrance']['picture'],
        type: data['entrance']['type'],
      ),
      middle: data['middle'] == null
          ? null
          : Meal(
              id: 0,
              name: data['middle']['name'],
              description: data['middle']['description'],
              price: double.parse('${data['middle']['price']}'),
              picture: data['middle']['picture'],
              type: data['middle']['type'],
            ),
      stew: Meal(
        id: 0,
        name: data['stew']['name'],
        description: data['stew']['description'],
        price: double.parse('${data['stew']['price']}'),
        picture: data['stew']['picture'],
        type: data['stew']['type'],
      ),
      dessert: data['dessert'] == null
          ? null
          : Meal(
              id: 0,
              name: data['dessert']['name'],
              description: data['dessert']['description'],
              price: double.parse('${data['dessert']['price']}'),
              picture: data['dessert']['picture'],
              type: data['dessert']['type'],
            ),
      drink: Meal(
        id: 0,
        name: data['drink']['name'],
        description: data['drink']['description'],
        price: double.parse('${data['drink']['price']}'),
        picture: data['drink']['picture'],
        type: data['drink']['type'],
      ),
      date: data['date'],
      total: double.parse('${data['total']}'),
    );
  }

  int id;
  bool fulfilled;
  String type;
  String extras;
  String comments;
  String client_name;
  String client_phone;
  String client_address_street;
  String client_address_city;
  String client_address_pc;
  String client_address_references;
  Meal entrance;
  Meal middle;
  Meal stew;
  Meal dessert;
  Meal drink;
  String date;
  double total;
}
