import 'package:app_default/views/home_screen.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  AppRoutes._();
  static const String home = '/a/home';
}

final Map<String, WidgetBuilder> appRoutes = {
  AppRoutes.home: (context) => const HomeScreen(),
};
