import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:my_restaurant/data/graphql/graphql_configuration.dart';
import 'package:my_restaurant/data/provider/cart_provider.dart';
import 'package:my_restaurant/data/provider/session_provider.dart';
import 'package:my_restaurant/res/strings.dart';
import 'package:my_restaurant/ui/menu/daily_menu.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyRestaurant());
}

class MyRestaurant extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
        client: GraphQLConfiguration().client,
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (ctx) => CartProvider()),
            ChangeNotifierProvider(create: (ctx) => SessionProvider()),
          ],
          child: MaterialApp(
            title: Strings.appName,
            home: DailyMenu(),
            theme: ThemeData(
              primarySwatch: Colors.red,
              accentColor: Colors.redAccent,
              canvasColor: Color.fromRGBO(255, 240, 201, 1), // -> #FFF0C9
              fontFamily: 'Lato-Regular',
            ),
            debugShowCheckedModeBanner: false,
          ),
        ));
  }
}
