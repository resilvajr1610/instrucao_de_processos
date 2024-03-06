import 'package:flutter/material.dart';
import 'package:instrucao_de_processos/widgets/texto_padrao.dart';
import '../utilidades/cores.dart';
import '../utilidades/variavel_estatica.dart';

class NivelEtapa extends StatelessWidget {
  int nivel;

  NivelEtapa({required this.nivel});

  @override
  Widget build(BuildContext context) {
    return  Container(
      color: Colors.white,
      width: VariavelEstatica.largura,
      height: 85,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
              backgroundColor: Cores.primaria,
              radius: 30,
              child: CircleAvatar(child: TextoPadrao(texto: '1',tamanhoFonte: 32,negrito: FontWeight.bold,cor: nivel==1?Colors.white:Cores.primaria),radius: 28,backgroundColor: nivel==1?Cores.primaria:Colors.white)),
          SizedBox(width: 10,),
          TextoPadrao(texto: 'Primeira\nEtapa',tamanhoFonte: 16,negrito: FontWeight.bold,cor: Cores.primaria,maxLines: 2,alinhamentoTexto: TextAlign.center,),
          SizedBox(width: 100,),
          CircleAvatar(
              backgroundColor: Cores.primaria,
              radius: 30,
              child: CircleAvatar(child: TextoPadrao(texto: '2',tamanhoFonte: 30,negrito: FontWeight.bold,cor: nivel==2?Colors.white:Cores.primaria),radius: 28,backgroundColor: nivel==2?Cores.primaria:Colors.white)),
          SizedBox(width: 10,),
          TextoPadrao(texto: 'Segunda\nEtapa',tamanhoFonte: 16,negrito: FontWeight.bold,cor: Cores.primaria,maxLines: 2,alinhamentoTexto: TextAlign.center,),
          SizedBox(width: 100,),
          CircleAvatar(
              backgroundColor: Cores.primaria,
              radius: 30,
              child: CircleAvatar(child: TextoPadrao(texto: '3',tamanhoFonte: 30,negrito: FontWeight.bold,cor: nivel==3?Colors.white:Cores.primaria),radius: 28,backgroundColor: nivel==3?Cores.primaria:Colors.white)),
          SizedBox(width: 10,),
          TextoPadrao(texto: 'Terceira\nEtapa',tamanhoFonte: 16,negrito: FontWeight.bold,cor: Cores.primaria,maxLines: 2,alinhamentoTexto: TextAlign.center,)
        ],
      ),
    );
  }
}
