import 'package:flutter/material.dart';
import 'package:instrucao_de_processos/modelos/bad_state_int.dart';
import 'package:instrucao_de_processos/modelos/bad_state_string.dart';
import 'package:instrucao_de_processos/modelos/modelo_instrucao_lista_1_0_0.dart';
import 'package:instrucao_de_processos/modelos/modelo_instrucao_lista_1_1_0.dart';
import 'package:instrucao_de_processos/modelos/modelo_instrucao_lista_1_1_1.dart';
import 'package:instrucao_de_processos/utilidades/cores.dart';
import 'package:instrucao_de_processos/utilidades/variavel_estatica.dart';
import 'package:instrucao_de_processos/widgets/appbar_padrao.dart';
import 'package:instrucao_de_processos/widgets/caixa_texto_pesquisa.dart';
import 'package:instrucao_de_processos/widgets/item_instrucao.dart';
import 'package:instrucao_de_processos/widgets/snackBars.dart';
import '../widgets/texto_padrao.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeTela extends StatefulWidget {
  String emailLogado;

  HomeTela({
    required this.emailLogado
});

  @override
  State<HomeTela> createState() => _HomeTelaState();
}

class _HomeTelaState extends State<HomeTela> {

  List<ModeloInstrucaoLista_1_0_0> listaInstrucaoPrincipal=[];
  var pesquisa = TextEditingController();
  double larguraInicioCaixaTexto = 450;
  double larguraMeioCaixaTexto = 350;
  double larguraFinalCaixaTexto = 300;

  double larguraInicioCard = 680;
  double larguraMeioCard = 600;
  double larguraFinalCard = 550;
  double alturaItens = 75;
  double alturaListaFinal = 0;
  double alturaListaInicio = 0;
  bool carregando = true;
  bool acesso_adm = false;

  adicionarListaInicio(String idDoc,String idFire,String idEsp,String nomeProcesso,int versao, String titulo,bool ativarBotaoAdicionarItemLista, bool escrever ){
    listaInstrucaoPrincipal.add(
      ModeloInstrucaoLista_1_0_0(
        idDoc: idDoc,
        idFire: idFire,
        idEsp: idEsp,
        nomeProcesso: nomeProcesso,
        versao: versao,
        controller: TextEditingController(text: titulo),
        ativarBotaoAdicionarItemLista: ativarBotaoAdicionarItemLista,
        escrever: escrever,
        largura: 450,
        listaMeio: [],
        alturaListaMeio: 0
      )
    );
    alturaListaInicio = alturaListaInicio + alturaItens;
    if(idEsp!=''){
      alturaListaInicio = alturaListaInicio + alturaItens;
    }
    carregando = false;
    setState(() {});
  }
  carregarDadosInicio()async{
    FirebaseFirestore.instance.collection('documentos').where('posicao',isEqualTo: 'inicio').orderBy('idDoc').get().then((docs){
      if(docs.docs.isNotEmpty){
        for(int i = 0; docs.docs.length > i; i++) {
          if(acesso_adm){
            // print(docs.docs[i]['idDoc']);
            adicionarListaInicio(docs.docs[i]['idDoc'], docs.docs[i]['idFire'],BadStateString(docs.docs[i], 'idEsp'),BadStateString(docs.docs[i], 'nomeProcesso'),BadStateInt(docs.docs[i], 'versao'),docs.docs[i]['titulo'], false, true);
            if(docs.docs.length == i+1){
              adicionarListaInicio('${i+2}.0.0','','','',0,'', false, true);
              carregarDadosMeio();
              setState(() {});
            }
          }else{
            if(BadStateString(docs.docs[i],'situacao')!=''){
              adicionarListaInicio(docs.docs[i]['idDoc'], docs.docs[i]['idFire'],BadStateString(docs.docs[i], 'idEsp'),BadStateString(docs.docs[i], 'nomeProcesso'),BadStateInt(docs.docs[i], 'versao'),docs.docs[i]['titulo'], false, true);
              if(docs.docs.length == i+1){
                adicionarListaInicio('${i+2}.0.0','','','',0,'', false, true);
                carregarDadosMeio();
                setState(() {});
              }
            }
          }
        }
      }else{
        adicionarListaInicio('1.0.0', '','','',0,'inicio vazio', false, true);
        carregando = false;
        setState((){});
      }
    });
  }

