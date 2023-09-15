import 'package:flutter/material.dart';
import 'package:market/data/provider/ProductProvider.dart';
import 'package:market/ui/widget/market/product_grid_tile.dart';
import 'package:provider/provider.dart';

class ProductGrid extends StatelessWidget {
  final bool _favorites;

  ProductGrid(this._favorites);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductProvider>(context);
    final products = _favorites ? provider.favoriteProducts : provider.products;

    return GridView.builder(
      padding: EdgeInsets.symmetric(horizontal: 10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: products.length,
      itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
        value: products[index],
        child: ProductGridTile(),
      ),
    );
  }
}

/*
Provider.value when we use recycled objects because the provider will be attach to the data
Provider with create when i have to instance a new object so the provider is attach to the widget
 */
