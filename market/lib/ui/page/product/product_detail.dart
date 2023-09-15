import 'package:flutter/material.dart';
import 'package:market/data/provider/CartProvider.dart';
import 'package:market/data/provider/ProductProvider.dart';
import 'package:market/ui/res/style/TextStyles.dart';
import 'package:market/ui/widget/market/add_to_cart_button.dart';
import 'package:provider/provider.dart';

class ProductDetail extends StatelessWidget {
  static const path = '/products/detail';

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final id = ModalRoute.of(context).settings.arguments as String;
    final cart = Provider.of<CartProvider>(context, listen: false);
    final product =
        Provider.of<ProductProvider>(context, listen: false).findById(id);

    return Scaffold(
      floatingActionButton: AddToCartButton(product, cart),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(product.title, style: TextStyles.APP_BAR),
              ),
              background: Hero(
                tag: product.id,
                child: Image.network(
                  product.image,
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  '\$${product.price}',
                  textAlign: TextAlign.center,
                  style: TextStyles.TITLE_DARK,
                ),
              ),
              SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  'Details',
                  textAlign: TextAlign.start,
                  style: TextStyles.SUBTITLE_DARK,
                ),
              ),
              SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  '${product.description}',
                  textAlign: TextAlign.start,
                  style: TextStyles.BODY_DARK,
                ),
              ),
              SizedBox(height: 500),
            ]),
          ),
        ],
      ),
    );
  }
}
