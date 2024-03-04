import 'package:flutter/material.dart';
import 'package:instrucao_de_processos/telas/instrucao_etapa_tela.dart';
import 'package:instrucao_de_processos/widgets/snackBars.dart';
import 'package:instrucao_de_processos/widgets/texto_padrao.dart';
import '../utilidades/cores.dart';
import 'botao_padrao_nova_instrucao.dart';
import 'caixa_texto.dart';

class ItemInstrucao extends StatelessWidget {
  String idFirebase;
  String idDocumento;
  var controller = TextEditingController();
  bool ativarBotaoAdicionarItemLista = false;
  var onPressed;
  double largura;
  bool escrever;
  String emailLogado;

  ItemInstrucao({
    required this.idFirebase,
    required this.idDocumento,
    required this.controller,
    required this.ativarBotaoAdicionarItemLista,
    required this.onPressed,
    required this.largura,
    required this.escrever,
    required this.emailLogado
  });

  @override
  Widget build(BuildContext context) {

    return  Card(
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
                Navigator.push(context, MaterialPageRoute(builder: (context)=>InstrucaoEtapaTela(idDocumento: idDocumento,idFirebase: idFirebase,emailLogado: emailLogado,)))
                    :showSnackBar(context, 'Insira um texto para avançar', Colors.red),
              ):Container(),
              IconButton(
                icon: ativarBotaoAdicionarItemLista?Icon(Icons.navigate_next_outlined,color: Cores.cinzaTexto,):Icon(Icons.add_box,color: Cores.primaria,),
                onPressed: ativarBotaoAdicionarItemLista?null:onPressed,
              )
            ],
          )
      ),
    );
  }
}
