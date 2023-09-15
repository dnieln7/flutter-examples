import 'package:flutter/material.dart';

class AvatarChip extends StatelessWidget {
  final String label;
  final Widget avatar;
  final Color theme;
  final Color textTheme;

  AvatarChip({this.label, this.avatar, this.theme, this.textTheme});

  @override
  Widget build(BuildContext context) {
    return Chip(
      backgroundColor: theme,
      avatar: CircleAvatar(
        backgroundColor: Colors.transparent,
        foregroundColor: textTheme,
        child: avatar,
      ),
      label: Text(
        label,
        style: TextStyle(
          color: textTheme,
          fontSize: 14,
        ),
      ),
    );
  }
}
