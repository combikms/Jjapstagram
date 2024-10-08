import 'package:flutter/material.dart';

var theme = ThemeData(
  appBarTheme: AppBarTheme(
    color: Colors.white,
    elevation: 1,
    titleTextStyle: TextStyle(color: Colors.black, fontSize: 25),
    actionsIconTheme: IconThemeData(color: Colors.black),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    selectedItemColor: Colors.black,
  )
);