import 'package:flutter/material.dart';
import 'modelo_instrucao_lista_1_1_1.dart';

class ModeloInstrucaoLista_1_1_0{
  TextEditingController controller;
  bool ativarBotaoAdicionarItemLista;
  double largura;
  bool escrever;
  List<ModeloInstrucaoLista_1_1_1> listaFinal;

  ModeloInstrucaoLista_1_1_0({
    required this.controller,
    required this.ativarBotaoAdicionarItemLista,
    required this.largura,
    required this.escrever,
    required this.listaFinal,
  });
}