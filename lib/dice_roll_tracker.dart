import 'package:dice_roll_tracker/page_routes.dart';
import 'package:flutter/material.dart';

class DiceRollTracker extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dice Roll Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: appRoutes,
      initialRoute: '/',
    );
  }
}
