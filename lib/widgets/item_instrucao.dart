import 'package:flutter/material.dart';
import 'package:instrucao_de_processos/telas/instrucao_primeira_etapa_tela.dart';
import 'package:instrucao_de_processos/telas/instrucao_usuario_tela.dart';
import 'package:instrucao_de_processos/widgets/snackBars.dart';
import 'package:instrucao_de_processos/widgets/texto_padrao.dart';
import '../utilidades/cores.dart';
import 'botao_padrao_nova_instrucao.dart';
import 'caixa_texto.dart';

class ItemInstrucao extends StatelessWidget {
  String idFirebase;
  String idDocumento;
  List listaIdEsp;
  String nomeProcesso;
  List listaVersao;
  var controller = TextEditingController();
  bool ativarBotaoAdicionarItemLista = false;
  var funcaoItemLista;
  double largura;
  bool escrever;
  String emailLogado;
  bool acesso_adm;
  bool mostrarLista;
  var funcaoMostrarLista;
  var funcaoExcluir;
  int indexInicio;
  int indexMeio;
  int indexFim;

  ItemInstrucao({
    required this.idFirebase,
    required this.idDocumento,
    required this.listaIdEsp,
    required this.nomeProcesso,
    required this.listaVersao,
    required this.controller,
    required this.ativarBotaoAdicionarItemLista,
    required this.funcaoItemLista,
    required this.largura,
    required this.escrever,
    required this.emailLogado,
    required this.acesso_adm,
    required this.mostrarLista,
    required this.funcaoMostrarLista,
    required this.funcaoExcluir,
    required this.indexInicio,
    required this.indexMeio,
    required this.indexFim,
  });

  @override
  Widget build(BuildContext context) {

    String documentoReal='0.0.0';

    if(indexInicio==0 && indexMeio ==0){
      documentoReal = '1.0.0';
    }else if(indexInicio!=0 && indexMeio ==0){
      documentoReal = '${indexInicio+1}.0.0';
    }else if(indexInicio!=0 && indexMeio !=0 && indexFim==0){
      documentoReal = '${indexInicio+1}.${indexMeio+1}.0';
    }else if(indexInicio!=0 && indexMeio !=0 && indexFim!=0){
      documentoReal = '${indexInicio+1}.${indexMeio+1}.${indexFim+1}';
    }

    return  Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: escrever?null:funcaoMostrarLista,
              child: Card(
                child: Container(
                    color: Cores.cinzaClaro,
                    alignment: Alignment.centerRight,
                    width: 700,
                    height: 65,
                    padding: EdgeInsets.symmetric(horizontal: 20,vertical: 3.5),
                    child: Row(
                      children: [
                        TextoPadrao(texto: documentoReal,cor: Cores.cinzaTexto,),
                        !acesso_adm?Container():CaixaTexto(controller: controller, largura: largura,textoCaixa: 'Inserir',corCaixa: Cores.cinzaClaro,corBorda: Cores.cinzaClaro,mostrarTitulo: false,escrever: escrever,ativarCaixa: escrever,),
                        Spacer(),
                        ativarBotaoAdicionarItemLista && listaIdEsp.isNotEmpty && nomeProcesso=='' && acesso_adm?BotaoPadraoNovaInstrucao(
                          texto: 'Criar Instrução',
                          onPressed: ()=>
                          controller.text.isNotEmpty?
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>
                              InstrucaoPrimeiraEtapaTela(idDocumento: idDocumento,idFirebase: idFirebase,emailLogado: emailLogado,idEsp: listaIdEsp[0],)))
                              :showSnackBar(context, 'Insira um texto para avançar', Colors.red),
                        ):Container(),
                        acesso_adm && controller.text.isEmpty?IconButton(
                            icon: ativarBotaoAdicionarItemLista ?Icon(Icons.navigate_next_outlined,color: Cores.cinzaTexto,):Icon(Icons.add_box,color: Cores.primaria,),
                            onPressed: ativarBotaoAdicionarItemLista ?null:funcaoItemLista,
                          ):Container(),
                        // mostrarLista?Container():acesso_adm?IconButton(
                        //   icon: ativarBotaoAdicionarItemLista ?Icon(Icons.navigate_next_outlined,color: Cores.cinzaTexto,):Icon(Icons.add_box,color: Cores.primaria,),
                        //   onPressed: ativarBotaoAdicionarItemLista ?null:funcaoItemLista,
                        // ):Icon(Icons.navigate_next_outlined,color: Cores.cinzaTexto,),
                        mostrarLista && controller.text.isNotEmpty?Icon(Icons.keyboard_arrow_down_rounded,color: Cores.cinzaTexto,):Container()
                      ],
                    )
                ),
              ),
            ),
            Container(
              height: mostrarLista?listaIdEsp.length * 80:0,
              width: largura*1.1,
              child: ListView.builder(
                itemCount: listaIdEsp.length,
                itemBuilder: (context,i){
                  return listaIdEsp.isNotEmpty!='' && nomeProcesso!=''?Card(
                    child: mostrarLista?GestureDetector(
                      onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (context)=>InstrucaoUsuarioTela(emailLogado: emailLogado, idEsp: listaIdEsp[i]))),
                      child: Container(
                        color: Cores.cardEsp,
                        alignment: Alignment.centerLeft,
                        width: largura,
                        height: 65,
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              width: !acesso_adm?largura*0.9:largura*0.8,
                              child: TextoPadrao(
                                texto: listaVersao[i],
                                cor: Cores.primaria,
                              ),
                            ),
                            acesso_adm?IconButton(
                                onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>
                                    InstrucaoPrimeiraEtapaTela(idDocumento: idDocumento,idFirebase: idFirebase,emailLogado: emailLogado,idEsp: listaIdEsp[i],))),
                                icon: Icon(Icons.edit,color: Cores.primaria,)
                            ):Container()
                          ],
                        ),
                      ),
                    ):Container(),
                  ):Container();
                },
              ),
            )
          ],
        ),
        acesso_adm?IconButton(
          onPressed: funcaoExcluir,
          icon: Icon(Icons.delete,color: Colors.red,)
        ):Container()
      ],
    );
  }
}
