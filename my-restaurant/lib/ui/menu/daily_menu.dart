import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:my_restaurant/data/graphql/menu_graphs.dart';
import 'package:my_restaurant/data/model/Menu.dart';
import 'package:my_restaurant/data/provider/cart_provider.dart';
import 'package:my_restaurant/data/provider/session_provider.dart';
import 'package:my_restaurant/ui/cart/cart_review.dart';
import 'package:my_restaurant/ui/drawer/drawer_app.dart';
import 'package:my_restaurant/ui/meals/meal_detail.dart';
import 'package:my_restaurant/ui/menu/create_entrances.dart';
import 'package:my_restaurant/utils/navigation_utils.dart';
import 'package:my_restaurant/widgets/avatar/actionable_chip.dart';
import 'package:my_restaurant/widgets/badge.dart';
import 'package:my_restaurant/widgets/dialog/material_dialog_neutral.dart';
import 'package:my_restaurant/widgets/no_items_message.dart';
import 'package:my_restaurant/widgets/tile/meal_grid_tile.dart';
import 'package:provider/provider.dart';

class DailyMenu extends StatefulWidget {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  _DailyMenuState createState() => _DailyMenuState();
}

class _DailyMenuState extends State<DailyMenu> {
  int generate = 0;

  @override
  Widget build(BuildContext context) {
    final session = Provider.of<SessionProvider>(context);

    return Scaffold(
      key: widget._scaffoldKey,
      appBar: AppBar(
          title: Text(DrawerApp.menu), actions: createActions(session.isAuth)),
      drawer: DrawerApp(),
      body: createMenu(),
    );
  }

  void showHelpDialog() {
    showDialog(
      context: context,
      builder: (_) => MaterialDialogNeutral(
        'Help',
        'Touch a meal to see it\'s details',
      ),
    );
  }

  List<Widget> createActions(bool logged) {
    var actions = <Widget>[];

    if (logged) {
      actions = [
        IconButton(
          icon: Icon(Icons.receipt_long),
          tooltip: 'Publish today\'s menu',
          onPressed: () => NavigationUtils.push(context, CreateEntrances()),
        )
      ];
    } else {
      final cart = Provider.of<CartProvider>(context);

      actions = [
        Badge(
          child: IconButton(
            icon: Icon(Icons.shopping_cart),
            tooltip: 'Cart',
            onPressed: () => NavigationUtils.push(context, CartReview()),
          ),
          value: '${cart.cartCount}',
        ),
      ];
    }

    return actions;
  }

  Widget createMenu() {
    return Query(
      options: QueryOptions(document: gql(MenuGraphs.get)),
      builder: (result, {fetchMore, refetch}) {
        if (result.hasException) {
          return NoItemsMessage(
            title: 'Error',
            subtitle: result.exception.toString(),
            icon: Icons.error_outline,
          );
        }

        if (result.isLoading) {
          return Center(child: CircularProgressIndicator());
        }

        var data = result.data['menu'] as Map<String, dynamic>;
        var menu = Menu.fromJson(data);
        var tiles = <Widget>[];

        if (menu.entrances.isEmpty) {
          return NoItemsMessage(
            title: 'We are sorry',
            subtitle: 'Today\'s menu has not been published',
            icon: Icons.watch_later,
          );
        }

        if (generate == 1 || generate == 0) {
          menu.entrances.forEach((meal) => tiles.add(
                MealGridTile(
                  meal,
                  () => NavigationUtils.push(
                    context,
                    MealDetail(meal),
                  ),
                ),
              ));
        }
        if (generate == 2 || generate == 0) {
          menu.middles.forEach((meal) => tiles.add(
                MealGridTile(
                  meal,
                  () => NavigationUtils.push(
                    context,
                    MealDetail(meal),
                  ),
                ),
              ));
        }
        if (generate == 3 || generate == 0) {
          menu.stews.forEach((meal) => tiles.add(
                MealGridTile(
                  meal,
                  () => NavigationUtils.push(
                    context,
                    MealDetail(meal),
                  ),
                ),
              ));
        }
        if (generate == 4 || generate == 0) {
          menu.desserts.forEach((meal) => tiles.add(
                MealGridTile(
                  meal,
                  () => NavigationUtils.push(
                    context,
                    MealDetail(meal),
                  ),
                ),
              ));
        }
        if (generate == 5 || generate == 0) {
          menu.drinks.forEach((meal) => tiles.add(
                MealGridTile(
                  meal,
                  () => NavigationUtils.push(
                    context,
                    MealDetail(meal),
                  ),
                ),
              ));
        }

        return Padding(
          padding: EdgeInsets.all(3),
          child: Column(
            children: [
              Container(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      ActionableChip(
                        label: 'All',
                        theme: Theme.of(context).primaryColor,
                        action: () => setState(() => generate = 0),
                      ),
                      ActionableChip(
                        label: 'Entrances',
                        theme: Theme.of(context).primaryColor,
                        action: () => setState(() => generate = 1),
                      ),
                      ActionableChip(
                        label: 'Middles',
                        theme: Theme.of(context).primaryColor,
                        action: () => setState(() => generate = 2),
                      ),
                      ActionableChip(
                        label: 'Stews',
                        theme: Theme.of(context).primaryColor,
                        action: () => setState(() => generate = 3),
                      ),
                      ActionableChip(
                        label: 'Desserts',
                        theme: Theme.of(context).primaryColor,
                        action: () => setState(() => generate = 4),
                      ),
                      ActionableChip(
                        label: 'Drinks',
                        theme: Theme.of(context).primaryColor,
                        action: () => setState(() => generate = 5),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: GridView(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.90,
                    crossAxisSpacing: 3,
                    mainAxisSpacing: 3,
                  ),
                  children: tiles,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
