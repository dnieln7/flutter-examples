import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:my_restaurant/data/graphql/graphql_configuration.dart';
import 'package:my_restaurant/data/graphql/order_graphs.dart';
import 'package:my_restaurant/data/model/Order.dart';
import 'package:my_restaurant/res/palette.dart';
import 'package:my_restaurant/ui/drawer/drawer_app.dart';
import 'package:my_restaurant/ui/order/order_detail.dart';
import 'package:my_restaurant/utils/navigation_utils.dart';
import 'package:my_restaurant/widgets/avatar/avatar_chip.dart';
import 'package:my_restaurant/widgets/no_items_message.dart';

class Orders extends StatefulWidget {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  bool reloading = false;
  QueryResult result;

  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) => fetch());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: widget._scaffoldKey,
      appBar: AppBar(title: Text(DrawerApp.orders)),
      drawer: DrawerApp(),
      body: createList(),
    );
  }

  Widget createList() {
    if (result == null) {
      return Center(child: CircularProgressIndicator());
    }

    if (result.hasException) {
      return RefreshIndicator(
        onRefresh: fetch,
        child: SingleChildScrollView(
          child: NoItemsMessage(
            title: 'Error',
            subtitle: result.exception.toString(),
            icon: Icons.error,
          ),
        ),
      );
    }

    var data = result.data['orders'] as List<Object>;
    var orders = List<Order>.from(data.map((item) => Order.createOrder(item)));

    if (orders.isEmpty) {
      return RefreshIndicator(
        onRefresh: fetch,
        child: SingleChildScrollView(
          child: NoItemsMessage(
            title: 'No orders',
            subtitle: 'Customers orders will appear here',
            icon: Icons.search_off,
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: fetch,
      child: ListView.separated(
        itemBuilder: (context, index) => createListTile(context, orders[index]),
        separatorBuilder: (context, index) => Divider(),
        itemCount: orders.length,
      ),
    );
  }

  Widget createListTile(BuildContext context, Order order) {
    Widget chip;

    if (order.fulfilled) {
      chip = AvatarChip(
        label: 'Done',
        avatar: Text('✔'),
        theme: Palette.success,
        textTheme: Colors.white,
      );
    } else {
      chip = AvatarChip(
        label: 'To do',
        avatar: Text('✘'),
        theme: Palette.error,
        textTheme: Colors.white,
      );
    }

    return ListTile(
      title: Text(
        order.client_name,
        style: TextStyle(fontSize: 18),
        softWrap: false,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        order.type,
        style: TextStyle(fontSize: 16, color: Colors.black54),
      ),
      trailing: chip,
      onTap: () => NavigationUtils.push(context, OrderDetail(order))
          .then((_) => fetch()),
    );
  }

  Future<QueryResult> fetch() async {
    setState(() => this.result = null);

    final client = await GraphQLConfiguration.getAuthClient();
    final options = QueryOptions(
      document: gql(OrderGraphs.get),
      fetchPolicy: FetchPolicy.cacheAndNetwork,
    );
    final result = await client.query(options);
    setState(() => this.result = result);

    return result;
  }
}
