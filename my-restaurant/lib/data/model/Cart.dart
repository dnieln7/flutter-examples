import 'package:flutter/material.dart';
import 'package:my_restaurant/data/model/Meal.dart';

class Cart {
  Cart({
    @required this.entrance,
    @required this.middle,
    @required this.stew,
    @required this.dessert,
    @required this.drink,
    @required this.total,
  });

  final Meal entrance;
  final Meal middle;
  final Meal stew;
  final Meal dessert;
  final Meal drink;
  final double total;
}
