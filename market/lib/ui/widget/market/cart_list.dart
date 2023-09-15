import 'package:flutter/material.dart';
import 'package:market/data/provider/CartProvider.dart';
import 'package:market/ui/widget/market/cart_list_tile.dart';
import 'package:provider/provider.dart';

class CartList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CartProvider>(context);
    final items = provider.items.values.toList();
    final keys = provider.items.keys.toList();
    return ListView.builder(
      itemCount: provider.cartSize,
      itemBuilder: (ctx, index) => CartListTile(
        () => provider.delete(keys[index]),
        items[index],
      ),
    );
  }
}
