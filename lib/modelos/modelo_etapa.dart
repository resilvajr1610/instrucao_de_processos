import 'package:flutter/material.dart';

import 'modelo_analise.dart';

class ModeloEtapa{
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
  List <ModeloAnalise> listaAnalise;
  int adicionaNovo;

  ModeloEtapa({
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