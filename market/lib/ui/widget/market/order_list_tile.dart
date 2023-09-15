import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:market/data/model/CartItem.dart';
import 'package:market/data/model/Order.dart';

class OrderListTile extends StatefulWidget {
  final Order _order;

  OrderListTile(this._order);

  @override
  _OrderListTileState createState() => _OrderListTileState();
}

class _OrderListTileState extends State<OrderListTile> {
  bool expanded;

  @override
  void initState() {
    expanded = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      height: expanded ? ((widget._order.products.length) * 90.0) + 90 : 100,
      duration: Duration(milliseconds: 300),
      curve: Curves.linear,
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        elevation: 2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ListTile(
              leading: Icon(
                Icons.shopping_bag_outlined,
                size: 40,
                color: Theme.of(context).primaryColor,
              ),
              title: Text('\$${widget._order.amount}'),
              subtitle: Text(
                DateFormat(DateFormat.YEAR_MONTH_DAY)
                    .format(widget._order.date),
              ),
              trailing: IconButton(
                icon: Icon(
                  expanded
                      ? Icons.expand_less_outlined
                      : Icons.expand_more_outlined,
                ),
                onPressed: () => setState(() => expanded = !expanded),
              ),
            ),
            if (expanded) Divider(),
            if (expanded)
              Expanded(
                child: ListView.separated(
                  separatorBuilder: (ctx, _) => Divider(),
                  itemCount: widget._order.products.length,
                  itemBuilder: (ctx, index) =>
                      cartItemListTile(widget._order.products[index]),
                ),
              )
          ],
        ),
      ),
    );
  }

  Widget cartItemListTile(CartItem item) {
    return ListTile(
      title: Text(item.title),
      subtitle: Text('\$${item.price}'),
      trailing: Text('Qty.: ${item.quantity}'),
    );
  }
}
