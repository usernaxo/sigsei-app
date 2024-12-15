import 'package:flutter/material.dart';

class Tema {

  static Color primary = Colors.lightBlue.shade900;
  static Color primaryLight = Colors.grey.shade100;
  static Color secondaryLight = Colors.grey.shade300;

  static ThemeData light = ThemeData.light().copyWith(
    primaryColor: primary,
    primaryColorLight: primaryLight,
    scaffoldBackgroundColor: Colors.white,
    drawerTheme: const DrawerThemeData(
      backgroundColor: Colors.white
    ),
    cardTheme: CardTheme(
      color: primaryLight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(7),
      )
    ),
    canvasColor: Colors.white,
    expansionTileTheme: ExpansionTileThemeData(
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Tema.secondaryLight,
          width: 2
        ),
        borderRadius: BorderRadius.circular(7)
      ),
    ),
    textTheme: const TextTheme(
      bodySmall: TextStyle(fontSize: 12, color: Colors.black),
      bodyMedium: TextStyle(fontSize: 12, color: Colors.black),
      bodyLarge: TextStyle(fontSize: 12, color: Colors.black),
    ),
    colorScheme: ThemeData.light().colorScheme.copyWith(
      primary: primary,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: primaryLight,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(7),
        borderSide: BorderSide.none
      ),
      labelStyle: TextStyle(
        fontSize: 12,
        color: primary,
      ),
      hintStyle: const TextStyle(
        fontSize: 12,
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: TextButton.styleFrom(
        textStyle: const TextStyle(
          fontSize: 12
        ),
        backgroundColor: primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7)
        )
      )
    ),
    listTileTheme: ListTileThemeData(
      dense: true,
      contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      iconColor: primary,
      titleTextStyle: TextStyle(
        fontSize: 12,
        color: Colors.grey.shade800
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(7), 
      )
    ),
    iconTheme: IconThemeData(
      color: primary,
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: primary
    ),
    datePickerTheme: DatePickerThemeData(
      elevation: 0,
      cancelButtonStyle: ButtonStyle(
        foregroundColor: WidgetStateProperty.resolveWith((state) => Tema.primary),
        backgroundColor: WidgetStateProperty.resolveWith((state) => Tema.primaryLight),
        shape: WidgetStateProperty.resolveWith((state) {
          return RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(7),
          );
        })
      ),
      confirmButtonStyle: ButtonStyle(
        foregroundColor: WidgetStateProperty.resolveWith((state) => Tema.primary),
        backgroundColor: WidgetStateProperty.resolveWith((state) => Tema.primaryLight),
        shape: WidgetStateProperty.resolveWith((state) {
          return RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(7)
          );
        })
      ),
      todayBorder: BorderSide(
        color: Tema.primary,
        width: 2
      ),
      headerForegroundColor: Tema.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(7),
      ),
    ),
    sliderTheme: const SliderThemeData(
      trackHeight: 2,
      thumbShape: RoundSliderThumbShape(
        enabledThumbRadius: 5,
      ),
      overlayShape: RoundSliderOverlayShape(
        overlayRadius: 0,
      ),
    ),
  );
}
