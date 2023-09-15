import 'package:flutter/material.dart';
import 'package:my_restaurant/data/provider/session_provider.dart';
import 'package:my_restaurant/res/strings.dart';
import 'package:my_restaurant/ui/login/login.dart';
import 'package:my_restaurant/ui/meals/meals.dart';
import 'package:my_restaurant/ui/menu/daily_menu.dart';
import 'package:my_restaurant/ui/order/orders.dart';
import 'package:my_restaurant/utils/navigation_utils.dart';
import 'package:my_restaurant/widgets/tile/drawer_title.dart';
import 'package:provider/provider.dart';

class DrawerApp extends StatelessWidget {
  static const String menu = "Today's menu";
  static const String meals = 'Meals';
  static const String memories = 'Memories';
  static const String orders = 'Orders';
  static const String logout = 'Log out';
  static const String employees = 'Employees section';

  @override
  Widget build(BuildContext context) {
    final session = Provider.of<SessionProvider>(context);
    final logged = session.isAuth;

    return Drawer(
      child: Column(
        children: <Widget>[
          DrawerTitle(Strings.appName, Theme.of(context).primaryColor),
          SizedBox(height: 20),
          drawerTile(context, DailyMenu(), Icons.menu_book, DrawerApp.menu),
          if (logged)
            drawerTile(context, Meals(), Icons.restaurant, DrawerApp.meals),
          if (logged)
            drawerTile(context, Orders(), Icons.shopping_bag, DrawerApp.orders),
          if (logged) logoutTile(context),
          if (!logged)
            drawerTile(context, Login(), Icons.login, DrawerApp.employees),
        ],
      ),
    );
  }

  void logOut(BuildContext context) {
    Provider.of<SessionProvider>(context, listen: false).logOut();
    NavigationUtils.replace(context, DailyMenu());
  }

  Widget logoutTile(BuildContext context) {
    return ListTile(
      onTap: () => logOut(context),
      leading:
          Icon(Icons.logout, size: 25, color: Theme.of(context).primaryColor),
      title: Text(DrawerApp.logout, style: TextStyle(fontSize: 18)),
    );
  }

  Widget drawerTile(
    BuildContext context,
    Widget destination,
    IconData icon,
    String label,
  ) {
    return ListTile(
        onTap: () => NavigationUtils.replace(context, destination),
        leading: Icon(icon, size: 25, color: Theme.of(context).primaryColor),
        title: Text(label, style: TextStyle(fontSize: 18)));
  }
}
