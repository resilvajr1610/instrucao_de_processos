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
              Container(width: VariavelEstatica.largura*0.1,child: TextoPadrao(texto:VariavelEstatica.mascaraDataHora.format(document!['data'].toDate()),cor: Cores.cinzaTextoEscuro,tamanhoFonte: 12)),
              Container(width: VariavelEstatica.largura*0.08,child: TextoPadrao(texto: BadStateInt(document, 'fip').toString(),cor: Cores.cinzaTextoEscuro,tamanhoFonte: 12,alinhamentoTexto: TextAlign.center,)),
              Container(width: VariavelEstatica.largura*0.15,child: TextoPadrao(texto: BadStateString(document, 'processo'),cor: Cores.cinzaTextoEscuro,tamanhoFonte: 12)),
              Container(width: VariavelEstatica.largura*0.08,child: TextoPadrao(texto: BadStateInt(document, 'versao').toString(),cor: Cores.cinzaTextoEscuro,tamanhoFonte: 12,alinhamentoTexto: TextAlign.center)),
              Container(width: VariavelEstatica.largura*0.1,child: TextoPadrao(texto: BadStateInt(document, 'numEtapa').toString(),cor: Cores.cinzaTextoEscuro,tamanhoFonte: 12,alinhamentoTexto: TextAlign.center)),
              Container(width: VariavelEstatica.largura*0.15,child:TextoPadrao(texto: BadStateString(document, 'descricaoEtapa'),cor: Cores.cinzaTextoEscuro,tamanhoFonte: 12,maxLines: 3,)),
              Container(width: VariavelEstatica.largura*0.2,child: TextoPadrao(texto: BadStateString(document,'comentario').toUpperCase(),cor: Cores.cinzaTextoEscuro,tamanhoFonte: 12,maxLines: 3)),
            ],
          ),
        ],
      ),
    );
  }
}
