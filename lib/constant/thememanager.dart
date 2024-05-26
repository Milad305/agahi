import 'package:flutter/material.dart';
import 'package:agahi_app/widget/customScaffold.dart';
import 'colors.dart';

var txtstylelight = TextStyle(fontFamily: 'iransans', color: CbgDark);
var txtthemelight = TextTheme(
    bodyMedium: txtstylelight,
    bodyLarge: txtstylelight,
    bodySmall: txtstylelight,
    displayLarge: txtstylelight,
    displayMedium: txtstylelight,
    displaySmall: txtstylelight,
    labelLarge: txtstylelight,
    labelMedium: txtstylelight,
    labelSmall: txtstylelight,
    titleLarge: txtstylelight,
    titleMedium: txtstylelight,
    titleSmall: txtstylelight);

var txtstyledark = TextStyle(fontFamily: 'iransans', color: Cwhite);
var txtthemedark = TextTheme(
    bodyMedium: txtstyledark,
    bodyLarge: txtstyledark,
    bodySmall: txtstyledark,
    displayLarge: txtstyledark,
    displayMedium: txtstylelight,
    displaySmall: txtstylelight,
    labelLarge: txtstylelight,
    labelMedium: txtstylelight,
    labelSmall: txtstylelight,
    titleLarge: txtstyledark,
    titleMedium: txtstyledark,
    titleSmall: txtstyledark);

ThemeData lightTheme = ThemeData.light().copyWith(
  tabBarTheme: TabBarTheme(
      labelStyle: txtstylelight, unselectedLabelStyle: txtstylelight),
  hintColor: ChintLight,
  primaryColorLight: Cwhite,
  cardColor: Colors.black,
  highlightColor: ChhlightLight,
  dialogBackgroundColor: Clight,
  // iconTheme: IconThemeData(color: CbgDark, fill: 0.2),
  // iconButtonTheme: IconButtonThemeData(
  //     style: IconButton.styleFrom(
  //         backgroundColor: CbgDark)),
  // bottomNavigationBarTheme:
  //     const BottomNavigationBarThemeData(selectedItemColor: Colors.black),
  bottomAppBarTheme: BottomAppBarTheme(
    color: CbgLight,
  ),
  scaffoldBackgroundColor: CbgLight,
  textTheme: txtthemelight,
  // elevatedButtonTheme: ElevatedButtonThemeData(
  //     style: ElevatedButton.styleFrom(backgroundColor: Cprimary)),
  // textButtonTheme: TextButtonThemeData(
  //     style: TextButton.styleFrom(
  //         foregroundColor: Cprimary, backgroundColor: Colors.amber)),
  // primaryColor: Colors.purple);
);

ThemeData darkTheme = ThemeData.dark().copyWith(
  tabBarTheme:
      TabBarTheme(labelStyle: txtstyledark, unselectedLabelStyle: txtstyledark),
  hintColor: ChintDark,
  cardColor: Colors.white,
  highlightColor: ChhlightDark,
  primaryColorLight: CbgDark1,
  dialogBackgroundColor: CbgDark1,
  // iconTheme: IconThemeData(color: Clight),
  // iconButtonTheme: IconButtonThemeData(
  //     style: IconButton.styleFrom(
  //         backgroundColor: Clight)),
  // bottomNavigationBarTheme:
  //      BottomNavigationBarThemeData(selectedItemColor: Cprimary),
  bottomAppBarTheme: BottomAppBarTheme(color: CbgDark1),
  scaffoldBackgroundColor: CbgDark,
  textTheme: txtthemedark,
  // elevatedButtonTheme: ElevatedButtonThemeData(
  //     style: ElevatedButton.styleFrom(backgroundColor: Colors.amber)),
  // textButtonTheme: TextButtonThemeData(
  //     style: TextButton.styleFrom(
  //         foregroundColor: const Color.fromARGB(255, 208, 208, 208),
  //         backgroundColor: Colors.black)),
  // primaryColor: Colors.purple
);
