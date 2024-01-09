import 'package:flutter/material.dart';
import 'package:trudd_track_your_buddy/core/utils/colors.dart';

final themeData = ThemeData(
  brightness: Brightness.dark,
  fontFamily: 'SpaceGrotesk',
  scaffoldBackgroundColor: Colors.black,
  elevatedButtonTheme: elevatedButtonTheme,
  outlinedButtonTheme: outlineButtonTheme,
  inputDecorationTheme: inputDecorationTheme,
  primarySwatch: primarySwatch,
  appBarTheme: appBarTheme,
);
final primarySwatch = MaterialColor(
  AppColor.primaryColor.value,
  const <int, Color>{
    50: AppColor.primaryColor,
    100: AppColor.primaryColor,
    200: AppColor.primaryColor,
    300: AppColor.primaryColor,
    400: AppColor.primaryColor,
    500: AppColor.primaryColor,
    600: AppColor.primaryColor,
    700: AppColor.primaryColor,
    800: AppColor.primaryColor,
    900: AppColor.primaryColor,
  },
);
final elevatedButtonTheme = ElevatedButtonThemeData(
  style: ButtonStyle(
    backgroundColor: MaterialStateProperty.all(AppColor.primaryColor),
    shape: MaterialStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
    fixedSize: MaterialStateProperty.all(const Size(double.maxFinite, 58)),
    foregroundColor: MaterialStateProperty.all(AppColor.secondaryColor),
    textStyle: MaterialStateProperty.all(
        const TextStyle(fontSize: 16, fontFamily: 'SpaceGrotesk')),
  ),
);

final outlineButtonTheme = OutlinedButtonThemeData(
  style: ButtonStyle(
    backgroundColor: MaterialStateProperty.all(Colors.transparent),
    shape: MaterialStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
    fixedSize: MaterialStateProperty.all(const Size(double.maxFinite, 58)),
    side: MaterialStateProperty.all(
        const BorderSide(width: 1, color: AppColor.primaryColor)),
    foregroundColor: MaterialStateProperty.all(Colors.white),
    textStyle: MaterialStateProperty.all(
        const TextStyle(fontSize: 16, fontFamily: 'SpaceGrotesk')),
  ),
);

const inputDecorationTheme = InputDecorationTheme(
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(
      width: 1,
      color: AppColor.primaryColor,
    ),
  ),
  errorBorder: OutlineInputBorder(
    borderSide: BorderSide(
      width: 1,
      color: Colors.red,
    ),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(
      width: 1,
      color: AppColor.primaryColor,
    ),
  ),
  focusedErrorBorder: OutlineInputBorder(
    borderSide: BorderSide(
      width: 1,
      color: Colors.red,
    ),
  ),
);

const appBarTheme = AppBarTheme(
  backgroundColor: AppColor.primaryColor,
  centerTitle: true,
  elevation: 0,
  titleTextStyle: TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    fontFamily: 'SpaceGrotesk',
    color: AppColor.secondaryColor,
  ),
);
