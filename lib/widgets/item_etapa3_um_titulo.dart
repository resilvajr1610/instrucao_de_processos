import 'package:flutter/material.dart';
import 'package:instrucao_de_processos/widgets/texto_padrao.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../modelos/bad_state_list.dart';
import '../utilidades/cores.dart';

class ItemEtapaUmTitulo extends StatelessWidget {
  DocumentSnapshot? dadosEspecificacao;
  String titulo;
  String item;
  bool pc;

  ItemEtapaUmTitulo({
    required this.dadosEspecificacao,
    required this.titulo,
    required this.item,
    required this.pc
  });

  @override
  Widget build(BuildContext context) {

    double largura = MediaQuery.of(context).size.width;
    double altura = MediaQuery.of(context).size.height;

    return pc?Row(
      children: [
        TextoPadrao(texto: titulo,cor: Cores.primaria,tamanhoFonte: 14,),
        SizedBox(width: 10,),
        TextoPadrao(
          texto: BadStateList(dadosEspecificacao, item).toString().replaceAll('[', '').replaceAll(']', ''),
          cor: Cores.cinzaTextoEscuro,
          tamanhoFonte: 12,
          maxLines: 2,),
      ],
    ):Row(
      children: [
        TextoPadrao(texto: titulo,cor: Cores.primaria,tamanhoFonte: 14,),
        SizedBox(width: 10,),
        Container(
          width: largura*0.5,
          child: TextoPadrao(
            texto: BadStateList(dadosEspecificacao, item).toString().replaceAll('[', '').replaceAll(']', ''),
            cor: Cores.cinzaTextoEscuro,
            tamanhoFonte: 10,
            maxLines: 3,),
        ),
      ],
    );
  }
}
