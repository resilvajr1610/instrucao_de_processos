import 'package:flutter/material.dart';
import 'package:instrucao_de_processos/telas/instrucao_etapa_tela.dart';
import 'package:instrucao_de_processos/widgets/snackBars.dart';
import '../utilidades/cores.dart';
import 'botao_padrao_nova_instrucao.dart';
import 'caixa_texto.dart';

class ItemInstrucao extends StatelessWidget {
  var controller = TextEditingController();
  bool check = false;
  var onPressed;
  double largura;

  ItemInstrucao({
    required this.controller,
    required this.check,
    required this.onPressed,
    required this.largura
  });

  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Card(
          child: Container(
              color: Cores.cinzaClaro,
              alignment: Alignment.centerRight,
              width: 700,
              height: 65,
              padding: EdgeInsets.symmetric(horizontal: 20,vertical: 3.5),
              child: Row(
                children: [
                  CaixaTexto(controller: controller, largura: largura,textoCaixa: 'Inserir',corCaixa: Cores.cinzaClaro,corBorda: Cores.cinzaClaro,mostrarTitulo: false),
                  Spacer(),
                  check?BotaoPadraoNovaInstrucao(
                    texto: 'Criar Instrução',
                    onPressed: ()=>
                      controller.text.isNotEmpty?
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>InstrucaoEtapaTela()))
                        :showSnackBar(context, 'Insira um texto para avançar', Colors.red),
                  ):Container(),
                  IconButton(
                    icon: check?Icon(Icons.navigate_next_outlined,color: Cores.cinzaTexto,):Icon(Icons.add_box,color: Cores.primaria,),
                    onPressed: onPressed,
                  )
                ],
              )
          ),
        ),
      ],
    );
  }
}
