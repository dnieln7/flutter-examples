import 'package:flutter/material.dart';
import 'package:my_restaurant/data/model/Meal.dart';
import 'package:my_restaurant/data/provider/cart_provider.dart';
import 'package:my_restaurant/ui/cart/pay_details.dart';
import 'package:my_restaurant/utils/navigation_utils.dart';
import 'package:my_restaurant/widgets/dialog/material_dialog_yes_no.dart';
import 'package:my_restaurant/widgets/no_items_message.dart';
import 'package:my_restaurant/widgets/tile/delete_touchable_list_tile.dart';
import 'package:provider/provider.dart';

class CartReview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final menu = cart.cart;

    return Scaffold(
      appBar: AppBar(title: Text('My cart')),
      floatingActionButton: cart.valid
          ? FloatingActionButton(
              child: Icon(Icons.arrow_forward),
              onPressed: () => NavigationUtils.push(context, PayDetails()),
            )
          : Container(),
      body: ListView(
        children: [
          if (!cart.valid && cart.cartCount > 0)
            MaterialBanner(
              leading: Icon(
                Icons.remove_shopping_cart,
                size: 50,
                color: Theme.of(context).primaryColor,
              ),
              content: Text(
                'A valid order must have an entrance, stew and a drink.',
                style: TextStyle(fontSize: 16),
              ),
              actions: [Container()],
              backgroundColor: Theme.of(context).canvasColor,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            ),
          if (!cart.valid && cart.cartCount > 0) SizedBox(height: 10),
          if (menu.entrance != null)
            DeleteTouchableListTile(
              image: menu.entrance.picture,
              title: menu.entrance.name,
              subtitle: '\$${menu.entrance.price}',
              touchAction: () => {},
              deleteAction: () =>
                  showRemoveDialog(context, cart, menu.entrance),
            ),
          if (menu.middle != null)
            DeleteTouchableListTile(
              image: menu.middle.picture,
              title: menu.middle.name,
              subtitle: '\$${menu.middle.price}',
              touchAction: () => {},
              deleteAction: () => showRemoveDialog(context, cart, menu.middle),
            ),
          if (menu.stew != null)
            DeleteTouchableListTile(
              image: menu.stew.picture,
              title: menu.stew.name,
              subtitle: '\$${menu.stew.price}',
              touchAction: () => {},
              deleteAction: () => showRemoveDialog(context, cart, menu.stew),
            ),
          if (menu.dessert != null)
            DeleteTouchableListTile(
              image: menu.dessert.picture,
              title: menu.dessert.name,
              subtitle: '\$${menu.dessert.price}',
              touchAction: () => {},
              deleteAction: () => showRemoveDialog(context, cart, menu.dessert),
            ),
          if (menu.drink != null)
            DeleteTouchableListTile(
              image: menu.drink.picture,
              title: menu.drink.name,
              subtitle: '\$${menu.drink.price}',
              touchAction: () => {},
              deleteAction: () => showRemoveDialog(context, cart, menu.drink),
            ),
          if (cart.cartCount == 0)
            Container(
              margin: EdgeInsets.only(top: 20),
              child: NoItemsMessage(
                title: 'Your cart is empty',
                subtitle: 'Add meals from the menu',
                icon: Icons.remove_shopping_cart,
              ),
            ),
        ],
      ),
    );
  }

  void showRemoveDialog(BuildContext context, CartProvider cart, Meal meal) {
    showDialog(
      context: context,
      builder: (_) => MaterialDialogYesNo(
        title: 'Remove from cart',
        body: 'Are you sure?',
        positiveActionLabel: 'Yes',
        positiveAction: () => {cart.remove(meal), Navigator.pop(context)},
        negativeActionLabel: 'No',
        negativeAction: () => Navigator.pop(context),
      ),
    );
  }
}
