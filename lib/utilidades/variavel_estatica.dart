import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class VariavelEstatica{

  static DateFormat mascaraDataHora = DateFormat('yyyy-MM-dd hh:mm');
  static DateFormat mascaraData = DateFormat('dd/MM/yyyy');
  static double largura = 0.0;
  static double altura = 0.0;

  static void inicializarDimensoes(BuildContext context) {
    largura = MediaQuery.of(context).size.width;
    altura = MediaQuery.of(context).size.height;
  }
}