import 'package:flutter/material.dart';
import 'package:my_restaurant/data/model/Meal.dart';
import 'package:my_restaurant/utils/string_utils.dart';

class MealGridTile extends StatelessWidget {
  MealGridTile(this.meal, this.goDetail);

  final Meal meal;
  final Function goDetail;

  @override
  Widget build(BuildContext context) {
    return GridTile(
      child: GestureDetector(
        onTap: () => goDetail(),
        child: Image.network(
          meal.picture,
          height: double.infinity,
          width: double.infinity,
          fit: BoxFit.fill,
        ),
      ),
      footer: GridTileBar(
        backgroundColor: Theme.of(context).canvasColor.withOpacity(0.75),
        title: Text(meal.name,
            style: TextStyle(fontSize: 18, color: Colors.black)),
        subtitle: Text(
          meal.type.capitalize(),
          style: TextStyle(color: Colors.black54, fontSize: 15),
        ),
      ),
    );
  }
}
