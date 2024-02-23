import 'package:flutter/material.dart';
import 'package:instrucao_de_processos/utilidades/cores.dart';
import 'package:instrucao_de_processos/widgets/texto_padrao.dart';

class TituloPadrao extends StatelessWidget {
  String title;

  TituloPadrao({
    required this.title,
});

  @override
  Widget build(BuildContext context) {
    return TextoPadrao(
      texto: title,
      cor: Cores.primaria,
      tamanhoFonte: 14,
      alinhamentoTexto: TextAlign.start,
    );
  }
}
