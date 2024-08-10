import 'package:flutter/material.dart';
import 'package:instrucao_de_processos/modelos/bad_state_int.dart';
import 'package:instrucao_de_processos/modelos/bad_state_list.dart';
import 'package:instrucao_de_processos/modelos/bad_state_string.dart';
import 'package:instrucao_de_processos/modelos/modelo_analise3.dart';
import 'package:instrucao_de_processos/modelos/modelo_historico.dart';
import 'package:instrucao_de_processos/telas/home_tela.dart';
import 'package:instrucao_de_processos/widgets/item_etapa3.dart';
import 'package:instrucao_de_processos/widgets/item_etapa3_titulo.dart';
import '../modelos/modelo_fotos.dart';
import '../modelos/modelo_videos.dart';
import '../utilidades/cores.dart';
import '../utilidades/variavel_estatica.dart';
import '../widgets/appbar_padrao.dart';
import '../widgets/botao_padrao_nova_instrucao.dart';
import '../widgets/item_etapa3_um_titulo.dart';
import '../widgets/nivel_etapa2.dart';
import '../widgets/texto_padrao.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InstrucaoTerceiraEtapaTela extends StatefulWidget {
  String emailLogado;
  String idEtapa;
  String FIP;
  String idFirebase;

  InstrucaoTerceiraEtapaTela({
    required this.emailLogado,
    required this.idEtapa,
    required this.FIP,
    required this.idFirebase,
  });

  @override
  State<InstrucaoTerceiraEtapaTela> createState() =>_InstrucaoTerceiraEtapaTelaState();
}

class _InstrucaoTerceiraEtapaTelaState extends State<InstrucaoTerceiraEtapaTela> {
  bool carregando = false;
  DocumentSnapshot? dadosEspecificacao;
  DocumentSnapshot? dadosEtapas;
  List listaEtapas=[];
  String idDoc = '';
  List<ModeloHistorico> listaHistorico = [];
  List<ModeloFotos> listaUrlFotosEtapas =[];
  List<ModeloVideos> listaUrlVideosEtapas =[];

  carregarEdicoes(){
    FirebaseFirestore.instance.collection('documentos').doc(widget.idFirebase).get().then((edicao){
      List edicoes = BadStateList(edicao, 'listaIdEsp');
      for(int i = 0; edicoes.length > i; i++){
        FirebaseFirestore.instance.collection('etapas').doc(edicoes[i]).get().then((etapa){
          FirebaseFirestore.instance.collection('usuarios').doc(BadStateString(etapa,'idUsuario')).get().then((usuario){
            listaHistorico.add(
                ModeloHistorico(
                    versao: i+1,
                    data: VariavelEstatica.mascaraData.format(etapa!['dataCriacao'].toDate()),
                    responsavel: BadStateString(usuario,'nome'),
                    alteracao: BadStateString(etapa, 'alteracao')
                )
            );
            setState(() {});
          });
        });
      }
    });
  }
  
  carregarDados(){
    print('idEtapa');
    print(widget.idEtapa);
    FirebaseFirestore.instance.collection('especificacao').doc(widget.idEtapa).get().then((dadosEsp){
      dadosEspecificacao = dadosEsp;
      setState((){});
    });
    FirebaseFirestore.instance.collection('etapas').doc(widget.idEtapa).get().then((dadosEta){
      dadosEtapas = dadosEta;
      listaEtapas = BadStateList(dadosEta, 'listaEtapa');
      for(int posicaoEtapa = 0; listaEtapas.length > posicaoEtapa; posicaoEtapa++){
        List listaAnalise = listaEtapas[posicaoEtapa]['listaAnalise'];

        for(int posicaoAnalise = 0; listaAnalise.length > posicaoAnalise; posicaoAnalise++){
          if(listaAnalise[posicaoAnalise]['j']==posicaoAnalise){

            listaUrlFotosEtapas.add(
                ModeloFotos(
                    posicaoEtapa: posicaoEtapa,
                    posicaoAnalise: posicaoAnalise,
                    url: BadStateList(dadosEta, 'fotos_etapa${posicaoEtapa}_analise${posicaoAnalise}')
                )
            );

            listaUrlVideosEtapas.add(
                ModeloVideos(
                    posicaoEtapa: posicaoEtapa,
                    posicaoAnalise: posicaoAnalise,
                    urlVideo: BadStateList(dadosEta, 'videos_etapa${posicaoEtapa}_analise${posicaoAnalise}')
                )
            );
          }
        }
      }
      setState((){});
    });
    FirebaseFirestore.instance.collection('documentos').where('listaIdEsp',arrayContainsAny: [widget.idEtapa]).get().then((dadosDocumento){
      idDoc = dadosDocumento.docs[0].id;
    });
  }
  DateTime converterData(Timestamp timestamp) {
    return timestamp.toDate();
  }
  
