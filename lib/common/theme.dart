import 'package:flutter/material.dart';

ThemeData appTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
  primaryColor: Colors.lightBlue,
  scaffoldBackgroundColor: Colors.white,
  floatingActionButtonTheme: floatingActionButtonThemeData,
  textTheme: textTheme,
  dialogTheme: dialogTheme,
  popupMenuTheme: popupMenuTheme,
  appBarTheme: appBarTheme,
  textButtonTheme: textButtonTheme,
  elevatedButtonTheme: elevatedButtonTheme,
  inputDecorationTheme: inputDecorationTheme,
  scrollbarTheme: scrollbarTheme,
  iconButtonTheme: iconButtonTheme,
  sliderTheme: sliderTheme,
);

//--------------------------------------------------------------------------

const floatingActionButtonThemeData = FloatingActionButtonThemeData(
  backgroundColor: Colors.lightBlue,
  foregroundColor: Colors.white,
  enableFeedback: false,
);

final textTheme = TextTheme(
  bodyMedium: TextStyle(
    fontSize: 14,
    color: Colors.grey.shade600,
  ),
);

final dialogTheme = DialogTheme(
  insetPadding: const EdgeInsets.symmetric(horizontal: 30),
  titleTextStyle: TextStyle(
    color: Colors.grey.shade900,
    fontSize: 22,
    fontWeight: FontWeight.w400,
  ),
  backgroundColor: Colors.white,
);

final popupMenuTheme = PopupMenuThemeData(
  color: Colors.lightBlue.shade50,
  iconColor: Colors.grey.shade800,
);

final appBarTheme = AppBarTheme(
  backgroundColor: Colors.white,
  centerTitle: true,
  foregroundColor: Colors.grey.shade800,
  titleTextStyle: TextStyle(
      fontSize: 19, color: Colors.grey.shade800, fontWeight: FontWeight.w400),
  surfaceTintColor: Colors.transparent,
);

final textButtonTheme = TextButtonThemeData(
  style: TextButton.styleFrom(
      foregroundColor: Colors.lightBlue,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
);

final elevatedButtonTheme = ElevatedButtonThemeData(
  style: ElevatedButton.styleFrom(
      backgroundColor: Colors.lightBlue,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
);

final inputDecorationTheme = InputDecorationTheme(
  fillColor: Colors.grey.shade100,
  filled: true,
  border: OutlineInputBorder(
    borderSide: BorderSide.none,
    borderRadius: BorderRadius.circular(10.0), // Rounded corners
  ),
);

final scrollbarTheme = ScrollbarThemeData(
  thumbColor: WidgetStatePropertyAll<Color>(Colors.grey.shade400),
);

final iconButtonTheme = IconButtonThemeData(
  style: IconButton.styleFrom(foregroundColor: Colors.black),
);

final sliderTheme = SliderThemeData(
  trackHeight: 1.4,
  overlayShape: SliderComponentShape.noOverlay,
  thumbShape: const RoundSliderThumbShape(
    enabledThumbRadius: 10.0,
    pressedElevation: 0,
    elevation: 0,
  ),
  activeTrackColor: Colors.black,
  inactiveTrackColor: Colors.grey.shade300,
  thumbColor: Colors.black,
);
