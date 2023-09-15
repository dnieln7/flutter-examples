import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:market/ui/widget/market/cart_footer.dart';
import 'package:market/ui/widget/market/cart_header.dart';
import 'package:market/ui/widget/market/cart_list.dart';

class Cart extends StatelessWidget {
  static const path = '/cart';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Cart'),
      ),
      body: Column(
        children: [
          CardHeader(),
          Expanded(child: CartList()),
          CartFooter(),
        ],
      ),
    );
  }
}
