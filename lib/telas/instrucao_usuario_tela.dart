import 'package:flutter/material.dart';
import 'package:instrucao_de_processos/modelos/modelo_fotos.dart';
import 'package:instrucao_de_processos/modelos/modelo_videos.dart';
import 'package:instrucao_de_processos/utilidades/variavel_estatica.dart';
import 'package:instrucao_de_processos/widgets/caixa_texto.dart';
import 'package:instrucao_de_processos/widgets/snackBars.dart';
import '../modelos/bad_state_int.dart';
import '../modelos/bad_state_list.dart';
import '../modelos/bad_state_string.dart';
import '../modelos/modelo_analise3.dart';
import '../modelos/modelo_historico.dart';
import '../utilidades/cores.dart';
import '../widgets/appbar_padrao.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/item_etapa3.dart';
import '../widgets/item_etapa3_titulo.dart';
import '../widgets/item_etapa3_um_titulo.dart';
import '../widgets/texto_padrao.dart';

class InstrucaoUsuarioTela extends StatefulWidget {
  String emailLogado;
  String idEsp;
  String idDocumento;
  String documentoReal;

  InstrucaoUsuarioTela({
    required this.emailLogado,
    required this.idEsp,
    required this.idDocumento,
    required this.documentoReal,
  });

  @override
  State<InstrucaoUsuarioTela> createState() => _InstrucaoUsuarioTelaState();
}

class _InstrucaoUsuarioTelaState extends State<InstrucaoUsuarioTela> {

  var controllerComentario = TextEditingController();
  DocumentSnapshot? dadosEspecificacao;
  DocumentSnapshot? dadosEtapas;
  List listaEtapas=[];
  List<ModeloFotos> listaUrlFotosEtapas =[];
  List<ModeloVideos> listaUrlVideosEtapas =[];
  List<ModeloHistorico> listaHistorico = [];

