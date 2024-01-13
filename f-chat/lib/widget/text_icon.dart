import 'package:flutter/material.dart';

class TextIcon extends StatelessWidget {
  TextIcon({@required this.text, @required this.label, @required this.icon});

  final String text;
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, color: Theme.of(context).primaryColor),
        SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(fontSize: 14, color: Theme.of(context).primaryColor)),
            SizedBox(height: 5),
            Text(text, style: TextStyle(fontSize: 16)),
          ],
        )
      ],
    );
  }
}
