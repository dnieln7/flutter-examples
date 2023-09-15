import 'package:flutter/material.dart';

class RoundedButtonIcon extends StatelessWidget {
  RoundedButtonIcon({
    @required this.label,
    this.expanded = false,
    @required this.theme,
    @required this.icon,
    @required this.iconTheme,
    @required this.action,
  });

  final String label;
  final bool expanded;
  final Color theme;
  final IconData icon;
  final Color iconTheme;
  final Function action;

  @override
  Widget build(BuildContext context) {
    if (expanded) {
      return Container(
        width: double.infinity,
        child: RaisedButton.icon(
          padding: EdgeInsets.all(10),
          color: theme,
          icon: Icon(icon, color: iconTheme, size: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          onPressed: () => action(),
          label: Text(
            label.toUpperCase(),
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      );
    }

    return RaisedButton.icon(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      color: theme,
      icon: Icon(icon, color: iconTheme, size: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
      ),
      onPressed: action,
      label: Text(
        label.toUpperCase(),
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }
}
