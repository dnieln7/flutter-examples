import 'package:flutter/material.dart';
import 'package:market/data/provider/ProductProvider.dart';
import 'package:market/ui/page/user/products/edit_product.dart';
import 'package:market/ui/widget/image_actions_list_tile.dart';
import 'package:market/ui/widget/market/app_drawer.dart';
import 'package:provider/provider.dart';

class UserProducts extends StatelessWidget {
  static const path = '/user/products';

  Future<void> refresh(BuildContext context) async {
    await Provider.of<ProductProvider>(context, listen: false)
        .fetchFromNetwork(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My products'),
        actions: [
          IconButton(
            icon: Icon(Icons.add_outlined),
            onPressed: () => Navigator.of(context).pushNamed(EditProduct.path),
          )
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
          future: refresh(context),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.error != null) {
              return Center(
                child: Text('There was an error'),
              );
            } else {
              return RefreshIndicator(
                onRefresh: () => refresh(context),
                child: Consumer<ProductProvider>(
                  builder: (ctx, provider, child) => Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: ListView.separated(
                      itemCount: provider.products.length,
                      separatorBuilder: (ctx, index) => Divider(),
                      itemBuilder: (ctx, index) => ImageActionsListTile(
                        provider.products[index],
                      ),
                    ),
                  ),
                ),
              );
            }
          }),
    );
  }
}
