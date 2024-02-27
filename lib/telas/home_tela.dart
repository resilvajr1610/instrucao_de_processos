import 'package:flutter/material.dart';
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
  double alturaListaInicio = 75;

  iniciarListaPrincipal(int inicio){
    listaInstrucaoPrincipal.add(
      ModeloInstrucaoLista_1_0_0(
        idDocumento: '${inicio+1}.0.0',
        idFirebase: '',
        controller: TextEditingController(text: 'inicio'),
        ativarBotaoAdicionarItemLista: false,
        escrever: true,
        largura: 450,
        listaMeio: [],
        alturaListaMeio: 0
      )
    );
    setState(() {});
  }

  adicionarListaMeio(int inicio, bool addPrincipal){
    List<ModeloInstrucaoLista_1_1_0> listaMeio = [];
    listaMeio.add(
      ModeloInstrucaoLista_1_1_0(
        idFirebase: '',
        idDocumento:'${inicio+1}.1.0',
        controller: TextEditingController(text: 'meio'),
        ativarBotaoAdicionarItemLista: false,
        largura: larguraMeioCaixaTexto,
        escrever: true,
        listaFinal: [],
        alturaListaFinal: 0
      )
    );
    listaInstrucaoPrincipal[inicio].listaMeio = listaMeio;
    listaInstrucaoPrincipal[inicio].escrever = false;
    listaInstrucaoPrincipal[inicio].ativarBotaoAdicionarItemLista = true;

    if(addPrincipal){
      alturaListaInicio = alturaListaInicio + alturaItens + alturaItens;
      listaInstrucaoPrincipal[inicio].alturaListaMeio = listaInstrucaoPrincipal[inicio].alturaListaMeio + alturaItens;
      iniciarListaPrincipal(listaInstrucaoPrincipal.length);
    }
    setState(() {});
  }

  adicionarListaFinal(int inicio, int meio,bool addMeio){
    List<ModeloInstrucaoLista_1_1_1> listaFinal = [];
    listaFinal.add(
      ModeloInstrucaoLista_1_1_1(
        idFirebase: '',
        idDocumento:'${inicio+1}.${meio+1}.1',
        controller: TextEditingController(text: 'final'),
        checkFinal: false,
        largura: larguraFinalCaixaTexto,
        escrever: true
      )
    );
    listaInstrucaoPrincipal[inicio].listaMeio[meio].listaFinal = listaFinal;
    listaInstrucaoPrincipal[inicio].listaMeio[meio].ativarBotaoAdicionarItemLista = true;
    listaInstrucaoPrincipal[inicio].listaMeio[meio].escrever = false;
    listaInstrucaoPrincipal[inicio].escrever = false;
    listaInstrucaoPrincipal[inicio].ativarBotaoAdicionarItemLista = true;
    alturaListaFinal = alturaListaFinal + alturaItens;
    if(addMeio){
      alturaListaInicio = alturaListaInicio +alturaItens + alturaItens;
      listaInstrucaoPrincipal[inicio].alturaListaMeio = listaInstrucaoPrincipal[inicio].alturaListaMeio+ alturaItens + alturaItens;
      listaInstrucaoPrincipal[inicio].listaMeio[meio].alturaListaFinal = listaInstrucaoPrincipal[inicio].listaMeio[meio].alturaListaFinal + alturaItens;
      listaInstrucaoPrincipal[inicio].listaMeio.add(
          ModeloInstrucaoLista_1_1_0(
              idFirebase: '',
              idDocumento: '${inicio+1}.${meio+2}.0',
              controller: TextEditingController(text: 'meio'),
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

  Future<String> obterNovoId(String colecao, String titulo, String idDocumento, String nivel) async {
    DocumentReference docRef = FirebaseFirestore.instance.collection(colecao).doc();
    await docRef.set({
      'titulo'      : titulo,
      'idDocumento$nivel' : idDocumento,
      'idFirebase'  : docRef.id
    });
    return docRef.id;
  }

  @override
  void initState() {
    super.initState();
    iniciarListaPrincipal(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Cores.cinzaClaro,
      appBar: AppBarPadrao(showUsuarios: true,emailLogado: widget.emailLogado),
      body: Container(
        width: VariavelEstatica.largura,
        height: VariavelEstatica.altura,
        padding: EdgeInsets.symmetric(vertical: 32,horizontal: 60),
        child: Card(
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
                              controller: listaInstrucaoPrincipal[inicio].controller,
                              ativarBotaoAdicionarItemLista: listaInstrucaoPrincipal[inicio].ativarBotaoAdicionarItemLista,
                              largura: listaInstrucaoPrincipal[inicio].largura,
                              escrever: listaInstrucaoPrincipal[inicio].escrever,
                              idFirebase: listaInstrucaoPrincipal[inicio].idFirebase,
                              idDocumento: listaInstrucaoPrincipal[inicio].idDocumento,
                              onPressed: ()async{
                                if(listaInstrucaoPrincipal[inicio].controller.text.isNotEmpty){
                                  String idFirebase = await obterNovoId('documentos',listaInstrucaoPrincipal[inicio].controller.text,listaInstrucaoPrincipal[inicio].idDocumento,'inicio');
                                  listaInstrucaoPrincipal[inicio].idFirebase = idFirebase;
                                  adicionarListaMeio(inicio,true);
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
                                        controller: listaInstrucaoPrincipal[inicio].listaMeio[meio].controller,
                                        ativarBotaoAdicionarItemLista: listaInstrucaoPrincipal[inicio].listaMeio[meio].ativarBotaoAdicionarItemLista,
                                        largura: listaInstrucaoPrincipal[inicio].listaMeio[meio].largura,
                                        escrever: listaInstrucaoPrincipal[inicio].listaMeio[meio].escrever,
                                        idFirebase: listaInstrucaoPrincipal[inicio].listaMeio[meio].idFirebase,
                                        idDocumento: listaInstrucaoPrincipal[inicio].listaMeio[meio].idDocumento,
                                        onPressed: ()async{
                                          if(listaInstrucaoPrincipal[inicio].listaMeio[meio].controller.text.isNotEmpty){
                                            String idFirebase = await obterNovoId('documentos',listaInstrucaoPrincipal[inicio].listaMeio[meio].controller.text,
                                                listaInstrucaoPrincipal[inicio].listaMeio[meio].idDocumento,'meio');

                                            listaInstrucaoPrincipal[inicio].listaMeio[meio].idFirebase = idFirebase;
                                            adicionarListaFinal(inicio,meio,true);
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
                                                controller: listaInstrucaoPrincipal[inicio].listaMeio[meio].listaFinal[fim].controller,
                                                ativarBotaoAdicionarItemLista: listaInstrucaoPrincipal[inicio].listaMeio[meio].listaFinal[fim].checkFinal,
                                                largura: listaInstrucaoPrincipal[inicio].listaMeio[meio].listaFinal[fim].largura,
                                                escrever: listaInstrucaoPrincipal[inicio].listaMeio[meio].listaFinal[fim].escrever,
                                                idFirebase: listaInstrucaoPrincipal[inicio].listaMeio[meio].listaFinal[fim].idFirebase,
                                                idDocumento: listaInstrucaoPrincipal[inicio].listaMeio[meio].listaFinal[fim].idDocumento,
                                                onPressed: ()async{
                                                  if(listaInstrucaoPrincipal[inicio].listaMeio[meio].listaFinal[fim].controller.text.isNotEmpty){
                                                    listaInstrucaoPrincipal[inicio].listaMeio[meio].listaFinal[fim].checkFinal = true;
                                                    String idFirebase = await obterNovoId(
                                                        'documentos',listaInstrucaoPrincipal[inicio].listaMeio[meio].listaFinal[fim].controller.text,
                                                        listaInstrucaoPrincipal[inicio].listaMeio[meio].listaFinal[fim].idDocumento,'fim');
                                                    listaInstrucaoPrincipal[inicio].listaMeio[meio].listaFinal[fim].idFirebase = idFirebase;
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
