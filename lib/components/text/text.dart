import 'package:flutter/material.dart';
import 'package:paramedix/components/theme.dart';

TextStyle buttonTextStyle() => const TextStyle(
      fontSize: 15.0,
      fontFamily: "Poppins",
      color: Colors.white,
    );

TextStyle titleLightTextStyle(double fontSize, FontWeight fontWeight) => TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontFamily: "Poppins",
      color: ThemeLightMode.title,
    );

TextStyle titleDarkTextStyle(double fontSize, FontWeight fontWeight) => TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontFamily: "Poppins",
      color: ThemeDarkMode.title,
    );

TextStyle titleFontSizeLightTextStyle(double fontSize) => TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
      fontFamily: "Poppins",
      color: ThemeLightMode.title,
    );

TextStyle titleFontSizeDarkTextStyle(double fontSize) => TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
      fontFamily: "Poppins",
      color: ThemeDarkMode.title,
    );

TextStyle subtitleFontSizeTextStyle(double fontSize) => TextStyle(
      fontSize: fontSize,
      fontFamily: "Poppins",
      color: AppTheme.subtitle,
    );

TextStyle titleColorTextStyle(Color color) => TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
      fontFamily: "Poppins",
      color: color,
    );

TextStyle subtitleColorTextStyle(Color color) => TextStyle(
      fontSize: 15.0,
      fontFamily: "Poppins",
      color: color,
    );

TextStyle clickableTextStyle() => const TextStyle(
      fontSize: 15.0,
      fontFamily: "Poppins",
      color: AppTheme.primary,
      decoration: TextDecoration.underline,
      decorationColor: AppTheme.primary,
    );

TextStyle notFoundTextStyle() => const TextStyle(
      fontSize: 20.0,
      fontFamily: "Poppins",
      color: AppTheme.notFound,
    );

//Questionnaire Screen
TextStyle questionTitleTextStyle() => const TextStyle(
      fontSize: 17.0,
      fontWeight: FontWeight.bold,
      fontFamily: "Poppins",
    );

TextStyle questionSubtitleTextStyle() => const TextStyle(
      fontSize: 15.0,
      fontFamily: "Poppins",
    );

//Calendar
TextStyle calendarHeaderLightTextStyle() => const TextStyle(
      fontSize: 17.0,
      fontWeight: FontWeight.bold,
      color: ThemeLightMode.title,
    );

TextStyle calendarHeaderDarkTextStyle() => const TextStyle(
      fontSize: 17.0,
      fontWeight: FontWeight.bold,
      color: ThemeDarkMode.title,
    );

TextStyle calendarDaysOfWeekStyleLightTextStyle() => const TextStyle(
      fontWeight: FontWeight.w600,
      color: ThemeLightMode.title,
    );

TextStyle calendarDaysOfWeekStyleDarkTextStyle() => const TextStyle(
      fontWeight: FontWeight.w600,
      color: ThemeDarkMode.title,
    );

TextStyle calendarStyleLightTextStyle() => const TextStyle(
      fontWeight: FontWeight.w500,
      color: ThemeLightMode.title,
    );

TextStyle calendarStyleDarkTextStyle() => const TextStyle(
      fontWeight: FontWeight.w500,
      color: ThemeDarkMode.title,
    );
