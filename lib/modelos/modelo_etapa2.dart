import 'package:flutter/material.dart';

import 'modelo_analise2.dart';

class ModeloEtapa2{
  String idEsp;
  String nomeProcesso;
  int numeroFIP;
  int numeroEtapa;
  TextEditingController nomeEtapa;
  double tempoTotalEtapaSegundos;
  String tempoTotalEtapaMinutos;
  bool ativarCaixaEtapa;
  bool etapaAtiva;
  bool adicionarChaveRazao;
  bool aumentarAlturaContainer;
  List <ModeloAnalise2> listaAnalise;
  int adicionaNovo;

  ModeloEtapa2({
    required this.idEsp,
    required this.nomeProcesso,
    required this.numeroFIP,
    required this.numeroEtapa,
    required this.nomeEtapa,
    required this.tempoTotalEtapaSegundos,
    required this.tempoTotalEtapaMinutos,
    required this.ativarCaixaEtapa,
    required this.etapaAtiva,
    required this.adicionarChaveRazao,
    required this.listaAnalise,
    required this.aumentarAlturaContainer,
    required this.adicionaNovo
  });
}