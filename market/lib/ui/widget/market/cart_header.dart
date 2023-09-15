import 'package:flutter/material.dart';
import 'package:market/data/provider/CartProvider.dart';
import 'package:market/ui/res/style/TextStyles.dart';
import 'package:provider/provider.dart';

class CardHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CartProvider>(context);

    return Card(
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Standard Delivery',
              style: TextStyles.SUBTITLE_DARK,
            ),
            Text(
              '\$${provider.total.toStringAsFixed(2)}',
              style: TextStyles.bodyCustom(Theme.of(context).primaryColor),
            ),
          ],
        ),
      ),
    );
  }
}
