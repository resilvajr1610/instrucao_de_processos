import 'package:flutter/cupertino.dart';

class ModeloInstrucaoItem{
  TextEditingController controller;
  bool caixaTextoNaoVazia;
  double largura;
  bool escrever;
  List listaMeio;

  ModeloInstrucaoItem({
    required this.controller,
    required this.caixaTextoNaoVazia,
    required this.largura,
    required this.escrever,
    required this.listaMeio,
  });
}