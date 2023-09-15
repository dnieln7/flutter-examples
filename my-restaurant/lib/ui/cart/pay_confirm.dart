import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:my_restaurant/data/graphql/order_graphs.dart';
import 'package:my_restaurant/data/model/Meal.dart';
import 'package:my_restaurant/data/model/Order.dart';
import 'package:my_restaurant/data/provider/cart_provider.dart';
import 'package:my_restaurant/ui/menu/daily_menu.dart';
import 'package:my_restaurant/utils/navigation_utils.dart';
import 'package:my_restaurant/utils/printer.dart';
import 'package:my_restaurant/widgets/dialog/material_dialog_neutral.dart';
import 'package:my_restaurant/widgets/label/column_label.dart';
import 'package:my_restaurant/widgets/rounded_button_icon.dart';
import 'package:my_restaurant/widgets/rounded_button_loading.dart';
import 'package:provider/provider.dart';

class PayConfirm extends StatefulWidget {
  @override
  _PayConfirmState createState() => _PayConfirmState();
}

class _PayConfirmState extends State<PayConfirm> {
  bool showBanner = true;
  bool working = false;

  @override
  Widget build(BuildContext context) {
    final order = Provider.of<CartProvider>(context, listen: false).order;

    return Scaffold(
      appBar: AppBar(title: Text('Review & pay')),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (showBanner && order.type == 'reservation')
                MaterialBanner(
                  leading: Icon(
                    Icons.restaurant,
                    size: 50,
                    color: Theme.of(context).primaryColor,
                  ),
                  content: Text(
                    'This is a reservation if you want to eat at home change your order to a delivery in the previous screen.',
                    style: TextStyle(fontSize: 16),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => setState(() => showBanner = false),
                      child: Text('DISMISS'),
                    )
                  ],
                  backgroundColor: Theme.of(context).canvasColor,
                  forceActionsBelow: true,
                ),
              ColumnLabel(label: 'Name', text: order.client_name),
              ColumnLabel(label: 'Phone', text: order.client_phone),
              ColumnLabel(
                label: 'Extras',
                text: order.extras.isEmpty ? 'No extras' : order.extras,
              ),
              ColumnLabel(
                label: 'Comments',
                text: order.comments.isEmpty ? 'No comments' : order.comments,
              ),
              ...createAddressRows(order),
              Container(
                padding: EdgeInsets.all(10),
                child: Text(
                  'Your order: ',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 14,
                  ),
                ),
              ),
              ...createCartRows(order),
              SizedBox(height: 20),
              if (working)
                RoundedButtonLoading(
                  label: 'placing your order...',
                  theme: Theme.of(context).primaryColor,
                  textTheme: Colors.white,
                ),
              if (!working)
                Mutation(
                  options: MutationOptions(
                    document: gql(OrderGraphs.post),
                    update: (cache, result) {
                      if (result.hasException) {
                        Printer.showErrorDialog(context, result.exception);
                        setState(() => working = false);
                      } else {
                        if (result.data['createOrder']['id'] != null) {
                          showDoneDialog();
                          Provider.of<CartProvider>(context, listen: false)
                              .clearCart();
                        }
                      }
                      return cache;
                    },
                  ),
                  builder: (runMutation, result) {
                    return RoundedButtonIcon(
                      label: 'Pay',
                      theme: Theme.of(context).primaryColor,
                      icon: Icons.attach_money,
                      iconTheme: Colors.white,
                      action: () => startWork(runMutation, order),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> createAddressRows(Order order) {
    var rows = <Widget>[];

    if (order.type == 'delivery') {
      rows = [
        ColumnLabel(label: 'Street', text: order.client_address_street),
        ColumnLabel(label: 'City', text: order.client_address_city),
        ColumnLabel(label: 'Postal code', text: order.client_address_pc),
        ColumnLabel(
          label: 'References',
          text: order.client_address_references == 'N/A'
              ? 'No references'
              : order.client_address_references,
        ),
      ];
    }

    return rows;
  }

  List<Widget> createCartRows(Order order) {
    var rows = <Widget>[
      createListTile(order.entrance),
      Divider(),
      if (order.middle != null) createListTile(order.middle),
      if (order.middle != null) Divider(),
      createListTile(order.stew),
      Divider(),
      if (order.dessert != null) createListTile(order.dessert),
      if (order.dessert != null) Divider(),
      createListTile(order.drink),
    ];

    return rows;
  }

  Widget createListTile(Meal meal) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Image.network(
          meal.picture,
          width: 50,
          fit: BoxFit.cover,
        ),
      ),
      title: Text(
        meal.name,
        style: TextStyle(
          color: Colors.black,
          fontSize: 16,
        ),
      ),
      subtitle: Text(
        meal.type,
        style: TextStyle(
          fontSize: 14,
        ),
      ),
      trailing: Text(
        '1 x \$${meal.price}',
        style: TextStyle(
          fontSize: 14,
          color: Colors.black54,
        ),
      ),
    );
  }

  void startWork(RunMutation runMutation, Order order) {
    setState(() => working = true);

    var middle;
    var dessert;

    if (order.middle != null) {
      middle = {
        'name': order.middle.name,
        'description': order.middle.description,
        'price': order.middle.price,
        'picture': order.middle.picture,
        'type': order.middle.type,
      };
    }

    if (order.dessert != null) {
      dessert = {
        'name': order.dessert.name,
        'description': order.dessert.description,
        'price': order.dessert.price,
        'picture': order.dessert.picture,
        'type': order.dessert.type,
      };
    }

    runMutation({
      'order': {
        'type': order.type,
        'fulfilled': order.fulfilled,
        'extras': order.extras,
        'comments': order.comments,
        'client_name': order.client_name,
        'client_phone': order.client_phone,
        'client_address_street': order.client_address_street,
        'client_address_city': order.client_address_city,
        'client_address_pc': order.client_address_pc,
        'client_address_references': order.client_address_references,
        'entrance': {
          'name': order.entrance.name,
          'description': order.entrance.description,
          'price': order.entrance.price,
          'picture': order.entrance.picture,
          'type': order.entrance.type,
        },
        'middle': middle,
        'stew': {
          'name': order.stew.name,
          'description': order.stew.description,
          'price': order.stew.price,
          'picture': order.stew.picture,
          'type': order.stew.type,
        },
        'dessert': dessert,
        'drink': {
          'name': order.drink.name,
          'description': order.drink.description,
          'price': order.drink.price,
          'picture': order.drink.picture,
          'type': order.drink.type,
        },
        'date': order.date,
        'total': order.total,
      }
    });
  }

  void showDoneDialog() {
    showDialog(
      context: context,
      builder: (_) => MaterialDialogNeutral('', 'Your order has been made.'),
    ).then((_) => NavigationUtils.popAndReplace(context, DailyMenu()));
  }
}
