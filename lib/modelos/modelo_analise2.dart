import 'package:flutter/cupertino.dart';

class ModeloAnalise2{
  bool etapaAtiva;
  String imagemSelecionada;
  int numeroAnalise;
  TextEditingController nomeAnalise;
  TextEditingController tempoAnalise;
  TextEditingController pontoChave;
  bool mostrarListaImagens;
  bool analiseAtiva;
  bool listaCompleta;

  ModeloAnalise2({
    required this.etapaAtiva,
    required this.imagemSelecionada,
    required this.numeroAnalise,
    required this.nomeAnalise,
    required this.tempoAnalise,
    required this.pontoChave,
    required this.mostrarListaImagens,
    required this.analiseAtiva,
    required this.listaCompleta,
  });
}