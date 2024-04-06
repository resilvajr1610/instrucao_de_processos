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
  double larguraMeio;
  bool escrever;
  bool mostrarListaMeio;
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
    required this.larguraMeio,
    required this.escrever,
    required this.mostrarListaMeio,
    required this.listaFinal,
    required this.alturaListaFinal,
  });
}