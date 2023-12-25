import 'package:flutter/material.dart';

class AppColors {
  static final Color cortexPrimaryBg = Colors.black.withOpacity(0.9);
  static const Color cortexSecondaryBg = Color(0xFF2A363B);
  static final Color? cortexFg = Colors.blueGrey[600];

}

enum RegressionType {
  currencyClassification,
  ocr,
}