import 'package:flutter/material.dart';
import 'package:instrucao_de_processos/telas/instrucao_primeira_etapa_tela.dart';
import 'package:instrucao_de_processos/telas/instrucao_usuario_tela.dart';
import 'package:instrucao_de_processos/widgets/snackBars.dart';
import 'package:instrucao_de_processos/widgets/texto_padrao.dart';
import '../telas/home_tela.dart';
import '../utilidades/cores.dart';
import 'botao_padrao_nova_instrucao.dart';
import 'caixa_texto.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  var funcaoExcluirGeral;
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
    required this.funcaoExcluirGeral,
    required this.indexInicio,
    required this.indexMeio,
    required this.indexFim,
  });

  @override
  Widget build(BuildContext context) {

    String documentoReal='0.0.0';

    if(indexInicio==0 && indexMeio ==-1){
      documentoReal = '1.0.0';
    }else if(indexInicio!=-1 && indexMeio ==-1){
      documentoReal = '${indexInicio+1}.0.0';
    }else if(indexInicio!=-1 && indexMeio !=-1 && indexFim==-1){
      documentoReal = '${indexInicio+1}.${indexMeio+1}.0';
    }else if(indexInicio!=-1 && indexMeio !=-1 && indexFim!=-1){
      documentoReal = '${indexInicio+1}.${indexMeio+1}.${indexFim+1}';
    }

    return  Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: escrever?null:funcaoMostrarLista,
              child: Card(
                child: Container(
                    color: Cores.cinzaClaro,
                  // color: Colors.red,
                    alignment: Alignment.centerRight,
                    width: largura*1.455,
                    height: 65,
                    padding: largura<850?EdgeInsets.symmetric(horizontal: 10,vertical: 0):EdgeInsets.symmetric(horizontal: 20,vertical: 3.5),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: acesso_adm?0:8),
                          alignment: Alignment.topCenter,
                          height: 30,
                          child: TextoPadrao(texto: documentoReal,cor: Cores.cinzaTexto,tamanhoFonte: largura<850?10:15,)
                        ),
                        !acesso_adm?
                        TextoPadrao(texto:' '+ controller.text,cor: Cores.cinzaTexto,tamanhoFonte: largura<850?10:15,)
                            :CaixaTexto(controller: controller, largura: largura,textoCaixa: 'Inserir',corCaixa: Cores.cinzaClaro,corBorda: Cores.cinzaClaro,mostrarTitulo: false,escrever: escrever,ativarCaixa: escrever,),
                        Spacer(),
                        controller.text.isNotEmpty && listaVersao.length==0 && acesso_adm?BotaoPadraoNovaInstrucao(
                          texto: 'Criar Instrução',
                          onPressed: ()=>
                          controller.text.isNotEmpty?
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>
                              InstrucaoPrimeiraEtapaTela(idDocumento: idDocumento,idFirebase: idFirebase,emailLogado: emailLogado,idEsp: '',nomeProcedimento: nomeProcesso,)))
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
              width: largura<350?280:largura,
              child: ListView.builder(
                itemCount: listaIdEsp.length,
                itemBuilder: (context,i){

                  return listaIdEsp.isNotEmpty && listaVersao.length>i?Card(
                    child: mostrarLista?GestureDetector(
                      onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (context)=>
                          InstrucaoUsuarioTela(emailLogado: emailLogado, idEsp: listaIdEsp[i],documentoReal: documentoReal,idDocumento: idFirebase,))),
                      child: Container(
                        color: Cores.cardEsp,
                        // color: Colors.blue,
                        alignment: Alignment.centerLeft,
                        width: largura<350?250:largura,
                        // width: 500,
                        height: 65,
                        padding: EdgeInsets.symmetric(horizontal: largura>700?15:5),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              // color: Colors.yellow,
                              width: !acesso_adm?largura*0.9:largura*0.75,
                              child: TextoPadrao(
                                texto: listaVersao[i],
                                cor: Cores.primaria,
                                tamanhoFonte: largura<350?10:14,
                              ),
                            ),
                            acesso_adm?IconButton(
                                onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>
                                    InstrucaoPrimeiraEtapaTela(idDocumento: idDocumento,idFirebase: idFirebase,emailLogado: emailLogado,idEsp: listaIdEsp[i],nomeProcedimento: nomeProcesso,))),
                                icon: Icon(Icons.edit,color: Cores.primaria,size: largura==300?15:20,)
                            ):Container(),
                            acesso_adm?IconButton(onPressed: (){
                              showDialog(context: context,
                                  builder: (context){
                                    return Center(
                                      child: AlertDialog(
                                        title: TextoPadrao(texto: 'Deseja excluír esse item?',cor: Cores.primaria,negrito: FontWeight.bold,),
                                        content: Container(
                                          height: 40,
                                          width: 350,
                                          child: TextoPadrao(
                                            texto: 'Após exclusão esse item não aparecerá novamente.',
                                            cor: Cores.cinzaTextoEscuro,
                                          ),
                                        ),
                                        actions: [
                                          TextButton(child: TextoPadrao(texto: 'Não',cor: Colors.green,negrito: FontWeight.bold,),onPressed: ()=>Navigator.pop(context),),
                                          TextButton(child: TextoPadrao(texto: 'Confimar Exclusão',cor: Colors.red,negrito: FontWeight.bold,),onPressed: (){
                                            FirebaseFirestore.instance.collection('documentos').doc(idFirebase).update({
                                              'listaIdEsp': FieldValue.arrayRemove([listaIdEsp[i]]),
                                              'listaVersao' : FieldValue.arrayRemove([listaVersao[i]]),
                                            }).then((value){
                                              FirebaseFirestore.instance.collection('especificacao').doc(listaIdEsp[i]).delete().then((value){
                                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomeTela(emailLogado: emailLogado)));
                                              });
                                            });
                                          }),
                                        ],
                                      ),
                                    );
                                  });
                            }, icon: Icon(Icons.delete,size: largura==300?15:20,color: Colors.red,)):Container()
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
        acesso_adm &&idFirebase!=''?Padding(
          padding: EdgeInsets.symmetric(vertical: 20.0),
          child: IconButton(
            onPressed: funcaoExcluirGeral,
            icon: Icon(Icons.delete,color: Colors.red,)
          ),
        ):Container(width: 40,)
      ],
    );
  }
}