  @override
  void initState() {
    super.initState();
    carregarEdicoes();
    carregarDados();
  }

  @override
  Widget build(BuildContext context) {

    double largura = MediaQuery.of(context).size.width;
    double altura = MediaQuery.of(context).size.height;
    
    return Scaffold(
        backgroundColor: Cores.cinzaClaro,
        appBar: carregando? null: AppBarPadrao(mostrarUsuarios: false, emailLogado: widget.emailLogado),
        body: Container(
            height: altura*1.1+(listaEtapas.length*360),
            width: largura,
            child: ListView(
                children: [
                  NivelEtapa(nivel: 3,pc: largura>700?true:false,),
                  Container(
                    width:  largura>700?largura * 0.8:largura*0.95,
                    height: altura*1.2 +(listaEtapas.length*350),
                    margin: EdgeInsets.all( largura>700?20:5),
                    padding: EdgeInsets.all( largura>700?36:5),
                    alignment: Alignment.topLeft,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(15))
                    ),
                    child: Container(
                      width: largura * 0.95,
                      child: dadosEspecificacao==null?Container():Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          largura>700?Row(
                            children: [
                              Container(
                                width: largura * 0.45,
                                child: TextoPadrao(texto: 'Instrução de Processos',cor: Cores.primaria,negrito: FontWeight.bold,tamanhoFonte: 20,)
                              ),
                              Container(
                                width: largura * 0.45,
                                child: Row(
                                  children: [
                                    TextoPadrao(texto: 'Data de criação',cor: Cores.primaria,tamanhoFonte: 14,),
                                    SizedBox(width: 10,),
                                    TextoPadrao(texto: dadosEspecificacao==null?'00/00/0000':VariavelEstatica.mascaraData.format(dadosEspecificacao!['dataCriacao'].toDate()),cor: Cores.cinzaTextoEscuro,tamanhoFonte: 14,),
                                    SizedBox(width: 40,),
                                    TextoPadrao(texto: 'Visto',cor: Cores.primaria,tamanhoFonte: 14,),
                                    SizedBox(width: 10,),
                                    Container(
                                      width: largura * 0.1,
                                      child: TextoPadrao(texto: BadStateString(dadosEspecificacao, 'visto'),cor: Cores.cinzaTextoEscuro,tamanhoFonte: 14,)
                                    ),
                                    SizedBox(width: 40,),
                                    TextoPadrao(texto: 'Versão',cor: Cores.primaria,tamanhoFonte: 14,),
                                    SizedBox(width: 10,),
                                    TextoPadrao(texto: BadStateInt(dadosEspecificacao, 'versao').toString(),cor: Cores.cinzaTextoEscuro,tamanhoFonte: 14,),
                                    SizedBox(width: 20,),
                                    TextoPadrao(texto: 'Data',cor: Cores.primaria,tamanhoFonte: 14,),
                                    SizedBox(width: 10,),
                                    TextoPadrao(texto: VariavelEstatica.mascaraData.format(DateTime.now()),cor: Cores.cinzaTextoEscuro,tamanhoFonte: 14,),
                                  ],
                                ),
                              )
                            ],
                          ):Column(
                            children: [
                              Container(
                                  width: largura * 0.8,
                                  child: TextoPadrao(texto: 'Instrução de Processos',cor: Cores.primaria,negrito: FontWeight.bold,tamanhoFonte: 14,)
                              ),
                              Container(
                                width: largura*0.9,
                                child: Row(
                                  children: [
                                    TextoPadrao(texto: 'Data de criação',cor: Cores.primaria,tamanhoFonte: 12,),
                                    SizedBox(width: 5,),
                                    TextoPadrao(texto: dadosEspecificacao==null?'00/00/0000':VariavelEstatica.mascaraData.format(dadosEspecificacao!['dataCriacao'].toDate()),cor: Cores.cinzaTextoEscuro,tamanhoFonte: 12,),
                                    SizedBox(width: 10,),
                                    TextoPadrao(texto: 'Visto',cor: Cores.primaria,tamanhoFonte: 14,),
                                    SizedBox(width: 5,),
                                    Container(
                                      child: TextoPadrao(texto: BadStateString(dadosEspecificacao, 'visto'),cor: Cores.cinzaTextoEscuro,tamanhoFonte: 12,)
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: largura * 0.9,
                                child: Row(
                                  children: [
                                    TextoPadrao(texto: 'Versão',cor: Cores.primaria,tamanhoFonte: 14,),
                                    SizedBox(width: 10,),
                                    TextoPadrao(texto: BadStateInt(dadosEspecificacao, 'versao').toString(),cor: Cores.cinzaTextoEscuro,tamanhoFonte: 14,),
                                    SizedBox(width: 50,),
                                    TextoPadrao(texto: 'Data',cor: Cores.primaria,tamanhoFonte: 14,),
                                    SizedBox(width: 10,),
                                    TextoPadrao(texto: VariavelEstatica.mascaraData.format(DateTime.now()),cor: Cores.cinzaTextoEscuro,tamanhoFonte: 14,),
                                  ],
                                ),
                              )
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: largura>700?Row(
                              crossAxisAlignment:CrossAxisAlignment.center ,
                              children: [
                                TextoPadrao(texto: 'N° FIP',cor: Cores.primaria,negrito: FontWeight.bold,tamanhoFonte: 16,),
                                SizedBox(width: 10,),
                                TextoPadrao(texto: widget.FIP,cor: Cores.cinzaTextoEscuro,negrito: FontWeight.bold,tamanhoFonte: 16,),
                                SizedBox(width: 40,),
                                TextoPadrao(texto: 'Nome de Processos',cor: Cores.primaria,negrito: FontWeight.bold,tamanhoFonte: 16,),
                                SizedBox(width: 10,),
                                TextoPadrao(texto: BadStateString(dadosEspecificacao, 'nome'),cor: Cores.cinzaTextoEscuro,negrito: FontWeight.bold,tamanhoFonte: 16,),
                              ],
                            ):Column(
                              crossAxisAlignment:CrossAxisAlignment.center ,
                              children: [
                                Row(
                                  children: [
                                    TextoPadrao(texto: 'N° FIP',cor: Cores.primaria,negrito: FontWeight.bold,tamanhoFonte: 12,),
                                    SizedBox(width: 10,),
                                    TextoPadrao(texto: widget.FIP,cor: Cores.cinzaTextoEscuro,negrito: FontWeight.bold,tamanhoFonte: 12,),
                                  ],
                                ),
                                Row(
                                 children: [
                                   TextoPadrao(texto: 'Nome de Processos',cor: Cores.primaria,negrito: FontWeight.bold,tamanhoFonte: 12,),
                                   SizedBox(width: 10,),
                                   TextoPadrao(texto: BadStateString(dadosEspecificacao, 'nome'),cor: Cores.cinzaTextoEscuro,negrito: FontWeight.bold,tamanhoFonte: 12,),
                                 ],
                                )
                              ],
                            ),
                          ),
                          Divider(),
                          ItemEtapa3Titulo(
                            dadosEspecificacao: dadosEspecificacao,
                            item1: 'epi',
                            item2: 'maquina',
                            titulo1: 'EPI Necessário',
                            titulo2: 'Máquina',
                            dadoString1: false,
                            pc: largura>700?true:false,
                          ),
                          ItemEtapaUmTitulo(dadosEspecificacao: dadosEspecificacao,item: 'ferramentas',titulo: 'Ferramentas utilizadas',pc:largura>700?true:false),
                          Divider(),
                          ItemEtapa3Titulo(
                            dadosEspecificacao: dadosEspecificacao,
                            item1: 'materiaPrima',
                            item2: 'tempoTotal',
                            titulo1: 'Matéria-prima utilizada',
                            titulo2: 'Tempo total das etapas ( min ) ',
                            dadoString1: false,
                            dadoString2: false,
                            dadosInt: true,
                            pc: largura>700?true:false,
                          ),
                          ItemEtapa3Titulo(
                            dadosEspecificacao: dadosEspecificacao,
                            item1: 'espeficicacao',
                            item2: 'prazo',
                            titulo1: 'Especificações',
                            titulo2: 'Prazo de aprendizagem',
                            pc: largura>700?true:false,
                          ),
                          ItemEtapa3Titulo(
                            dadosEspecificacao: dadosEspecificacao,
                            item1: 'esp_maquina',
                            item2: 'licenca_qualificacoes',
                            titulo1: 'Especificações máquina',
                            titulo2: 'Licenças ou qualificações',
                            pc: largura>700?true:false,
                          ),
                          Divider(),
                          Container(
                            height: altura*0.9+(listaEtapas.length*290),
                            child: listaEtapas.isEmpty?Container():Container(
                              height: altura*0.9+(listaEtapas.length*290),
                              child: ListView(
                                physics: NeverScrollableScrollPhysics(),
                                // crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: altura*0.7+(listaEtapas.length*250),
                                    width: largura * 0.7,
                                    child: ListView.builder(
                                      // physics: NeverScrollableScrollPhysics(),
                                        itemCount: listaEtapas.length,
                                        itemBuilder: (context,i){

                                          List aux = listaEtapas[i]['listaAnalise'];
                                          List<ModeloAnalise3> listaAnalise = [];
                                          int totalEtapa = 0;

                                          List fotos = [];
                                          List videos = [];

                                          for(int j = 0; aux.length > j ; j++){
                                            totalEtapa = int.parse(aux[j]['tempoAnalise'])+totalEtapa;
                                            for(int posicaoAnalise = 0; listaUrlFotosEtapas.length > posicaoAnalise ; posicaoAnalise++){
                                              if(listaUrlFotosEtapas[posicaoAnalise].posicaoEtapa==i && listaUrlFotosEtapas[posicaoAnalise].posicaoAnalise==j){
                                                fotos = listaUrlFotosEtapas[posicaoAnalise].url;
                                                videos = listaUrlVideosEtapas[posicaoAnalise].urlVideo;
                                              }
                                            }

                                            listaAnalise.add(
                                                ModeloAnalise3(
                                                    imagemSelecionada: aux[j]['imagemSelecionada'],
                                                    numeroAnalise: aux[j]['numeroAnalise'],
                                                    urlFotos: fotos,
                                                    urlVideos: videos,
                                                    nomeAnalise: aux[j]['nomeAnalise'],
                                                    tempo: aux[j]['tempoAnalise'],
                                                    pontoChave: aux[j]['pontoChave']
                                                )
                                            );
                                          }

                                          return ItemEtapa3(
                                            idEsp: BadStateString(dadosEtapas!,'idEsp'),
                                            numeroEtapa: listaEtapas[i]['numeroEtapa'],
                                            nomeEtapa: listaEtapas[i]['nomeEtapa'],
                                            tempoTotalEtapa: totalEtapa,
                                            listaAnalise: listaAnalise,
                                            funcaoComentario: null,
                                            pc: largura>700?true:false,
                                          );
                                        }
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 6),
                                    child: TextoPadrao(texto: 'Observações Gerais/ O que é proibido e porque?',cor: Cores.primaria,negrito: FontWeight.bold,tamanhoFonte: 14,),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 6),
                                    child: TextoPadrao(texto: BadStateString(dadosEtapas, 'observacoes'),cor: Cores.cinzaTextoEscuro,tamanhoFonte: 12,maxLines: 5,),
                                  ),
                                  Container(
                                      width: largura * 0.7,
                                      padding: EdgeInsets.all(10),
                                      margin: EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(color: Cores.cinzaTexto),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        TextoPadrao(texto: 'Histórico',cor: Cores.primaria,negrito: FontWeight.bold,tamanhoFonte: 16,),
                                        Container(
                                          width:  largura>700?largura * 0.7:largura * 0.9,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Container(
                                                  width:  largura>700?50:35,
                                                  child: TextoPadrao(texto:'Versão',cor: Cores.primaria,tamanhoFonte: largura>700?14:12,)
                                              ),
                                              Container(
                                                  width: largura>700?100:50,
                                                  child: TextoPadrao(texto:'Data',cor: Cores.primaria,tamanhoFonte: largura>700?14:12,alinhamentoTexto: TextAlign.center,)
                                              ),
                                              SizedBox(width: largura>700?10:5,),
                                              Container(
                                                  width:  largura>700?300:90,
                                                  child: TextoPadrao(texto:'Resp. Alteração',cor: Cores.primaria,tamanhoFonte: largura>700?14:12,)
                                              ),
                                              SizedBox(width: largura>700?10:5,),
                                              Container(
                                                  width:  largura>700?largura*0.3:largura*0.25,
                                                  child: TextoPadrao(texto:'Razão',cor: Cores.primaria,tamanhoFonte: largura>700?14:12,)
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          height: listaHistorico.length*30,
                                          child: ListView.builder(
                                            itemCount: listaHistorico.length,
                                            itemBuilder: (context,i){
                                              return Container(
                                                width: largura * 0.9,
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Container(
                                                        width:  largura>700?50:35,
                                                        child: TextoPadrao(
                                                          texto: listaHistorico[i].versao.toString(),
                                                          // texto: 'versao',
                                                          cor: Cores.cinzaTextoEscuro,
                                                          tamanhoFonte: 14,
                                                          alinhamentoTexto: TextAlign.center,
                                                        )
                                                    ),
                                                    Container(
                                                        width: largura>700?100:50,
                                                        child: TextoPadrao(
                                                          texto: listaHistorico[i].data,
                                                          // texto: 'data',
                                                          cor: Cores.cinzaTextoEscuro,
                                                          tamanhoFonte: largura>700?14:10,
                                                          alinhamentoTexto: TextAlign.center,
                                                        )
                                                    ),
                                                    SizedBox(width: largura>700?10:5,),
                                                    Container(
                                                        width:  largura>700?300:90,
                                                        child: TextoPadrao(texto:listaHistorico[i].responsavel,cor: Cores.cinzaTextoEscuro,tamanhoFonte:  largura>700?14:10,)
                                                    ),
                                                    SizedBox(width: largura>700?10:5,),
                                                    Container(
                                                        width: largura>700?largura*0.3:largura*0.25,
                                                        child: TextoPadrao(texto:listaHistorico[i].alteracao,cor: Cores.cinzaTextoEscuro,tamanhoFonte: largura>700?14:10,)
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      BotaoPadraoNovaInstrucao(
                                        texto: 'Voltar',
                                        largura: 150,
                                        margemVertical: 5,
                                        corBotao: Colors.black,
                                        onPressed: ()=>Navigator.pop(context),
                                      ),
                                      SizedBox(width: 10,),
                                      BotaoPadraoNovaInstrucao(
                                        texto: 'Finalizar',
                                        largura: 150,
                                        margemVertical: 5,
                                        onPressed: (){

                                          print('autorizado');
                                          print('idDoc');
                                          print(idDoc);

                                          FirebaseFirestore.instance.collection('documentos').doc(idDoc).update({
                                            'situacao':'autorizado'
                                          }).then((value) =>
                                              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                                                  builder: (context)=>HomeTela(emailLogado: widget.emailLogado)),(route) => false,
                                              ));
                                        }
                                      ),
                                      SizedBox(width: largura*0.025,),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ]
            )
        )
    );
  }
}
