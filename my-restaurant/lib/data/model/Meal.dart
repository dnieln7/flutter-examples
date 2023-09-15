import 'package:flutter/material.dart';

class Meal {
  Meal({
    @required this.id,
    @required this.name,
    @required this.description,
    @required this.price,
    @required this.picture,
    @required this.type,
  });

  factory Meal.createMeal(Map<String, dynamic> data) {
    return Meal(
      id: int.parse(data['id'] ?? '0'),
      name: data['name'],
      description: data['description'],
      price: data['price'] + 0.0,
      picture: data['picture'],
      type: data['type'],
    );
  }

  final int id;
  final String name;
  final String description;
  final double price;
  final String picture;
  final String type;
}
