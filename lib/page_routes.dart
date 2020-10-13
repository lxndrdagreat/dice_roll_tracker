import 'package:dice_roll_tracker/home_page.dart';
import 'package:dice_roll_tracker/session_list_page.dart';
import 'package:flutter/material.dart';

Map<String, WidgetBuilder> appRoutes = {
  MyHomePage.ROUTE: (context) => MyHomePage(title: 'Dice Roll Tracker'),
  SessionListPage.ROUTE: (context) => SessionListPage()
};