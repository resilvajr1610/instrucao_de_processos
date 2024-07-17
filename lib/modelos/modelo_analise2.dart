import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

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
  List listaFotos;
  List listaFotosUrl;
  List listaVideos;
  List listaVideosUrl;

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
    required this.listaFotos,
    required this.listaFotosUrl,
    required this.listaVideos,
    required this.listaVideosUrl,
  });
}