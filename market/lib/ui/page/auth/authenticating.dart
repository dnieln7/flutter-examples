import 'package:flutter/material.dart';

class Authenticating extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).accentColor.withOpacity(0.7),
              Theme.of(context).primaryColor.withOpacity(0.7)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            LinearProgressIndicator(),
            SizedBox(height: 10),
            Text('loading...')
          ],
        ),
      ),
    );
  }
}
