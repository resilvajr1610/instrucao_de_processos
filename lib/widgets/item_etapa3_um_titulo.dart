import 'package:flutter/material.dart';
import 'package:instrucao_de_processos/widgets/texto_padrao.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../modelos/bad_state_list.dart';
import '../utilidades/cores.dart';

class ItemEtapaUmTitulo extends StatelessWidget {
  DocumentSnapshot? dadosEspecificacao;
  String titulo;
  String item;

  ItemEtapaUmTitulo({
    required this.dadosEspecificacao,
    required this.titulo,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TextoPadrao(texto: titulo,cor: Cores.primaria,tamanhoFonte: 14,),
        SizedBox(width: 10,),
        TextoPadrao(
          texto: BadStateList(dadosEspecificacao, item).toString().replaceAll('[', '').replaceAll(']', ''),
          cor: Cores.cinzaTextoEscuro,
          tamanhoFonte: 12,
          maxLines: 2,),
      ],
    );
  }
}
