import 'package:flutter/material.dart';
import 'package:my_restaurant/data/model/Meal.dart';
import 'package:my_restaurant/data/provider/session_provider.dart';
import 'package:my_restaurant/widgets/sheet/meal_draggable_sheet.dart';
import 'package:provider/provider.dart';

class MealDetail extends StatelessWidget {
  const MealDetail(this.meal);

  final Meal meal;

  @override
  Widget build(BuildContext context) {
    final session = Provider.of<SessionProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            child: Image.network(
              meal.picture,
              fit: BoxFit.fill,
            ),
          ),
          MealDraggableSheet(meal, session.isAuth),
        ],
      ),
    );
  }
}
