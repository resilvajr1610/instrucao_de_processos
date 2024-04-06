import 'package:flutter/material.dart';
import 'package:instrucao_de_processos/modelos/modelo_instrucao_lista_1_1_0.dart';

class ModeloInstrucaoLista_1_0_0{
  String idFire;
  String idDoc;
  List listaIdEsp;
  String nomeProcesso;
  List listaVersao;
  TextEditingController controller;
  bool ativarBotaoAdicionarItemLista;
  double larguraInicio;
  bool escrever;
  bool mostrarListaInicio;
  List<ModeloInstrucaoLista_1_1_0> listaMeio;
  double alturaListaMeio;

  ModeloInstrucaoLista_1_0_0({
    required this.idFire,
    required this.idDoc,
    required this.listaIdEsp,
    required this.nomeProcesso,
    required this.listaVersao,
    required this.controller,
    required this.ativarBotaoAdicionarItemLista,
    required this.larguraInicio,
    required this.escrever,
    required this.mostrarListaInicio,
    required this.listaMeio,
    required this.alturaListaMeio,
  });
}