  adicionarListaMeio(int inicio, bool addPrincipal,String idFire, String idDoc, String idEsp, String nomeProcesso, int versao, String titulo, bool ativarBotaoAdicionarItemLista, bool escrever){
    listaInstrucaoPrincipal[inicio].listaMeio.add(
      ModeloInstrucaoLista_1_1_0(
        idFire: idFire,
        idDoc: idDoc,
        idEsp: idEsp,
        nomeProcesso: nomeProcesso,
        versao: versao,
        controller: TextEditingController(text: titulo),
        ativarBotaoAdicionarItemLista: false,
        largura: larguraMeioCaixaTexto,
        escrever: true,
        listaFinal: [],
        alturaListaFinal: 0
      )
    );
    listaInstrucaoPrincipal[inicio].escrever = false;
    listaInstrucaoPrincipal[inicio].ativarBotaoAdicionarItemLista = true;
    alturaListaInicio = alturaListaInicio + alturaItens;
    listaInstrucaoPrincipal[inicio].alturaListaMeio = listaInstrucaoPrincipal[inicio].alturaListaMeio + alturaItens;
    if(idEsp!=''){
      alturaListaInicio = alturaListaInicio + alturaItens;
    }
    if(addPrincipal){
      alturaListaInicio = alturaListaInicio + alturaItens + alturaItens;
      listaInstrucaoPrincipal[inicio].alturaListaMeio = listaInstrucaoPrincipal[inicio].alturaListaMeio + alturaItens;
      adicionarListaInicio('${listaInstrucaoPrincipal.length+1}.0.0','','','',0,'',false,true);
    }
    setState(() {});
  }
  carregarDadosMeio()async{
    FirebaseFirestore.instance.collection('documentos').where('posicao',isEqualTo: 'meio').orderBy('idDoc').get().then((docs){
      for(int i = 0; docs.docs.length > i; i++) {
        if(acesso_adm){
          // print(docs.docs[i]['idDoc']);
          List dividirDoc = docs.docs[i]['idDoc'].toString().split('.');
          int inicio = int.parse(dividirDoc[0]);
          int meio = int.parse(dividirDoc[1]);
          listaInstrucaoPrincipal[inicio-1].ativarBotaoAdicionarItemLista = false;
          if(BadStateString(docs.docs[i],'nomeProcesso')!=''){
            alturaListaInicio = alturaListaInicio + alturaItens;
          }
          adicionarListaMeio(inicio-1,false,docs.docs[i]['idFire'],docs.docs[i]['idDoc'],BadStateString(docs.docs[i],'idEsp'),BadStateString(docs.docs[i],'nomeProcesso'),BadStateInt(docs.docs[i], 'versao'),docs.docs[i]['titulo'], true, false);
          if(docs.docs.length == i+1){
            alturaListaInicio = alturaListaInicio + alturaItens;
            listaInstrucaoPrincipal[inicio-1].alturaListaMeio = listaInstrucaoPrincipal[inicio-1].alturaListaMeio + alturaItens;
            listaInstrucaoPrincipal[inicio-1].listaMeio.add(
                ModeloInstrucaoLista_1_1_0(
                    idFire: '',
                    idEsp: '',
                    nomeProcesso: '',
                    versao: 0,
                    idDoc: '$inicio.${meio+1}.0',
                    controller: TextEditingController(text: 'add meio'),
                    ativarBotaoAdicionarItemLista: false,
                    largura: larguraMeioCaixaTexto,
                    escrever: true,
                    listaFinal: [],
                    alturaListaFinal: 0
                )
            );
            setState(() {});
            carregarDadosFim();
          }
        }else{
          if(BadStateString(docs.docs[i],'situacao')!=''){
            // print(docs.docs[i]['idDoc']);
            List dividirDoc = docs.docs[i]['idDoc'].toString().split('.');
            int inicio = int.parse(dividirDoc[0]);
            int meio = int.parse(dividirDoc[1]);
            listaInstrucaoPrincipal[inicio-1].ativarBotaoAdicionarItemLista = false;
            if(BadStateString(docs.docs[i],'nomeProcesso')!=''){
              alturaListaInicio = alturaListaInicio + alturaItens;
            }
            adicionarListaMeio(inicio-1,false,docs.docs[i]['idFire'],docs.docs[i]['idDoc'],BadStateString(docs.docs[i],'idEsp'),BadStateString(docs.docs[i],'nomeProcesso'),BadStateInt(docs.docs[i], 'versao'),docs.docs[i]['titulo'], true, false);
            if(docs.docs.length == i+1){
              alturaListaInicio = alturaListaInicio + alturaItens;
              listaInstrucaoPrincipal[inicio-1].alturaListaMeio = listaInstrucaoPrincipal[inicio-1].alturaListaMeio + alturaItens;
              listaInstrucaoPrincipal[inicio-1].listaMeio.add(
                  ModeloInstrucaoLista_1_1_0(
                      idFire: '',
                      idEsp: '',
                      nomeProcesso: '',
                      versao: 0,
                      idDoc: '$inicio.${meio+1}.0',
                      controller: TextEditingController(text: 'add meio'),
                      ativarBotaoAdicionarItemLista: false,
                      largura: larguraMeioCaixaTexto,
                      escrever: true,
                      listaFinal: [],
                      alturaListaFinal: 0
                  )
              );
              setState(() {});
              carregarDadosFim();
            }
          }
        }
      }
    });
  }

