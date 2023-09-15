import 'package:flutter/material.dart';

class BatteryIndicator extends StatelessWidget {
  BatteryIndicator(this.percentage);

  final int percentage;
  final Color full = Colors.green;
  final Color empty = Colors.black38;
  final Color low = Colors.red;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                height: 20, width: 50, color: percentage > 90 ? full : empty),
            Container(
              height: 20,
              width: 150,
              color: percentage > 80 ? full : empty,
            ),
            Container(
              height: 20,
              width: 150,
              color: percentage > 70 ? full : empty,
            ),
            Container(
              height: 20,
              width: 150,
              color: percentage > 60 ? full : empty,
            ),
            Container(
              height: 20,
              width: 150,
              color: percentage > 50 ? full : empty,
            ),
            Container(
              height: 20,
              width: 150,
              color: percentage > 40 ? full : empty,
            ),
            Container(
              height: 20,
              width: 150,
              color: percentage > 30 ? full : empty,
            ),
            Container(
              height: 20,
              width: 150,
              color: percentage > 20 ? full : empty,
            ),
            Container(
              height: 20,
              width: 150,
              color: percentage > 20
                  ? full
                  : percentage > 10
                      ? low
                      : empty,
            ),
            Container(
              height: 20,
              width: 150,
              color: percentage > 20
                  ? full
                  : percentage > 0
                      ? low
                      : empty,
            ),
          ],
        ),
        Text(
          '$percentage%',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        )
      ],
    );
  }
}
