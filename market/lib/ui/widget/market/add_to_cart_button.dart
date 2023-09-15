import 'package:flutter/material.dart';
import 'package:market/data/model/Product.dart';
import 'package:market/data/provider/CartProvider.dart';

class AddToCartButton extends StatelessWidget {
  final Product product;
  final CartProvider cart;

  AddToCartButton(this.product, this.cart);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.add_shopping_cart_outlined),
      onPressed: () => add(context, product, cart),
    );
  }

  void add(context, Product product, CartProvider cart) {
    cart.add(product.id, product.price, product.title);

    Scaffold.of(context).hideCurrentSnackBar();
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text('Added to cart'),
        action: SnackBarAction(
          label: 'UNDO',
          onPressed: () => cart.decreaseItemCount(product.id),
        ),
      ),
    );
  }
}
