import 'package:flutter/material.dart';
import 'package:my_restaurant/res/palette.dart';

class DeleteTouchableListTile extends StatelessWidget {
  DeleteTouchableListTile({
    @required this.image,
    @required this.title,
    this.subtitle,
    @required this.touchAction,
    @required this.deleteAction,
  });

  final String image;
  final String title;
  final String subtitle;
  final Function touchAction;
  final Function deleteAction;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => touchAction(),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Image.network(
          image,
          width: 100,
          fit: BoxFit.cover,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: Colors.black,
          fontSize: 18,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: TextStyle(
                fontSize: 16,
              ),
            )
          : null,
      trailing: deleteAction != null
          ? IconButton(
              onPressed: deleteAction,
              icon: Icon(Icons.delete_rounded, color: Palette.error),
            )
          : Padding(
              padding: EdgeInsets.only(right: 10),
              child: Icon(
                Icons.keyboard_arrow_right_rounded,
                color: Theme.of(context).primaryColor,
              ),
            ),
    );
  }
}
