import 'package:flutter/material.dart';
import 'modelo_instrucao_lista_1_1_1.dart';

class ModeloInstrucaoLista_1_1_0{
  String idFirebase;
  String idDocumento;
  TextEditingController controller;
  bool ativarBotaoAdicionarItemLista;
  double largura;
  bool escrever;
  List<ModeloInstrucaoLista_1_1_1> listaFinal;
  double alturaListaFinal;

  ModeloInstrucaoLista_1_1_0({
    required this.idFirebase,
    required this.idDocumento,
    required this.controller,
    required this.ativarBotaoAdicionarItemLista,
    required this.largura,
    required this.escrever,
    required this.listaFinal,
    required this.alturaListaFinal,
  });
}