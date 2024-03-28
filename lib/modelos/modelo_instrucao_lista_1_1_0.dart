import 'package:flutter/material.dart';
import 'modelo_instrucao_lista_1_1_1.dart';

class ModeloInstrucaoLista_1_1_0{
  String idFire;
  String idDoc;
  List listaIdEsp;
  String nomeProcesso;
  List listaVersao;
  TextEditingController controller;
  bool ativarBotaoAdicionarItemLista;
  double largura;
  bool escrever;
  bool mostrarLista;
  List<ModeloInstrucaoLista_1_1_1> listaFinal;
  double alturaListaFinal;

  ModeloInstrucaoLista_1_1_0({
    required this.idFire,
    required this.idDoc,
    required this.listaIdEsp,
    required this.nomeProcesso,
    required this.listaVersao,
    required this.controller,
    required this.ativarBotaoAdicionarItemLista,
    required this.largura,
    required this.escrever,
    required this.mostrarLista,
    required this.listaFinal,
    required this.alturaListaFinal,
  });
}