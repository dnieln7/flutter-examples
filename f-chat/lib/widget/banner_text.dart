import 'package:flutter/material.dart';

class BannerText extends StatelessWidget {
  final String text;
  final double fontSize;

  BannerText({
    @required this.text,
    this.fontSize = 40,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: fontSize,
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
