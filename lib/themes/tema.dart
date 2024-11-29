import 'package:flutter/material.dart';

class Tema {

  static Color primary = Colors.lightBlue.shade900;
  static Color primaryLight = Colors.black12;

  static ThemeData light = ThemeData.light().copyWith(
    primaryColor: primary,
    primaryColorLight: primaryLight,
    colorScheme: ThemeData.light().colorScheme.copyWith(
      primary: primary
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: primaryLight,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none
      ),
      labelStyle: TextStyle(
        fontSize: 14,
        color: primary
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: TextButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)
        )
      )
    ),
    listTileTheme: ListTileThemeData(
      dense: true,
      contentPadding: const EdgeInsets.all(10),
      iconColor: primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10), 
      )
    ),
    iconTheme: IconThemeData(
      color: primary,
    ),
    dataTableTheme: DataTableThemeData(
      headingRowColor: WidgetStateProperty.all(primary),
      headingTextStyle: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      dataTextStyle: const TextStyle(
        fontSize: 11,
        color: Colors.black,
      ),
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
            borderRadius: BorderRadius.circular(10),
          );
        })
      ),
      confirmButtonStyle: ButtonStyle(
        foregroundColor: WidgetStateProperty.resolveWith((state) => Tema.primary),
        backgroundColor: WidgetStateProperty.resolveWith((state) => Tema.primaryLight),
        shape: WidgetStateProperty.resolveWith((state) {
          return RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
          );
        })
      ),
      todayBorder: BorderSide(
        color: Tema.primary,
        width: 2
      ),
      headerForegroundColor: Tema.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
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
    )
  );
}
