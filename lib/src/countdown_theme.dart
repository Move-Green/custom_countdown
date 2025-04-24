// lib/src/countdown_theme.dart
import 'package:flutter/material.dart';

class CountdownTheme {
  final Color progressColor;
  final Color backgroundColor;
  final double strokeWidth;
  final TextStyle textStyle;
  final TextStyle labelStyle;
  final double width;
  final double height;

  const CountdownTheme({
    this.progressColor = Colors.green,
    this.backgroundColor = Colors.grey,
    this.strokeWidth = 15.0,
    this.textStyle = const TextStyle(
      fontSize: 50,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    this.labelStyle = const TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    this.width = 200,
    this.height = 200,
  });
}