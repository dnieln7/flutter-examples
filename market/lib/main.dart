import 'package:flutter/material.dart';
import 'package:market/data/model/Auth.dart';
import 'package:market/data/provider/CartProvider.dart';
import 'package:market/data/provider/OrderProvider.dart';
import 'package:market/data/provider/ProductProvider.dart';
import 'package:market/ui/page/auth/authenticating.dart';
import 'package:market/ui/page/auth/login.dart';
import 'package:market/ui/page/cart/cart.dart';
import 'package:market/ui/page/order/orders.dart';
import 'package:market/ui/page/product/product_detail.dart';
import 'package:market/ui/page/product/products.dart';
import 'package:market/ui/page/user/products/edit_product.dart';
import 'package:market/ui/page/user/products/user_products.dart';
import 'package:provider/provider.dart';

void main() => runApp(Market());

class Market extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Auth>(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProvider<CartProvider>(
          create: (ctx) => CartProvider(),
        ),
        ChangeNotifierProxyProvider<Auth, OrderProvider>(
          create: null,
          update: (ctx, auth, oldProvider) => OrderProvider(
            auth.token,
            auth.id,
            oldProvider == null
                ? []
                : oldProvider.orders == null
                    ? []
                    : oldProvider.orders,
          ),
        ),
        ChangeNotifierProxyProvider<Auth, ProductProvider>(
          create: null,
          update: (ctx, auth, oldProvider) => ProductProvider(
            auth.token,
            auth.id,
            oldProvider == null
                ? []
                : oldProvider.products == null
                    ? []
                    : oldProvider.products,
          ),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, provider, reusable) => MaterialApp(
          title: 'Market',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.deepPurple,
            accentColor: Colors.amber,
            canvasColor: Colors.white,
            fontFamily: 'Lato',
            visualDensity: VisualDensity.adaptivePlatformDensity,
            // pageTransitionsTheme: PageTransitionsTheme(builders: {
            //   TargetPlatform.android: FadeUpwardsPageTransitionsBuilder()
            // }),
          ),
          home: provider.isAuth
              ? ProductList()
              : FutureBuilder(
                  future: provider.tryAutoLogin(),
                  builder: (ctx, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Authenticating();
                    }

                    return Login();
                  },
                ),
          routes: {
            Login.path: (ctx) => Login(),
            ProductList.path: (ctx) => ProductList(),
            ProductDetail.path: (ctx) => ProductDetail(),
            Cart.path: (ctx) => Cart(),
            Orders.path: (ctx) => Orders(),
            UserProducts.path: (ctx) => UserProducts(),
            EditProduct.path: (ctx) => EditProduct(),
          },
        ),
      ),
    );
  }
}
