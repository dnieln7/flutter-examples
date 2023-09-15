import 'package:flutter/material.dart';
import 'package:market/data/model/CartItem.dart';
import 'package:market/ui/res/style/TextStyles.dart';
import 'package:market/ui/widget/dialog/material_dialog_yes_no.dart';

class CartListTile extends StatelessWidget {
  final Function _onDelete;
  final CartItem _cartItem;

  CartListTile(this._onDelete, this._cartItem);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(_cartItem.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) => confirmDelete(context),
      onDismissed: (direction) => _onDelete(),
      background: Container(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        padding: EdgeInsets.symmetric(horizontal: 10),
        alignment: Alignment.centerRight,
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete_outline,
          color: Colors.white,
          size: 30,
        ),
      ),
      child: Card(
        elevation: 2,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: ListTile(
            title: Text(_cartItem.title),
            leading: Icon(
              Icons.whatshot_outlined,
              size: 40,
              color: Theme.of(context).primaryColor,
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${_cartItem.quantity} X',
                  textAlign: TextAlign.end,
                  style: TextStyles.SUBTITLE_DARK,
                ),
                SizedBox(height: 5),
                Text(
                  '\$${(_cartItem.price * _cartItem.quantity)}',
                  style: TextStyles.BODY_DARK,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> confirmDelete(context) {
    return showDialog(
      context: context,
      builder: (ctx) => MaterialDialogYesNo(
        title: 'Are you sure?',
        body: 'Do you want to remove the item from the cart',
        negativeActionLabel: 'No',
        negativeAction: () => Navigator.of(ctx).pop(false),
        positiveActionLabel: 'Yes',
        positiveAction: () => Navigator.of(ctx).pop(true),
      ),
    );
  }
}
