import 'package:flutter/material.dart';
import 'package:market/data/provider/OrderProvider.dart';
import 'package:market/ui/widget/market/app_drawer.dart';
import 'package:market/ui/widget/market/order_list_tile.dart';
import 'package:provider/provider.dart';

class Orders extends StatelessWidget {
  static const path = '/orders';

  /*
  If you have something that changes the state Future builder will be re created again
  to stop that we need to create the future as a property to ensure it doesn't executes
  when future builder is re created.

  Future ordersFuture;

  Future getOrdersFuture() {
    return Provider.of<OrderProvider>(context).fetchFromNetwork();
  }

  @override
  void initState() {
    ordersFuture = getOrdersFuture();
    super.initState();
  }
  */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My orders'),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: Provider.of<OrderProvider>(context).fetchFromNetwork(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.error != null) {
            return Center(
              child: Text('There was an error'),
            );
          } else {
            return Consumer<OrderProvider>(
              builder: (ctx, provider, child) => ListView.builder(
                itemCount: provider.orders.length,
                itemBuilder: (ctx, index) =>
                    OrderListTile(provider.orders[index]),
              ),
            );
          }
        },
      ),
    );
  }
}
