import 'package:flutter/material.dart';
import 'package:instrucao_de_processos/modelos/modelo_instrucao_lista_1_1_0.dart';

class ModeloInstrucaoLista_1_0_0{
  String idFire;
  String idDoc;
  TextEditingController controller;
  bool ativarBotaoAdicionarItemLista;
  double largura;
  bool escrever;
  List<ModeloInstrucaoLista_1_1_0> listaMeio;
  double alturaListaMeio;

  ModeloInstrucaoLista_1_0_0({
    required this.idFire,
    required this.idDoc,
    required this.controller,
    required this.ativarBotaoAdicionarItemLista,
    required this.largura,
    required this.escrever,
    required this.listaMeio,
    required this.alturaListaMeio,
  });
}