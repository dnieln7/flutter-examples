import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_kotlin/battery_indicator.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter - Kotlin',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int batteryLevel;

  @override
  void initState() {
    getBatteryLevel();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Battery Level'),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.refresh),
        onPressed: getBatteryLevel,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Container(
        alignment: Alignment.center,
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Text(
                'Displaying current battery level through a function in kotlin',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 100),
              BatteryIndicator(batteryLevel),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> getBatteryLevel() async {
    const platform = MethodChannel('com.dnieln7.native-functions/battery');

    try {
      final level = await platform.invokeMethod('getBatteryLevelK');

      setState(() => batteryLevel = level);
    } catch (error) {
      setState(() => batteryLevel = null);
    }
  }
}