  adicionarListaFim(int inicio, int meio,bool addMeio,String idFire, String idDoc,String idEsp, String nomeProcesso,int versao, String titulo, bool checkFinal, bool escrever){
    List<ModeloInstrucaoLista_1_1_1> listaFinal = [];
    listaFinal.add(
      ModeloInstrucaoLista_1_1_1(
        idFire: idFire,
        idDoc: idDoc,
        idEsp: idEsp,
        nomeProcesso: nomeProcesso,
        versao: versao,
        controller: TextEditingController(text: titulo),
        checkFinal: checkFinal,
        largura: larguraFinalCaixaTexto,
        escrever: escrever
      )
    );
    listaInstrucaoPrincipal[inicio].listaMeio[meio].listaFinal = listaFinal;
    listaInstrucaoPrincipal[inicio].listaMeio[meio].ativarBotaoAdicionarItemLista = true;
    listaInstrucaoPrincipal[inicio].listaMeio[meio].escrever = false;
    listaInstrucaoPrincipal[inicio].escrever = false;
    listaInstrucaoPrincipal[inicio].ativarBotaoAdicionarItemLista = true;
    alturaListaFinal = alturaListaFinal + alturaItens;
    if(idEsp!=''){
      alturaListaFinal = alturaListaFinal + alturaItens;
    }
    listaInstrucaoPrincipal[inicio].listaMeio[meio].alturaListaFinal = listaInstrucaoPrincipal[inicio].listaMeio[meio].alturaListaFinal + alturaItens;
    if(addMeio){
      alturaListaInicio = alturaListaInicio +alturaItens + alturaItens;
      listaInstrucaoPrincipal[inicio].alturaListaMeio = listaInstrucaoPrincipal[inicio].alturaListaMeio+ alturaItens + alturaItens;
      listaInstrucaoPrincipal[inicio].listaMeio[meio].alturaListaFinal = listaInstrucaoPrincipal[inicio].listaMeio[meio].alturaListaFinal + alturaItens;
      listaInstrucaoPrincipal[inicio].listaMeio.add(
          ModeloInstrucaoLista_1_1_0(
              idFire: '',
              idEsp: '',
              nomeProcesso: '',
              versao: 0,
              idDoc: '${inicio+1}.${meio+2}.0',
              controller: TextEditingController(),
              ativarBotaoAdicionarItemLista: false,
              largura: larguraMeioCaixaTexto,
              escrever: true,
              listaFinal: [],
              alturaListaFinal: 0
          )
      );
    }
    setState(() {});
  }

