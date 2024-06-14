import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class VariavelEstatica{

  static DateFormat mascaraDataHora = DateFormat('yyyy-MM-dd HH:mm');
  static DateFormat mascaraData = DateFormat('dd/MM/yyyy');
  // static double largura = 0.0;
  // static double altura = 0.0;
  static List listaImagens = [
    'assets/imagens/Biologico.png',
    'assets/imagens/Corrosivo.png',
    'assets/imagens/Eletrico.png',
    'assets/imagens/Fogo.png',
    'assets/imagens/Molhado.png',
    'assets/imagens/Queda.png',
    'assets/imagens/Quente.png',
    'assets/imagens/Radioativo.png',
    'assets/imagens/Seguranca.png',
  ];

  // static void inicializarDimensoes(BuildContext context) {
  //   largura = MediaQuery.of(context).size.width;
  //   altura = MediaQuery.of(context).size.height;
  // }
}