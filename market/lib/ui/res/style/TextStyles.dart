import 'package:flutter/material.dart';

class TextStyles {
  static const FONT_ANTON = TextStyle(fontFamily: 'Anton');

  static const APP_BAR = TextStyle(
    color: Colors.white,
    fontSize: 20,
    fontWeight: FontWeight.normal,
  );

  static const APP_BAR_DARK = TextStyle(
    color: Colors.black,
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );

  static const TITLE_DARK = TextStyle(
    color: Colors.black,
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );

  static const SUBTITLE_DARK = TextStyle(
    color: Colors.black,
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

  static const BODY_DARK = TextStyle(
    color: Colors.black,
    fontSize: 16,
    fontWeight: FontWeight.normal,
  );

  static TextStyle subTitleCustom(color) {
    return TextStyle(
      color: color,
      fontSize: 18,
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle bodyCustom(color) {
    return TextStyle(
      color: color,
      fontSize: 16,
      fontWeight: FontWeight.normal,
    );
  }
}
