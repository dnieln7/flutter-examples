import 'package:flutter/material.dart';
import 'package:market/data/model/Auth.dart';
import 'package:market/ui/page/order/orders.dart';
import 'package:market/ui/page/product/products.dart';
import 'package:market/ui/page/user/products/user_products.dart';
import 'package:market/ui/res/style/TextStyles.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text('Market', style: TextStyles.FONT_ANTON),
            centerTitle: true,
            automaticallyImplyLeading: false,
          ),
          SizedBox(height: 20),
          ListTile(
            leading: Icon(
              Icons.store_outlined,
              color: Theme.of(context).primaryColor,
            ),
            title: Text('Products', style: TextStyles.BODY_DARK),
            onTap: () =>
                Navigator.of(context).pushReplacementNamed(ProductList.path),
          ),
          ListTile(
            leading: Icon(
              Icons.payment_outlined,
              color: Theme.of(context).primaryColor,
            ),
            title: Text('Orders', style: TextStyles.BODY_DARK),
            onTap: () =>
                Navigator.of(context).pushReplacementNamed(Orders.path),
          ),
          ListTile(
            leading: Icon(
              Icons.admin_panel_settings_outlined,
              color: Theme.of(context).primaryColor,
            ),
            title: Text('My Products', style: TextStyles.BODY_DARK),
            onTap: () =>
                Navigator.of(context).pushReplacementNamed(UserProducts.path),
          ),
          ListTile(
            leading: Icon(
              Icons.login_outlined,
              color: Theme.of(context).primaryColor,
            ),
            title: Text('Log out', style: TextStyles.BODY_DARK),
            onTap: () => {
              Navigator.of(context).pop(),
              Provider.of<Auth>(context, listen: false).logOut(),
            },
          ),
        ],
      ),
    );
  }
}
