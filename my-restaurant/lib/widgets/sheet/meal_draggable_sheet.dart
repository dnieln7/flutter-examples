import 'package:flutter/material.dart';
import 'package:my_restaurant/data/model/Meal.dart';
import 'package:my_restaurant/data/provider/cart_provider.dart';
import 'package:my_restaurant/widgets/rounded_button.dart';
import 'package:provider/provider.dart';

class MealDraggableSheet extends StatelessWidget {
  MealDraggableSheet(this.meal, this.logged);

  final Meal meal;
  final bool logged;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.3,
      maxChildSize: 0.6,
      minChildSize: 0.1,
      builder: (ctx, controller) => SingleChildScrollView(
        controller: controller,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          margin: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Theme.of(context).canvasColor.withOpacity(0.90),
          ),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 100),
                child: Divider(
                  thickness: 3,
                  height: 30,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              Container(
                width: double.infinity,
                child: Text(
                  meal.name,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '\$${meal.price}',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(width: 10),
                  RoundedButton(
                    theme: Theme.of(context).primaryColor,
                    action: logged ? null : () => addToCart(context),
                    label: 'Add to cart',
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                alignment: Alignment.centerLeft,
                child: Text(
                  'Description',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 20),
                child: Text(
                  meal.description,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void addToCart(BuildContext context) {
    final cart = Provider.of<CartProvider>(context, listen: false);

    cart.add(meal);

    Scaffold.of(context).hideCurrentSnackBar();
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text('Added to cart'),
        action: SnackBarAction(
          label: 'UNDO',
          onPressed: () => cart.remove(meal),
        ),
      ),
    );
  }
}
