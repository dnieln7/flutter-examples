import 'package:flutter/material.dart';
import 'package:market/data/model/Auth.dart';
import 'package:market/data/model/Product.dart';
import 'package:market/ui/res/style/TextStyles.dart';
import 'package:provider/provider.dart';

class ProductGridTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final auth = Provider.of<Auth>(context, listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: GridTile(
        footer: GridTileBar(
          backgroundColor: Colors.grey.shade100,
          title: Text(
            product.title,
            textAlign: TextAlign.start,
            overflow: TextOverflow.fade,
            style: TextStyles.BODY_DARK,
          ),
          trailing: Consumer<Product>(
            builder: (ctx, prod, child) => IconButton(
              icon: prod.isFavorite
                  ? Icon(Icons.favorite)
                  : Icon(Icons.favorite_outline),
              color: Theme.of(context).primaryColor,
              onPressed: () =>
                  prod.toggleFavoriteStatus(auth.token, auth.id).catchError(
                        (error) => Scaffold.of(context).showSnackBar(
                          SnackBar(content: Text(error.toString())),
                        ),
                      ),
            ),
          ),
          //leading: shopButton(context, provider, product),
        ),
        child: GestureDetector(
          onTap: () => Navigator.of(context).pushNamed(
            '/products/detail',
            arguments: product.id,
          ),
          child: Hero(
            tag: product.id,
            child: FadeInImage(
              placeholder: AssetImage('assets/images/product_placeholder.png'),
              image: NetworkImage(product.image),
              fit: BoxFit.fill,
            ),
          ),
        ),
      ),
    );
  }
}

/*
Consumer when you want some specific parts of the widget tree to update and not the entire build method
 */
