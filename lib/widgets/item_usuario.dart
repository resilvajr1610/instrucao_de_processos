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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        children: [
          Container(width: 300,child: TextoPadrao(texto: document['nome'],cor: Cores.cinzaTextoEscuro,tamanhoFonte: 12,)),
          Container(width: 200,child: TextoPadrao(texto: document['funcao'],cor: Cores.cinzaTextoEscuro,tamanhoFonte: 12,)),
          Container(width: 300,child:TextoPadrao(texto: document['email'],cor: Cores.cinzaTextoEscuro,tamanhoFonte: 12,)),
          Container(width: 200,child: TextoPadrao(texto: document['tipo_acesso'],cor: Cores.cinzaTextoEscuro,tamanhoFonte: 12,)),
        ],
      ),
    );
  }
}
