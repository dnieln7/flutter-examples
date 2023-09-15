import 'dart:math';

import 'package:flutter/material.dart';

class BannerLeaned extends StatelessWidget {
  final String text;
  final String font;
  final double fontSize;

  BannerLeaned({
    @required this.text,
    @required this.font,
    this.fontSize = 40,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: EdgeInsets.all(10),
      transform: Matrix4.rotationZ(-5 * pi / 180)..translate(-5.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Theme.of(context).primaryColor,
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            color: Colors.black54,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Theme.of(context).primaryTextTheme.headline6.color,
          fontSize: fontSize,
          fontFamily: font,
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }
}
