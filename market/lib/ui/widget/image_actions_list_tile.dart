import 'package:flutter/material.dart';
import 'package:market/data/model/Product.dart';
import 'package:market/data/provider/ProductProvider.dart';
import 'package:market/ui/page/user/products/edit_product.dart';
import 'package:provider/provider.dart';

class ImageActionsListTile extends StatelessWidget {
  final Product product;

  ImageActionsListTile(this.product);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(backgroundImage: NetworkImage(product.image)),
      title: Text(product.title),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              icon: Icon(
                Icons.edit_outlined,
                color: Theme.of(context).primaryColor,
              ),
              onPressed: () => Navigator.of(context).pushNamed(
                EditProduct.path,
                arguments: product.id,
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.delete_outline,
                color: Theme.of(context).errorColor,
              ),
              onPressed: () =>
                  Provider.of<ProductProvider>(context, listen: false)
                      .delete(product.id)
                      .catchError(
                        (error) => Scaffold.of(context).showSnackBar(
                          SnackBar(content: Text(error.toString())),
                        ),
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
