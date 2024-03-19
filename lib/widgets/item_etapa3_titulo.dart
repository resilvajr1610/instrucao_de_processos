import 'package:flutter/material.dart';
import 'package:instrucao_de_processos/widgets/texto_padrao.dart';
import '../modelos/bad_state_list.dart';
import '../modelos/bad_state_string.dart';
import '../utilidades/cores.dart';
import '../utilidades/variavel_estatica.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ItemEtapa3Titulo extends StatelessWidget {
  DocumentSnapshot? dadosEspecificacao;
  String item1;
  String item2;
  String titulo1;
  String titulo2;
  bool dadoString1;
  bool dadoString2;

  ItemEtapa3Titulo({
    required this.dadosEspecificacao,
    required this.item1,
    required this.item2,
    required this.titulo1,
    required this.titulo2,
    this.dadoString1 = true,
    this.dadoString2 = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: VariavelEstatica.largura>1500?VariavelEstatica.largura * 0.45:VariavelEstatica.largura * 0.15,
          child: Row(
            children: [
              TextoPadrao(texto: titulo1,cor: Cores.primaria,tamanhoFonte: 14,),
              SizedBox(width: 10,),
              TextoPadrao(
                texto: dadoString1
                  ?BadStateString(dadosEspecificacao, item1)
                  :BadStateList(dadosEspecificacao, item1).toString().replaceAll('[', '').replaceAll(']', ''),
                cor: Cores.cinzaTextoEscuro,
                tamanhoFonte: 14,
              ),
            ],
          ),
        ),
        Container(
          width: VariavelEstatica.largura>1500?VariavelEstatica.largura * 0.45:VariavelEstatica.largura * 0.15,
          child: Row(
            children: [
              TextoPadrao(texto: titulo2,cor: Cores.primaria,tamanhoFonte: 14,),
              SizedBox(width: 10,),
              TextoPadrao(
                texto: dadoString2
                    ?BadStateString(dadosEspecificacao, item2)
                    :BadStateList(dadosEspecificacao, item2).toString().replaceAll('[', '').replaceAll(']', ''),
                cor: Cores.cinzaTextoEscuro,
                tamanhoFonte: 14,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
