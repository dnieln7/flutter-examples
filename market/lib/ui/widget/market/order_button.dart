import 'package:flutter/material.dart';
import 'package:market/data/provider/CartProvider.dart';
import 'package:market/data/provider/OrderProvider.dart';
import 'package:market/ui/widget/dialog/material_dialog_neutral.dart';
import 'package:provider/provider.dart';

class OrderButton extends StatefulWidget {
  final CartProvider cart;

  OrderButton(this.cart);

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  bool working = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: working
          ? LinearProgressIndicator()
          : ElevatedButton(
              onPressed:
                  widget.cart.total <= 0 ? null : () => makeOrder(context),
              child: Text('ORDER NOW'),
            ),
    );
  }

  void makeOrder(context) {
    setState(() => working = true);

    Provider.of<OrderProvider>(context, listen: false)
        .add(widget.cart.items.values.toList(), widget.cart.total)
        .then((value) => {
              widget.cart.emptyCart(),
              setState(() => working = false),
            })
        .catchError(
          (error) => {
            showDialog(
              context: context,
              builder: (ctx) => MaterialDialogNeutral(
                  'An error has occurred', error.toString()),
            ).then((_) => setState(() => working = false))
          },
        );
  }
}
