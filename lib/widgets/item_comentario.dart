import 'package:flutter/material.dart';
import 'package:instrucao_de_processos/modelos/bad_state_int.dart';
import 'package:instrucao_de_processos/modelos/bad_state_string.dart';
import 'package:instrucao_de_processos/widgets/texto_padrao.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../utilidades/cores.dart';
import '../utilidades/variavel_estatica.dart';

class ItemComentario extends StatelessWidget {
  DocumentSnapshot document;

  ItemComentario({
    required this.document
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Column(
        children: [
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(width: 150,child: TextoPadrao(texto:VariavelEstatica.mascaraDataHora.format(document!['data'].toDate()),cor: Cores.cinzaTextoEscuro,tamanhoFonte: 12,)),
              Container(width: 100,child: TextoPadrao(texto: BadStateInt(document, 'fip').toString(),cor: Cores.cinzaTextoEscuro,tamanhoFonte: 12,alinhamentoTexto: TextAlign.center,)),
              Container(width: 200,child: TextoPadrao(texto: BadStateString(document, 'processo'),cor: Cores.cinzaTextoEscuro,tamanhoFonte: 12,)),
              Container(width: 100,child: TextoPadrao(texto: BadStateInt(document, 'versao').toString(),cor: Cores.cinzaTextoEscuro,tamanhoFonte: 12,alinhamentoTexto: TextAlign.center)),
              Container(width: 150,child: TextoPadrao(texto: BadStateInt(document, 'numEtapa').toString(),cor: Cores.cinzaTextoEscuro,tamanhoFonte: 12,alinhamentoTexto: TextAlign.center)),
              Container(width: 200,child:TextoPadrao(texto: BadStateString(document, 'descricaoEtapa'),cor: Cores.cinzaTextoEscuro,tamanhoFonte: 12,)),
              Container(width: 300,child: TextoPadrao(texto: BadStateString(document,'comentario').toUpperCase(),cor: Cores.cinzaTextoEscuro,tamanhoFonte: 12,maxLines: 2,)),
            ],
          ),
        ],
      ),
    );
  }
}
