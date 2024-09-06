import 'package:flutter/material.dart';
import 'package:jsps_depo/themes/custom_color_scheme.dart';

TextSpan highlightText(
  String text,
  String query,
  int pageIndex,
  bool isDarkTheme,
  double fontSize,
) {
  final Color textColor = isDarkTheme
      ? CustomColorScheme.darkColorScheme.onBackground
      : CustomColorScheme.lightColorScheme.onBackground;
  final Color highlightColor = isDarkTheme ? Colors.orange : Colors.blue;
  const Color highlightedTextColor = Colors.white;

  if (query.isEmpty) {
    return TextSpan(
      text: text,
      style: TextStyle(
        color: textColor,
        fontSize: fontSize,
      ),
    );
  }
  final lowerCaseText = text.toLowerCase();
  final lowerCaseQuery = query.toLowerCase();
  final matches = <TextSpan>[];
  int startIndex = 0;
  int matchIndex = 0;

  while (startIndex < lowerCaseText.length) {
    final index = lowerCaseText.indexOf(lowerCaseQuery, startIndex);
    if (index == -1) {
      matches.add(
        TextSpan(
          text: text.substring(startIndex),
          style: TextStyle(
            color: textColor,
            fontSize: fontSize,
          ),
        ),
      );
      break;
    }
    matches.add(
      TextSpan(
        text: text.substring(startIndex, index),
        style: TextStyle(
          color: textColor,
          fontSize: fontSize,
        ),
      ),
    );
    matches.add(
      TextSpan(
        text: text.substring(index, index + query.length),
        style: TextStyle(
          backgroundColor: highlightColor,
          color: highlightedTextColor,
          fontWeight: FontWeight.bold,
          fontSize: fontSize,
        ),
      ),
    );
    startIndex = index + query.length;
    matchIndex++;
  }

  return TextSpan(children: matches);
}
