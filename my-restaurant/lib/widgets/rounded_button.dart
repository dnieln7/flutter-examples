import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  RoundedButton({
    @required this.label,
    this.expanded = false,
    @required this.theme,
    @required this.action,
  });

  final String label;
  final bool expanded;
  final Color theme;
  final Function action;

  @override
  Widget build(BuildContext context) {
    if (expanded) {
      return Container(
        width: double.infinity,
        child: RaisedButton(
          padding: EdgeInsets.all(10),
          color: theme,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          onPressed: () => action(),
          child: Text(
            label.toUpperCase(),
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      );
    }

    return RaisedButton(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      color: theme,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
      ),
      onPressed: action,
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }
}
