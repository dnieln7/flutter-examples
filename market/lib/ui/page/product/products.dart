import 'package:flutter/material.dart';
import 'package:market/data/enum/FilterOptions.dart';
import 'package:market/data/provider/CartProvider.dart';
import 'package:market/data/provider/ProductProvider.dart';
import 'package:market/ui/page/cart/cart.dart';
import 'package:market/ui/res/style/TextStyles.dart';
import 'package:market/ui/widget/badge.dart';
import 'package:market/ui/widget/market/app_drawer.dart';
import 'package:market/ui/widget/market/product_grid.dart';
import 'package:provider/provider.dart';

class ProductList extends StatefulWidget {
  static const path = '/products';

  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  bool working = true;
  bool showFavorites = false;

  @override
  void initState() {
    // Future.delayed(Duration.zero).then(
    //   (_) => Provider.of<ProductProvider>(context).fetchFromNetwork(),
    // ); Also works. Also works with Modal of context

    Provider.of<ProductProvider>(context, listen: false)
        .fetchFromNetwork(false)
        .then((_) => setState(() => working = false))
        .catchError((error) => setState(() => working = false));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products Overview', style: TextStyles.APP_BAR),
        actions: [
          Consumer<CartProvider>(
            builder: (ctx, provider, child) => Badge(
              child: IconButton(
                icon: Icon(Icons.shopping_cart_outlined),
                onPressed: () => Navigator.of(context).pushNamed(Cart.path),
              ),
              value: provider.cartSize.toString(),
            ),
          ),
          PopupMenuButton(
            icon: Icon(Icons.filter_list_outlined),
            onSelected: (selected) => setState(
              () => showFavorites = selected == FilterOptions.Favorites,
            ),
            itemBuilder: (ctx) => [
              PopupMenuItem(
                child: Row(
                  children: [
                    Icon(
                      Icons.list_outlined,
                      color: Theme.of(context).primaryColor,
                    ),
                    SizedBox(width: 5),
                    Text('Show all'),
                  ],
                ),
                value: FilterOptions.All,
              ),
              PopupMenuItem(
                child: Row(
                  children: [
                    Icon(
                      Icons.favorite_outline,
                      color: Theme.of(context).primaryColor,
                    ),
                    SizedBox(width: 5),
                    Text('Show Favorites Only'),
                  ],
                ),
                value: FilterOptions.Favorites,
              )
            ],
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: working
          ? Center(child: CircularProgressIndicator())
          : ProductGrid(showFavorites),
    );
  }
}
