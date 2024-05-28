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
import '../utilidades/cores.dart';
import '../widgets/appbar_padrao.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/item_etapa3.dart';
import '../widgets/item_etapa3_titulo.dart';
import '../widgets/item_etapa3_um_titulo.dart';
import '../widgets/texto_padrao.dart';
import 'package:video_player/video_player.dart';

class InstrucaoUsuarioTela extends StatefulWidget {
  String emailLogado;
  String idEsp;

  InstrucaoUsuarioTela({
    required this.emailLogado,
    required this.idEsp,
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

  carregarDados(){
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
                    CaixaTexto(controller: controllerComentario, largura: 480)
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Cores.cinzaClaro,
      appBar: AppBarPadrao(mostrarUsuarios: false, emailLogado: widget.emailLogado),
      body: SingleChildScrollView(
        child: Container(
          height: VariavelEstatica.altura*0.9+(listaEtapas.length*250),
          width: VariavelEstatica.largura,
          child: Container(
            width: VariavelEstatica.largura * 0.8,
            height: VariavelEstatica.altura * 0.65,
            margin: EdgeInsets.all(20),
            padding: EdgeInsets.all(36),
            alignment: Alignment.topLeft,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(15))
            ),
            child: Container(
              width: VariavelEstatica.largura * 0.95,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                          width: VariavelEstatica.largura * 0.45,
                          child: TextoPadrao(texto: 'Instrução de Processos',cor: Cores.primaria,negrito: FontWeight.bold,tamanhoFonte: 20,)
                      ),
                      Container(
                        width: VariavelEstatica.largura * 0.45,
                        child: Row(
                          children: [
                            TextoPadrao(texto: 'Data de criação',cor: Cores.primaria,tamanhoFonte: 14,),
                            SizedBox(width: 10,),
                            TextoPadrao(texto: dadosEspecificacao==null?'00/00/0000':VariavelEstatica.mascaraData.format(dadosEspecificacao!['dataCriacao'].toDate()),cor: Cores.cinzaTextoEscuro,tamanhoFonte: 14,),
                            SizedBox(width: 40,),
                            TextoPadrao(texto: 'Visto',cor: Cores.primaria,tamanhoFonte: 14,),
                            SizedBox(width: 10,),
                            Container(
                                width: VariavelEstatica.largura * 0.1,
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
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      crossAxisAlignment:CrossAxisAlignment.center ,
                      children: [
                        TextoPadrao(texto: 'N° FIP',cor: Cores.primaria,negrito: FontWeight.bold,tamanhoFonte: 16,),
                        SizedBox(width: 10,),
                        TextoPadrao(texto: BadStateInt(dadosEspecificacao, 'numeroFIP').toString(),cor: Cores.cinzaTextoEscuro,negrito: FontWeight.bold,tamanhoFonte: 16,),
                        SizedBox(width: 40,),
                        TextoPadrao(texto: 'Nome de Processos',cor: Cores.primaria,negrito: FontWeight.bold,tamanhoFonte: 16,),
                        SizedBox(width: 10,),
                        TextoPadrao(texto: BadStateString(dadosEspecificacao, 'nome'),cor: Cores.cinzaTextoEscuro,negrito: FontWeight.bold,tamanhoFonte: 16,),
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
                  ),
                  ItemEtapaUmTitulo(dadosEspecificacao: dadosEspecificacao,item: 'ferramentas',titulo: 'Ferramentas utilizadas'),
                  Divider(),
                  ItemEtapa3Titulo(
                    dadosEspecificacao: dadosEspecificacao,
                    item1: 'materiaPrima',
                    item2: 'licenca_qualificacoes',
                    titulo1: 'Matéria-prima utilizada',
                    titulo2: 'Tempo total das etapas',
                    dadoString1: false,
                  ),
                  ItemEtapa3Titulo(
                    dadosEspecificacao: dadosEspecificacao,
                    item1: 'espeficicacao',
                    item2: 'prazo',
                    titulo1: 'Especificações',
                    titulo2: 'Prazo de aprendizagem',
                  ),
                  ItemEtapa3Titulo(
                    dadosEspecificacao: dadosEspecificacao,
                    item1: 'esp_maquina',
                    item2: 'licenca_qualificacoes',
                    titulo1: 'Especificações máquina',
                    titulo2: 'Licenças ou qualificações',
                  ),
                  Divider(),
                  Container(
                    height: listaEtapas.length*300,
                    child: listaEtapas.isEmpty?Container():Container(
                      height: listaEtapas.length*250+80,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: listaEtapas.length*300,
                            width: VariavelEstatica.largura * 0.7,
                            child: ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: listaEtapas.length,
                                itemBuilder: (context,i){
                                  List aux = listaEtapas[i]['listaAnalise'];
                                  List<ModeloAnalise3> listaAnalise = [];
                                  List fotos = [];
                                  List videos = [];
        
                                  for(int j = 0; aux.length > j ; j++){
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
                                    numeroEtapa: listaEtapas[i]['numeroEtapa'],
                                    nomeEtapa: listaEtapas[i]['nomeEtapa'],
                                    tempoTotalEtapa: listaEtapas[i]['tempoTotalEtapaMinutos'],
                                    listaAnalise: listaAnalise,
                                    comentario: true,
                                    funcaoComentario: ()=>carregarWidget(listaEtapas[i]['numeroEtapa'], listaEtapas[i]['nomeEtapa'],),
                                  );
                                }
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
