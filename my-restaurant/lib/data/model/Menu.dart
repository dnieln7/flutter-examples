import 'package:my_restaurant/data/model/Meal.dart';

class Menu {
  Menu({this.entrances, this.middles, this.stews, this.desserts, this.drinks});

  factory Menu.fromJson(Map<String, dynamic> data) {
    var entrances = List<Meal>.from(
      (data['entrances'] as List<Object>).map((item) => Meal.createMeal(item)),
    );
    var middles = List<Meal>.from(
      (data['middles'] as List<Object>).map((item) => Meal.createMeal(item)),
    );
    var stews = List<Meal>.from(
      (data['stews'] as List<Object>).map((item) => Meal.createMeal(item)),
    );
    var desserts = List<Meal>.from(
      (data['desserts'] as List<Object>).map((item) => Meal.createMeal(item)),
    );
    var drinks = List<Meal>.from(
      (data['drinks'] as List<Object>).map((item) => Meal.createMeal(item)),
    );

    return Menu(
      entrances: entrances,
      middles: middles,
      stews: stews,
      desserts: desserts,
      drinks: drinks,
    );
  }

  List<Meal> entrances;
  List<Meal> middles;
  List<Meal> stews;
  List<Meal> desserts;
  List<Meal> drinks;
}
