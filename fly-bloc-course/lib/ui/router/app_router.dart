import 'package:flutter/material.dart';
import 'package:fly_bloc_course/ui/screen/counter_negative_screen.dart';
import 'package:fly_bloc_course/ui/screen/counter_positive_screen.dart';
import 'package:fly_bloc_course/ui/screen/counter_screen.dart';

class AppRouter {
  Route<Object?>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case CounterScreen.path:
        return MaterialPageRoute(
          builder: (context) => const CounterScreen(),
        );
      case CounterPositiveScreen.path:
        return MaterialPageRoute(
          builder: (context) => const CounterPositiveScreen(),
        );
      case CounterNegativeScreen.path:
        return MaterialPageRoute(
          builder: (context) => const CounterNegativeScreen(),
        );
      default:
        return null;
    }
  }
}
