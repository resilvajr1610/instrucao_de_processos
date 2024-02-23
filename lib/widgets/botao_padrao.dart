import 'package:flutter/material.dart';
import 'package:instrucao_de_processos/widgets/texto_padrao.dart';
import '../utilidades/cores.dart';
import '../utilidades/variavel_estatica.dart';

class BotaoPadrao extends StatelessWidget {
  String texto;
  var onTap;
  double largura;
  double margemVertical;

  BotaoPadrao({
    required this.texto,
    required this.onTap,
    this.largura = 280,
    this.margemVertical = 45
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: largura,
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.symmetric(vertical: margemVertical),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          gradient: LinearGradient(
            begin: Alignment.centerRight,
            end: Alignment.centerLeft,
            colors: Cores.degrade_azul, // Define your gradient colors here
          ),
        ),
        child: TextoPadrao(texto: texto,alinhamentoTexto: TextAlign.center,),
      ),
    );
  }
}
