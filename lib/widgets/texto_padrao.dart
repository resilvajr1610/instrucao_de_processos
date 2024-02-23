import 'package:flutter/material.dart';
import 'package:instrucao_de_processos/utilidades/cores.dart';

class TextoPadrao extends StatelessWidget {

  final String texto;
  final double tamanhoFonte;
  final Color cor;
  final FontWeight negrito;
  final TextAlign alinhamentoTexto;
  final int maxLines;

  TextoPadrao({
    required this.texto,
    this.tamanhoFonte = 14.0,
    this.cor = Cores.cinzaClaro,
    this.negrito = FontWeight.normal,
    this.alinhamentoTexto = TextAlign.start,
    this.maxLines = 1
});

  @override
  Widget build(BuildContext context) {
    return Text(
      texto,
      textAlign: alinhamentoTexto,
      maxLines: maxLines,
      style: TextStyle(
        fontSize: tamanhoFonte,
        fontWeight: negrito,
        color: cor,
        overflow: TextOverflow.ellipsis,
        fontFamily: "Nunito"
      ),
    );
  }
}
