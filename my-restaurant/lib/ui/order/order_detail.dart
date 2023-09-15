import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:my_restaurant/data/graphql/graphql_configuration.dart';
import 'package:my_restaurant/data/graphql/order_graphs.dart';
import 'package:my_restaurant/data/model/Meal.dart';
import 'package:my_restaurant/data/model/Order.dart';
import 'package:my_restaurant/res/palette.dart';
import 'package:my_restaurant/utils/printer.dart';
import 'package:my_restaurant/widgets/dialog/material_dialog_neutral.dart';
import 'package:my_restaurant/widgets/dialog/material_dialog_yes_no.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderDetail extends StatefulWidget {
  OrderDetail(this._order);

  final Order _order;

  @override
  _OrderDetailState createState() => _OrderDetailState();
}

class _OrderDetailState extends State<OrderDetail> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool fulfilled;
  bool working = false;

  @override
  void initState() {
    fulfilled = widget._order.fulfilled;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(widget._order.client_name),
        actions: [
          IconButton(
            icon: Icon(Icons.person_pin),
            onPressed: () => showModalBottomSheet(
              context: context,
              backgroundColor: Colors.transparent,
              builder: (ctx) => createBottomModal(),
            ),
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: delete,
          ),
        ],
      ),
      floatingActionButton: working
          ? FloatingActionButton(
              onPressed: null,
              backgroundColor: fulfilled ? Palette.error : Palette.success,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Colors.white),
                strokeWidth: 2,
              ),
            )
          : FloatingActionButton(
              child: fulfilled ? Icon(Icons.close) : Icon(Icons.check),
              backgroundColor: fulfilled ? Palette.error : Palette.success,
              onPressed: () => update(),
            ),
      body: ListView(
        children: [
          createListTile(widget._order.entrance),
          if (widget._order.middle != null)
            createListTile(widget._order.middle),
          createListTile(widget._order.stew),
          if (widget._order.dessert != null)
            createListTile(widget._order.dessert),
          createListTile(widget._order.drink),
        ],
      ),
    );
  }

  Widget createListTile(Meal meal) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Image.network(
          meal.picture,
          height: double.infinity,
          width: 100,
          fit: BoxFit.cover,
        ),
      ),
      title: Text(
        meal.type,
        style: TextStyle(fontSize: 14, color: Colors.black54),
      ),
      subtitle: Text(
        meal.name,
        style: TextStyle(fontSize: 16, color: Colors.black),
      ),
    );
  }

  Widget createInfoRow(IconData icon, String tooltip, String text) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).primaryColor),
          SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$tooltip:',
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
              SizedBox(height: 5),
              Text(
                text,
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget createActionRow(IconData icon, String tooltip, String text) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, color: Theme.of(context).primaryColor),
          SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$tooltip:',
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
              SizedBox(height: 5),
              Text(
                text,
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
          Spacer(),
          TextButton(
            child: Text('CALL'),
            onPressed: () => makePhoneCall('tel:$text'),
          )
        ],
      ),
    );
  }

  Widget createBottomModal() {
    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).canvasColor,
        ),
        child: Column(
          children: [
            createInfoRow(Icons.person, 'Name', widget._order.client_name),
            createActionRow(Icons.phone, 'Phone', widget._order.client_phone),
            if (widget._order.extras.isNotEmpty)
              createInfoRow(
                Icons.add_comment,
                'Extras',
                widget._order.extras,
              ),
            if (widget._order.comments.isNotEmpty)
              createInfoRow(
                Icons.comment,
                'Comments',
                widget._order.comments,
              ),
            if (widget._order.type == 'delivery')
              createInfoRow(
                Icons.house,
                'Street',
                widget._order.client_address_street,
              ),
            if (widget._order.type == 'delivery')
              createInfoRow(
                Icons.location_city,
                'City',
                widget._order.client_address_city,
              ),
            if (widget._order.type == 'delivery')
              createInfoRow(
                Icons.home_work,
                'Postal code',
                widget._order.client_address_pc,
              ),
            if (widget._order.type == 'delivery')
              createInfoRow(
                Icons.contact_support,
                'References',
                widget._order.client_address_references,
              ),
            if (widget._order.type != 'delivery')
              createInfoRow(
                Icons.error,
                'This is a reservation',
                'No address provided by the client',
              ),
          ],
        ),
      ),
    );
  }

  void update() {
    showDialog(
      context: context,
      builder: (_) => MaterialDialogYesNo(
        title: fulfilled ? 'Mark as todo' : 'Mark as done',
        body: 'Are you sure?',
        positiveActionLabel: 'Continue',
        positiveAction: () async {
          Navigator.of(context).pop();
          setState(() => working = true);
          final client = await GraphQLConfiguration.getAuthClient();
          final options =
              MutationOptions(document: gql(OrderGraphs.put), variables: {
            'id': widget._order.id,
            'fulfilled': !fulfilled,
          });
          final result = await client.mutate(options);

          if (result.hasException) {
            await Printer.showErrorDialog(context, result.exception);
            setState(() => working = false);
          } else {
            if (result.data['updateOrderStatus']['rows'] > 0) {
              showDoneDialog();
              setState(() => {fulfilled = !fulfilled, working = false});
            }
          }
        },
        negativeActionLabel: 'Cancel',
        negativeAction: () => Navigator.of(context).pop(),
      ),
    );
  }

  void delete() {
    showDialog(
        context: context,
        builder: (ctx) => MaterialDialogYesNo(
            title: 'Delete Order',
            body: 'Are you sure? This can\'t be undone.',
            negativeActionLabel: 'Cancel',
            negativeAction: () => Navigator.of(context).pop(),
            positiveActionLabel: 'Continue',
            positiveAction: () async {
              Navigator.of(context).pop();
              final client = await GraphQLConfiguration.getAuthClient();
              final options = MutationOptions(
                  document: gql(OrderGraphs.delete),
                  variables: {
                    'id': widget._order.id,
                  });
              final result = await client.mutate(options);

              if (result.hasException) {
                await Printer.showErrorDialog(context, result.exception);
              } else {
                if (result.data['deleteOrder']['successful'] as bool) {
                  Navigator.of(context).pop();
                }
              }
            }));
  }

  Future<void> makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void showDoneDialog() {
    showDialog(
      context: context,
      builder: (_) => MaterialDialogNeutral('', 'This order was updated.'),
    );
  }
}
