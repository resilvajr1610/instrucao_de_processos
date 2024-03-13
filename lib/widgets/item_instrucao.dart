import 'package:flutter/material.dart';
import 'package:instrucao_de_processos/telas/instrucao_primeira_etapa_tela.dart';
import 'package:instrucao_de_processos/widgets/snackBars.dart';
import 'package:instrucao_de_processos/widgets/texto_padrao.dart';
import '../utilidades/cores.dart';
import 'botao_padrao_nova_instrucao.dart';
import 'caixa_texto.dart';

class ItemInstrucao extends StatelessWidget {
  String idFirebase;
  String idDocumento;
  String idEsp;
  String nomeProcesso;
  int versao;
  var controller = TextEditingController();
  bool ativarBotaoAdicionarItemLista = false;
  var onPressed;
  double largura;
  bool escrever;
  String emailLogado;

  ItemInstrucao({
    required this.idFirebase,
    required this.idDocumento,
    required this.idEsp,
    required this.nomeProcesso,
    required this.versao,
    required this.controller,
    required this.ativarBotaoAdicionarItemLista,
    required this.onPressed,
    required this.largura,
    required this.escrever,
    required this.emailLogado
  });

  @override
  Widget build(BuildContext context) {

    return  Column(
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
                  TextoPadrao(texto: idDocumento,cor: Cores.cinzaTexto,),
                  CaixaTexto(controller: controller, largura: largura,textoCaixa: 'Inserir',corCaixa: Cores.cinzaClaro,corBorda: Cores.cinzaClaro,mostrarTitulo: false,escrever: escrever,),
                  Spacer(),
                  ativarBotaoAdicionarItemLista?BotaoPadraoNovaInstrucao(
                    texto: 'Criar Instrução',
                    onPressed: ()=>
                    controller.text.isNotEmpty?
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>
                        InstrucaoPrimeiraEtapaTela(idDocumento: idDocumento,idFirebase: idFirebase,emailLogado: emailLogado,idEsp: idEsp,)))
                        :showSnackBar(context, 'Insira um texto para avançar', Colors.red),
                  ):Container(),
                  IconButton(
                    icon: ativarBotaoAdicionarItemLista?Icon(Icons.navigate_next_outlined,color: Cores.cinzaTexto,):Icon(Icons.add_box,color: Cores.primaria,),
                    onPressed: ativarBotaoAdicionarItemLista?null:onPressed,
                  )
                ],
              )
          ),
        ),
        idEsp!='' && nomeProcesso!=''?Card(
          child: GestureDetector(
            onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (context)=>
                InstrucaoPrimeiraEtapaTela(idDocumento: idDocumento,idFirebase: idFirebase,emailLogado: emailLogado,idEsp: idEsp,))),
            child: Container(
              color: Cores.cardEsp,
              alignment: Alignment.centerLeft,
              width: largura,
              height: 65,
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextoPadrao(
                texto: '$nomeProcesso - Versão $versao',
                cor: Cores.primaria,
              ),
            ),
          ),
        ):Container()
      ],
    );
  }
}
