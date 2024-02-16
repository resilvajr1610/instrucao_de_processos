import 'package:flutter/material.dart';

class VariavelEstatica{
  static double width = 0.0;
  static double height = 0.0;

  static void initialize(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
  }
}