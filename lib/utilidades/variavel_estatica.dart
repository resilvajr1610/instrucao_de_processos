import 'package:flutter/material.dart';

class VariavelEstatica{
  static double largura = 0.0;
  static double altura = 0.0;

  static void inicializarDimensoes(BuildContext context) {
    largura = MediaQuery.of(context).size.width;
    altura = MediaQuery.of(context).size.height;
  }
}