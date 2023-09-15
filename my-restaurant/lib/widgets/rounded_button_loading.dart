import 'package:flutter/material.dart';

class RoundedButtonLoading extends StatelessWidget {
  RoundedButtonLoading({
    @required this.label,
    @required this.theme,
    @required this.textTheme,
  });

  final String label;
  final Color theme;
  final Color textTheme;

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      padding: EdgeInsets.all(10),
      color: Theme.of(context).primaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
      ),
      onPressed: () => {},
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label.toUpperCase(),
            style: TextStyle(color: textTheme),
          ),
          SizedBox(width: 20),
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              backgroundColor: textTheme,
              strokeWidth: 2,
            ),
          ),
        ],
      ),
    );
  }
}
