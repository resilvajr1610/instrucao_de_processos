import 'package:flutter/material.dart';
import 'package:instrucao_de_processos/widgets/texto_padrao.dart';
import '../utilidades/cores.dart';

class NivelEtapa extends StatelessWidget {
  int nivel;
  bool pc;

  NivelEtapa({
    required this.nivel,
    required this.pc
  });

  @override
  Widget build(BuildContext context) {

    double largura = MediaQuery.of(context).size.width;
    double altura = MediaQuery.of(context).size.height;
    
    return  Container(
      color: Colors.white,
      width: largura,
      height: pc?28:70,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
              backgroundColor: Cores.primaria,
              radius: pc?30:23,
              child: CircleAvatar(child: TextoPadrao(texto: '1',tamanhoFonte: pc?32:25,negrito: FontWeight.bold,cor: nivel==1?Colors.white:Cores.primaria),radius:pc?28:20,backgroundColor: nivel==1?Cores.primaria:Colors.white)),
          SizedBox(width: 10,),
          pc?TextoPadrao(texto: 'Primeira\nEtapa',tamanhoFonte: 16,negrito: FontWeight.bold,cor: Cores.primaria,maxLines: 2,alinhamentoTexto: TextAlign.center,):Container(),
          SizedBox(width: pc?100:10,),
          CircleAvatar(
              backgroundColor: Cores.primaria,
              radius: pc?30:23,
              child: CircleAvatar(child: TextoPadrao(texto: '2',tamanhoFonte: pc?30:25,negrito: FontWeight.bold,cor: nivel==2?Colors.white:Cores.primaria),radius: pc?28:20,backgroundColor: nivel==2?Cores.primaria:Colors.white)),
          SizedBox(width: 10,),
          pc?TextoPadrao(texto: 'Segunda\nEtapa',tamanhoFonte: 16,negrito: FontWeight.bold,cor: Cores.primaria,maxLines: 2,alinhamentoTexto: TextAlign.center,):Container(),
          SizedBox(width: pc?100:10,),
          CircleAvatar(
              backgroundColor: Cores.primaria,
              radius: pc?30:23,
              child: CircleAvatar(child: TextoPadrao(texto: '3',tamanhoFonte: pc?30:25,negrito: FontWeight.bold,cor: nivel==3?Colors.white:Cores.primaria),radius: pc?28:20,backgroundColor: nivel==3?Cores.primaria:Colors.white)),
          SizedBox(width: 10,),
          pc?TextoPadrao(texto: 'Terceira\nEtapa',tamanhoFonte: 16,negrito: FontWeight.bold,cor: Cores.primaria,maxLines: 2,alinhamentoTexto: TextAlign.center,):Container()
        ],
      ),
    );
  }
}
