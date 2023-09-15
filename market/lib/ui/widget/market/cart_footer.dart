import 'package:flutter/material.dart';
import 'package:market/data/provider/CartProvider.dart';
import 'package:market/ui/res/style/TextStyles.dart';
import 'package:market/ui/widget/market/order_button.dart';
import 'package:provider/provider.dart';

class CartFooter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'SUBTOTAL',
                  style: TextStyles.bodyCustom(Theme.of(context).primaryColor),
                ),
                Text(
                  '\$${cart.total.toStringAsFixed(2)}',
                  style: TextStyles.bodyCustom(Theme.of(context).primaryColor),
                ),
              ],
            ),
            SizedBox(height: 10),
            OrderButton(cart),
          ],
        ),
      ),
    );
  }
}
