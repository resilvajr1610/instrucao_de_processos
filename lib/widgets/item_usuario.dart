import 'package:flutter/material.dart';
import 'package:instrucao_de_processos/utilidades/variavel_estatica.dart';
import 'package:instrucao_de_processos/widgets/texto_padrao.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../utilidades/cores.dart';

class ItemUsuario extends StatelessWidget {
  DocumentSnapshot document;

  ItemUsuario({
    required this.document,
  });

  @override
  Widget build(BuildContext context) {

    double largura = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        children: [
          Container(width: largura>700?300:largura*0.5,child: TextoPadrao(texto: document['nome'],cor: Cores.cinzaTextoEscuro,tamanhoFonte: 12,)),
          largura>700?Container(width: 200,child: TextoPadrao(texto: document['funcao'],cor: Cores.cinzaTextoEscuro,tamanhoFonte: 12,)):Container(),
          largura>700?Container(width: 300,child:TextoPadrao(texto: document['email'],cor: Cores.cinzaTextoEscuro,tamanhoFonte: 12,)):Container(),
          largura>700?Container():SizedBox(width: 10,),
          Container(width: largura>700?200:largura*0.3,child: TextoPadrao(texto: document['tipo_acesso'],cor: Cores.cinzaTextoEscuro,tamanhoFonte: 12,)),
        ],
      ),
    );
  }
}
