import 'package:flutter/material.dart';
import 'package:instrucao_de_processos/widgets/texto_padrao.dart';
import '../utilidades/cores.dart';
import '../utilidades/variavel_estatica.dart';

class BotaoPadraoNovaInstrucao extends StatelessWidget {
  String texto;
  var onPressed;
  double margemVertical;
  Color corBotao;
  double largura;

  BotaoPadraoNovaInstrucao({
    required this.texto,
    required this.onPressed,
    this.margemVertical = 45,
    this.corBotao = Cores.primaria,
    this.largura = 80
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          backgroundColor: corBotao,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
        child: Container(width: largura,child: TextoPadrao(texto: texto,alinhamentoTexto: TextAlign.center,negrito: FontWeight.bold,tamanhoFonte: 12))
    );
  }
}