  carregarDadosFim()async{
    FirebaseFirestore.instance.collection('documentos').where('posicao',isEqualTo: 'fim').orderBy('idDoc').get().then((docs){
      for(int i = 0; docs.docs.length > i; i++) {
       if(acesso_adm){
         // print(docs.docs[i]['idDoc']);
         List dividirDoc = docs.docs[i]['idDoc'].toString().split('.');
         int inicio = int.parse(dividirDoc[0]);
         int meio = int.parse(dividirDoc[1]);
         listaInstrucaoPrincipal[inicio-1].listaMeio[meio-1].ativarBotaoAdicionarItemLista = false;
         adicionarListaFim(inicio-1,meio-1,false,docs.docs[i]['idFire'],docs.docs[i]['idDoc'],BadStateString(docs.docs[i],'idEsp'),BadStateString(docs.docs[i],'nomeProcesso'),BadStateInt(docs.docs[i], 'versao'),docs.docs[i]['titulo'], true, false);
         if(docs.docs.length == i+1){
           alturaListaInicio = alturaListaInicio + alturaItens;
           listaInstrucaoPrincipal[inicio-1].alturaListaMeio = listaInstrucaoPrincipal[inicio-1].alturaListaMeio + alturaItens;
           // adicionarListaFinal(inicio - 1,meio-1,false,'','$inicio.${meio}.1','flutter fim',true,false);
           setState(() {});
         }else{
           if(BadStateString(docs.docs[i],'situacao')!=''){
             print(docs.docs[i]['idDoc']);
             List dividirDoc = docs.docs[i]['idDoc'].toString().split('.');
             int inicio = int.parse(dividirDoc[0]);
             int meio = int.parse(dividirDoc[1]);
             listaInstrucaoPrincipal[inicio-1].listaMeio[meio-1].ativarBotaoAdicionarItemLista = false;
             adicionarListaFim(inicio-1,meio-1,false,docs.docs[i]['idFire'],docs.docs[i]['idDoc'],BadStateString(docs.docs[i],'idEsp'),BadStateString(docs.docs[i],'nomeProcesso'),BadStateInt(docs.docs[i], 'versao'),docs.docs[i]['titulo'], true, false);
             if(docs.docs.length == i+1){
               alturaListaInicio = alturaListaInicio + alturaItens;
               listaInstrucaoPrincipal[inicio-1].alturaListaMeio = listaInstrucaoPrincipal[inicio-1].alturaListaMeio + alturaItens;
               // adicionarListaFinal(inicio - 1,meio-1,false,'','$inicio.${meio}.1','flutter fim',true,false);
               setState(() {});
             }
           }
         }
       }
      }
    });
  }

  Future<String> salvarFirebase(String colecao, String titulo, String idDocumento, String nivel) async {
    DocumentReference docRef = FirebaseFirestore.instance.collection(colecao).doc();
    await docRef.set({
      'idFire': docRef.id,
      'idDoc'     : idDocumento,
      'titulo'    : titulo,
      'posicao'   : nivel
    });
    return docRef.id;
  }

  carregarFuncao()async{
    FirebaseFirestore.instance.collection('usuarios').where('email',isEqualTo: widget.emailLogado).get().then((dadosUsuario){
      if(dadosUsuario.docs[0]['tipo_acesso']=='ADM'){
        acesso_adm = true;
      }
      carregarDadosInicio();
    });
  }