  carregarEdicoes(){
    print('idEsp ${widget.idDocumento}');
    FirebaseFirestore.instance.collection('documentos').doc(widget.idDocumento).get().then((edicao){
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
    print('idEsp');
    print(widget.idEsp);
    FirebaseFirestore.instance.collection('especificacao').doc(widget.idEsp).get().then((dadosEsp){
      dadosEspecificacao = dadosEsp;
      setState((){});
    });
    FirebaseFirestore.instance.collection('etapas').doc(widget.idEsp).get().then((dadosEta){
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
  }

  carregarWidget(int numEtapa, String descricaoEtapa,){
    showDialog(context: context,
        builder: (context){

        double largura = MediaQuery.of(context).size.width;

          return Center(
            child: AlertDialog(
              title: TextoPadrao(texto: 'Reportar Anomalia',cor: Cores.primaria,negrito: FontWeight.bold,),
              content: Container(
                height: 100,
                width: 500,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextoPadrao(
                      texto:'Descreva anomalia encontrada.',
                      cor: Cores.cinzaTextoEscuro,
                      maxLines: 5,
                    ),
                    CaixaTexto(controller: controllerComentario, largura: largura>700?480:300)
                  ],
                ),
              ),
              actions: [
                TextButton(child: TextoPadrao(texto: 'Voltar',cor: Cores.primaria,negrito: FontWeight.bold,),onPressed: ()=>Navigator.pop(context),),
                TextButton(child: TextoPadrao(texto: 'Salvar',cor: Colors.green,negrito: FontWeight.bold,),onPressed: (){
                  if(controllerComentario.text.isNotEmpty){
                    salvarComentario(controllerComentario.text,numEtapa,descricaoEtapa);
                  }else{
                    showSnackBar(context, 'Preencha um texto para salvar', Colors.red);
                  }
                })
              ],
            ),
          );
        });
  }

  salvarComentario(String comentario,int numEtapa, String descricaoEtapa){
    DocumentReference docRef = FirebaseFirestore.instance.collection('comentarios').doc();
    docRef.set({
      'id'              : docRef.id,
      'data'            : DateTime.now(),
      'usuario'         : widget.emailLogado,
      'comentario'      : comentario,
      'idEsp'           : widget.idEsp,
      'fip'             : BadStateInt(dadosEspecificacao, 'numeroFIP'),
      'processo'        : BadStateString(dadosEspecificacao, 'nome'),
      'versao'          : BadStateInt(dadosEspecificacao, 'versao'),
      'numEtapa'        : numEtapa,
      'descricaoEtapa'  : descricaoEtapa,
    }).then((value){
      controllerComentario.clear();
      showSnackBar(context, 'Sua anomalia foi enviada!', Colors.green);
      Navigator.pop(context);
      setState(() {});
    });
  }

  carregarWidgetMidias(int posicaoEtapa, int posicaoAnalise){
    showDialog(context: context,
      builder: (context){
        return Center(
          child: AlertDialog(
            title: TextoPadrao(texto: 'Qual mídia gostaria de adicionar?',cor: Cores.primaria,negrito: FontWeight.bold,),
            content: Container(
              height: 150,
              width: 200,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextoPadrao(
                    texto: 'Fotos adicionadas : ${listaEtapas[posicaoEtapa].listaAnalise[posicaoAnalise].listaFotos.length}',
                    cor: Cores.cinzaTextoEscuro,
                  ),
                  SizedBox(height: 20,),
                  TextoPadrao(
                    texto: 'Videos adicionados : ${listaEtapas[posicaoEtapa].listaAnalise[posicaoAnalise].listaVideos.length}',
                    cor: Cores.cinzaTextoEscuro,
                  ),
                  SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Card(
                        child: TextButton(
                            child: TextoPadrao(texto: 'Foto',cor: Cores.cinzaTextoEscuro,negrito: FontWeight.bold,),
                            onPressed: (){},
                            // onPressed: ()=>escolherImagens(posicaoEtapa,posicaoAnalise)
                        ),
                      ),
                      Card(
                        child: TextButton(
                            child: TextoPadrao(texto: 'Video',cor: Cores.cinzaTextoEscuro,negrito: FontWeight.bold,),
                            onPressed: (){},
                            // onPressed: ()=>escolherVideo(posicaoEtapa,posicaoAnalise)
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(child: TextoPadrao(texto: 'Voltar',cor: Colors.red,negrito: FontWeight.bold,),onPressed: ()=>Navigator.pop(context),),
            ],
          ),
        );
      }
    );
  }

  @override
  void initState() {
    super.initState();
    carregarDados();
    carregarEdicoes();
  }

  @override
  Widget build(BuildContext context) {

    double largura = MediaQuery.of(context).size.width;
    double altura = MediaQuery.of(context).size.height;
    
    return Scaffold(
      backgroundColor: Cores.cinzaClaro,
      appBar: AppBarPadrao(mostrarUsuarios: false, emailLogado: widget.emailLogado),
      body: Container(
        height: altura*1.2 +(listaEtapas.length*360),
        width: largura,
        child: Container(
          width: largura>700?largura * 0.8:largura,
          height: altura*1.2 +(listaEtapas.length*350),
          margin: EdgeInsets.all(largura>700?20:10),
          padding: EdgeInsets.all(largura>700?36:5),
          alignment: Alignment.topLeft,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(15))
          ),
          child: Container(
            width: largura * 0.95,
            child: ListView(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                largura>700?Row(
                  children: [
                    Container(
                        width: largura * 0.45,
                        child: TextoPadrao(texto: 'Instrução de Processos',cor: Cores.primaria,negrito: FontWeight.bold,tamanhoFonte: largura>700?20:14,)
                    ),
                    Container(
                      width: largura * 0.45,
                      child: Row(
                        children: [
                          TextoPadrao(texto: 'Data de criação',cor: Cores.primaria,tamanhoFonte: largura>700?14:10,),
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
                          TextoPadrao(texto: dadosEspecificacao==null?'00/00/0000':VariavelEstatica.mascaraData.format(dadosEspecificacao!['dataVersao'].toDate()),cor: Cores.cinzaTextoEscuro,tamanhoFonte: 14,),
                        ],
                      ),
                    )
                  ],
                ):Column(
                  children: [
                    Container(
                        width: largura,
                        child: TextoPadrao(texto: 'Instrução de Processos',cor: Cores.primaria,negrito: FontWeight.bold,tamanhoFonte: largura>700?20:14,)
                    ),
                    Container(
                      width: largura,
                      child: Row(
                        children: [
                          TextoPadrao(texto: 'Data de criação',cor: Cores.primaria,tamanhoFonte: largura>700?14:10,),
                          SizedBox(width: 10,),
                          TextoPadrao(texto: dadosEspecificacao==null?'00/00/0000':VariavelEstatica.mascaraData.format(dadosEspecificacao!['dataCriacao'].toDate()),cor: Cores.cinzaTextoEscuro,tamanhoFonte: 14,),
                          SizedBox(width: 40,),
                          TextoPadrao(texto: 'Visto',cor: Cores.primaria,tamanhoFonte: 14,),
                          SizedBox(width: 10,),
                          Container(
                              width: largura * 0.3,
                              child: TextoPadrao(texto: BadStateString(dadosEspecificacao, 'visto'),cor: Cores.cinzaTextoEscuro,tamanhoFonte: 10,)
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        TextoPadrao(texto: 'Versão',cor: Cores.primaria,tamanhoFonte: 14,),
                        SizedBox(width: 10,),
                        TextoPadrao(texto: BadStateInt(dadosEspecificacao, 'versao').toString(),cor: Cores.cinzaTextoEscuro,tamanhoFonte: 14,),
                        SizedBox(width: 20,),
                        TextoPadrao(texto: 'Data',cor: Cores.primaria,tamanhoFonte: 14,),
                        SizedBox(width: 10,),
                        TextoPadrao(texto: dadosEspecificacao==null?'00/00/0000':VariavelEstatica.mascaraData.format(dadosEspecificacao!['dataVersao'].toDate()),cor: Cores.cinzaTextoEscuro,tamanhoFonte: 14,),
                      ],
                    )
                  ],
                ),
                largura>700?Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    crossAxisAlignment:CrossAxisAlignment.center ,
                    children: [
                      TextoPadrao(texto: 'N° FIP',cor: Cores.primaria,negrito: FontWeight.bold,tamanhoFonte: 16,),
                      SizedBox(width: 10,),
                      TextoPadrao(texto: widget.documentoReal,cor: Cores.cinzaTextoEscuro,negrito: FontWeight.bold,tamanhoFonte: 16,),
                      SizedBox(width: 40,),
                      TextoPadrao(texto: 'Nome de Processos',cor: Cores.primaria,negrito: FontWeight.bold,tamanhoFonte: 16,),
                      SizedBox(width: 10,),
                      TextoPadrao(texto: BadStateString(dadosEspecificacao, 'nome'),cor: Cores.cinzaTextoEscuro,negrito: FontWeight.bold,tamanhoFonte: 16,),
                    ],
                  ),
                ):Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    crossAxisAlignment:CrossAxisAlignment.center ,
                    children: [
                      Row(
                        children: [
                          TextoPadrao(texto: 'N° FIP',cor: Cores.primaria,negrito: FontWeight.bold,tamanhoFonte: 12,),
                          SizedBox(width: 10,),
                          TextoPadrao(texto: widget.documentoReal,cor: Cores.cinzaTextoEscuro,negrito: FontWeight.bold,tamanhoFonte: 12,),
                        ],
                      ),
                      Row(
                        children: [
                          TextoPadrao(texto: 'Nome de Processos',cor: Cores.primaria,negrito: FontWeight.bold,tamanhoFonte: 12,),
                          SizedBox(width: 10,),
                          Container(
                              width: largura*0.6,
                              child: TextoPadrao(texto: BadStateString(dadosEspecificacao, 'nome'),cor: Cores.cinzaTextoEscuro,negrito: FontWeight.bold,tamanhoFonte: 10,maxLines: 2,)),
                        ],
                      ),
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
                  titulo2: 'Tempo total das etapas',
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
                    height: largura>700?listaEtapas.length*250+80:listaEtapas.length*500+80,
                    child: Column(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          // color: Colors.red,
                          height: largura>700?altura*0.5+listaEtapas.length*300:altura*0.3+listaEtapas.length*350,
                          width: largura * 0.9,
                          child: ListView.builder(
                              // physics: NeverScrollableScrollPhysics(),
                              itemCount: listaEtapas.length,
                              itemBuilder: (context,i){
                                List aux = listaEtapas[i]['listaAnalise'];
                                List<ModeloAnalise3> listaAnalise = [];
                                List fotos = [];
                                List videos = [];
                                int totalEtapa = 0;

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
                                          nomeAnalise: aux[j]['nomeAnalise'],
                                          tempo: aux[j]['tempoAnalise'],
                                          pontoChave: aux[j]['pontoChave'],
                                          urlFotos: fotos,
                                          urlVideos: videos
                                      )
                                  );
                                }

                                return ItemEtapa3(
                                  idEsp: '',
                                  numeroEtapa: listaEtapas[i]['numeroEtapa'],
                                  nomeEtapa: listaEtapas[i]['nomeEtapa'],
                                  tempoTotalEtapa: totalEtapa,
                                  listaAnalise: listaAnalise,
                                  comentario: true,
                                  funcaoComentario: ()=>carregarWidget(listaEtapas[i]['numeroEtapa'], listaEtapas[i]['nomeEtapa'],),
                                  pc: largura>700?true:false,
                                );
                              }
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: largura>700?largura * 0.7:largura,
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
                        width: largura>700?largura * 0.7:largura,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                                width: largura>700?50:35,
                                child: TextoPadrao(texto:'Versão',cor: Cores.primaria,tamanhoFonte: largura>700?14:10,)
                            ),
                            Container(
                                width: largura>700?100:70,
                                child: TextoPadrao(texto:'Data',cor: Cores.primaria,tamanhoFonte: largura>700?14:10,alinhamentoTexto: TextAlign.center,)
                            ),
                            SizedBox(width: largura>700?10:5,),
                            Container(
                                width: largura>700?300:90,
                                child: TextoPadrao(texto:'Resp. Alteração',cor: Cores.primaria,tamanhoFonte: largura>700?14:10,)
                            ),
                            SizedBox(width:largura>700? 10:5,),
                            Container(
                                width: largura>700?largura*0.3:130,
                                child: TextoPadrao(texto:'Razão',cor: Cores.primaria,tamanhoFonte: largura>700?14:10,)
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
                              width: largura>700?largura * 0.7:largura,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                      width: largura>700?50:35,
                                      child: TextoPadrao(
                                        texto: listaHistorico[i].versao.toString(),
                                        // texto: 'versao',
                                        cor: Cores.cinzaTextoEscuro,
                                        tamanhoFonte: largura>700?14:10,
                                        alinhamentoTexto: TextAlign.center,
                                      )
                                  ),
                                  Container(
                                      width: largura>700?100:70,
                                      child: TextoPadrao(
                                        texto: listaHistorico[i].data,
                                        // texto: 'data',
                                        cor: Cores.cinzaTextoEscuro,
                                        tamanhoFonte: largura>700?14:10,
                                        alinhamentoTexto: TextAlign.center,
                                      )
                                  ),
                                  SizedBox(width: largura>700? 10:5,),
                                  Container(
                                      width: largura>700?300:90,
                                      child: TextoPadrao(texto:listaHistorico[i].responsavel,cor: Cores.cinzaTextoEscuro,tamanhoFonte: largura>700?14:10,)
                                  ),
                                  SizedBox(width: largura>700? 10:5,),
                                  Container(
                                      width: largura>700?largura*0.3:130,
                                      child: TextoPadrao(texto:listaHistorico[i].alteracao,cor: Cores.cinzaTextoEscuro,tamanhoFonte: largura>700?14:10,maxLines: 3,)
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