  @override
  void initState() {
    super.initState();
    carregarFuncao();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Cores.cinzaClaro,
      appBar: carregando?null:AppBarPadrao(mostrarUsuarios: true,emailLogado: widget.emailLogado,mostrarComentarios: acesso_adm),
      body: Container(
        width: VariavelEstatica.largura,
        height: VariavelEstatica.altura,
        padding: EdgeInsets.symmetric(vertical: 32,horizontal: 60),
        child: carregando?Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(color: Cores.primaria,),
              TextoPadrao(texto: 'Buscando informações, aguarde ...',cor: Colors.black,)
            ],
          ),
        ):Card(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 36, horizontal: 46),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextoPadrao(texto: 'Documentos disponíveis',cor: Cores.primaria,negrito: FontWeight.bold,tamanhoFonte: 20,),
                  SizedBox(height: 40,),
                  CaixaTextoPesquisa(
                    textoCaixa: 'Pesquisar',
                    controller: pesquisa,
                    largura: 600,
                  ),
                  SizedBox(height: 33,),
                  Container(
                    // color: Colors.green,
                    height: alturaListaInicio,
                    width: larguraInicioCard,
                    child: ListView.builder(
                      // physics: NeverScrollableScrollPhysics(),
                      itemCount: listaInstrucaoPrincipal.length,
                      itemBuilder: (context,inicio){
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            ItemInstrucao(
                              acesso_adm: acesso_adm,
                              controller: listaInstrucaoPrincipal[inicio].controller,
                              ativarBotaoAdicionarItemLista: listaInstrucaoPrincipal[inicio].ativarBotaoAdicionarItemLista,
                              largura: listaInstrucaoPrincipal[inicio].largura,
                              escrever: listaInstrucaoPrincipal[inicio].escrever,
                              idFirebase: listaInstrucaoPrincipal[inicio].idFire,
                              idDocumento: listaInstrucaoPrincipal[inicio].idDoc,
                              idEsp: listaInstrucaoPrincipal[inicio].idEsp,
                              nomeProcesso: listaInstrucaoPrincipal[inicio].nomeProcesso,
                              versao: listaInstrucaoPrincipal[inicio].versao,
                              emailLogado: widget.emailLogado,
                              onPressed: ()async{
                                if(listaInstrucaoPrincipal[inicio].controller.text.isNotEmpty && listaInstrucaoPrincipal[inicio].controller.text !=''){
                                  if(listaInstrucaoPrincipal[inicio].idFire!=''){
                                    listaInstrucaoPrincipal[inicio].ativarBotaoAdicionarItemLista = true;
                                    FirebaseFirestore.instance.collection('documentos').doc(listaInstrucaoPrincipal[inicio].idFire).update({
                                          'titulo':listaInstrucaoPrincipal[inicio].controller.text
                                        }).then((value){
                                      adicionarListaMeio(inicio,false,'','${inicio+1}.1.0','','',0,'',false,true);
                                      setState(() {});
                                    });
                                  }else{
                                    salvarFirebase('documentos',listaInstrucaoPrincipal[inicio].controller.text,listaInstrucaoPrincipal[inicio].idDoc,'inicio').then((value){
                                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomeTela(emailLogado: widget.emailLogado)));
                                    });
                                  }
                                }else{
                                  showSnackBar(context, 'Adicione um texto para avançar', Colors.red);
                                }
                              },
                            ),
                            Container(
                              // color: Colors.red,
                              height: listaInstrucaoPrincipal[inicio].alturaListaMeio,
                              width: larguraMeioCard,
                              child: ListView.builder(
                                // physics: NeverScrollableScrollPhysics(),
                                itemCount: listaInstrucaoPrincipal[inicio].listaMeio.length,
                                itemBuilder: (context,meio){
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      ItemInstrucao(
                                        acesso_adm: acesso_adm,
                                        controller: listaInstrucaoPrincipal[inicio].listaMeio[meio].controller,
                                        ativarBotaoAdicionarItemLista: listaInstrucaoPrincipal[inicio].listaMeio[meio].ativarBotaoAdicionarItemLista,
                                        largura: listaInstrucaoPrincipal[inicio].listaMeio[meio].largura,
                                        escrever: listaInstrucaoPrincipal[inicio].listaMeio[meio].escrever,
                                        idFirebase: listaInstrucaoPrincipal[inicio].listaMeio[meio].idFire,
                                        idDocumento: listaInstrucaoPrincipal[inicio].listaMeio[meio].idDoc,
                                        idEsp: listaInstrucaoPrincipal[inicio].listaMeio[meio].idEsp,
                                        nomeProcesso: listaInstrucaoPrincipal[inicio].listaMeio[meio].nomeProcesso,
                                        versao: listaInstrucaoPrincipal[inicio].listaMeio[meio].versao,
                                        emailLogado: widget.emailLogado,
                                        onPressed: ()async{
                                          if(listaInstrucaoPrincipal[inicio].listaMeio[meio].controller.text.isNotEmpty && listaInstrucaoPrincipal[inicio].listaMeio[meio].controller.text !=''){
                                            if(listaInstrucaoPrincipal[inicio].listaMeio[meio].idFire!=''){
                                              listaInstrucaoPrincipal[inicio].listaMeio[meio].ativarBotaoAdicionarItemLista = true;
                                              listaInstrucaoPrincipal[inicio].alturaListaMeio = listaInstrucaoPrincipal[inicio].alturaListaMeio + alturaItens;
                                              FirebaseFirestore.instance.collection('documentos').doc(listaInstrucaoPrincipal[inicio].listaMeio[meio].idFire).update({
                                                'titulo':listaInstrucaoPrincipal[inicio].listaMeio[meio].controller.text
                                              }).then((value){
                                                adicionarListaFim(inicio,meio,false,'','${inicio+1}.${meio+1}.1','','',0,'',false,true);
                                              });
                                            }else{
                                              await salvarFirebase('documentos',listaInstrucaoPrincipal[inicio].listaMeio[meio].controller.text,
                                                  listaInstrucaoPrincipal[inicio].listaMeio[meio].idDoc,'meio').then((value){
                                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomeTela(emailLogado: widget.emailLogado)));
                                              });
                                            }
                                          }else{
                                            showSnackBar(context, 'Adicione um texto para avançar', Colors.red);
                                          }
                                        },
                                      ),
                                      Container(
                                        // color: Colors.amber,
                                        height: listaInstrucaoPrincipal[inicio].listaMeio[meio].alturaListaFinal,
                                        width: larguraFinalCard,
                                        child: ListView.builder(
                                            // physics: NeverScrollableScrollPhysics(),
                                            itemCount: listaInstrucaoPrincipal[inicio].listaMeio[meio].listaFinal.length,
                                            itemBuilder: (context,fim){
                                              return ItemInstrucao(
                                                acesso_adm: acesso_adm,
                                                controller: listaInstrucaoPrincipal[inicio].listaMeio[meio].listaFinal[fim].controller,
                                                ativarBotaoAdicionarItemLista: listaInstrucaoPrincipal[inicio].listaMeio[meio].listaFinal[fim].checkFinal,
                                                largura: listaInstrucaoPrincipal[inicio].listaMeio[meio].listaFinal[fim].largura,
                                                escrever: listaInstrucaoPrincipal[inicio].listaMeio[meio].listaFinal[fim].escrever,
                                                idFirebase: listaInstrucaoPrincipal[inicio].listaMeio[meio].listaFinal[fim].idFire,
                                                idDocumento: listaInstrucaoPrincipal[inicio].listaMeio[meio].listaFinal[fim].idDoc,
                                                idEsp: listaInstrucaoPrincipal[inicio].listaMeio[meio].listaFinal[fim].idEsp,
                                                nomeProcesso: listaInstrucaoPrincipal[inicio].listaMeio[meio].listaFinal[fim].nomeProcesso,
                                                versao: listaInstrucaoPrincipal[inicio].listaMeio[meio].listaFinal[fim].versao,
                                                emailLogado: widget.emailLogado,
                                                onPressed: ()async{
                                                  if(listaInstrucaoPrincipal[inicio].listaMeio[meio].listaFinal[fim].controller.text.isNotEmpty && listaInstrucaoPrincipal[inicio].listaMeio[meio].listaFinal[fim].controller.text !=''){
                                                    listaInstrucaoPrincipal[inicio].listaMeio[meio].listaFinal[fim].checkFinal = true;
                                                    await salvarFirebase(
                                                        'documentos',listaInstrucaoPrincipal[inicio].listaMeio[meio].listaFinal[fim].controller.text,
                                                        listaInstrucaoPrincipal[inicio].listaMeio[meio].listaFinal[fim].idDoc,'fim').then((value){
                                                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomeTela(emailLogado: widget.emailLogado)));
                                                    });
                                                    setState(() {});
                                                  }else{
                                                    showSnackBar(context, 'Adicione um texto para avançar', Colors.red);
                                                  }
                                                },
                                              );
                                            }
                                        ),
                                      ),
                                    ],
                                  );
                                }
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
      )
    );
  }
}
