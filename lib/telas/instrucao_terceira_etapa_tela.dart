import 'package:flutter/material.dart';
import 'package:instrucao_de_processos/modelos/bad_state_int.dart';
import 'package:instrucao_de_processos/modelos/bad_state_list.dart';
import 'package:instrucao_de_processos/modelos/bad_state_string.dart';
import 'package:instrucao_de_processos/modelos/modelo_analise3.dart';
import 'package:instrucao_de_processos/telas/home_tela.dart';
import 'package:instrucao_de_processos/widgets/item_etapa3.dart';
import 'package:instrucao_de_processos/widgets/item_etapa3_titulo.dart';
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

  InstrucaoTerceiraEtapaTela({
    required this.emailLogado,
    required this.idEtapa,
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

  carregarDados(){
    FirebaseFirestore.instance.collection('especificacao').doc(widget.idEtapa).get().then((dadosEsp){
      dadosEspecificacao = dadosEsp;
      setState((){});
    });
    FirebaseFirestore.instance.collection('etapas').doc(widget.idEtapa).get().then((dadosEta){
      dadosEtapas = dadosEta;
      listaEtapas = BadStateList(dadosEta, 'listaEtapa');
      setState((){});
    });
    FirebaseFirestore.instance.collection('documentos').where('idEsp',isEqualTo: widget.idEtapa).get().then((dadosDocumento){
      idDoc = dadosDocumento.docs[0].id;
      print(dadosDocumento.docs[0].id);
    });
  }
  DateTime converterData(Timestamp timestamp) {
    return timestamp.toDate();
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
        appBar: carregando? null: AppBarPadrao(mostrarUsuarios: false, emailLogado: widget.emailLogado),
        body: Container(
            height: VariavelEstatica.altura,
            width: VariavelEstatica.largura,
            child: ListView(
                children: [
                  NivelEtapa(nivel: 3),
                  Container(
                    width: VariavelEstatica.largura * 0.8,
                    height: VariavelEstatica.altura * 0.7,
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
                                    TextoPadrao(texto: VariavelEstatica.mascaraData.format(DateTime.now()),cor: Cores.cinzaTextoEscuro,tamanhoFonte: 14,),
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
                            height: VariavelEstatica.altura*0.38,
                            child: SingleChildScrollView(
                              child: listaEtapas.isEmpty?Container():Container(
                                height: listaEtapas.length*250+80,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: listaEtapas.length*200,
                                      width: VariavelEstatica.largura * 0.7,
                                      child: ListView.builder(
                                          itemCount: listaEtapas.length,
                                          itemBuilder: (context,i){

                                            List aux = listaEtapas[i]['listaAnalise'];
                                            List<ModeloAnalise3> listaAnalise = [];

                                            for(int j = 0; aux.length > j ; j++){
                                              listaAnalise.add(
                                                  ModeloAnalise3(
                                                      imagemSelecionada: aux[j]['imagemSelecionada'],
                                                      numeroAnalise: aux[j]['numeroAnalise'],
                                                      urlFotos: [],
                                                      urlVideos: [],
                                                      nomeAnalise: aux[j]['nomeAnalise'],
                                                      tempo: aux[j]['tempoAnalise'],
                                                      pontoChave: aux[j]['pontoChave']
                                                  )
                                              );
                                            }

                                            return ItemEtapa3(
                                              numeroEtapa: listaEtapas[i]['numeroEtapa'],
                                              nomeEtapa: listaEtapas[i]['nomeEtapa'],
                                              tempoTotalEtapa: listaEtapas[i]['tempoTotalEtapaMinutos'],
                                              listaAnalise: listaAnalise,
                                              funcaoComentario: null,
                                            );
                                          }
                                      ),
                                    ),
                                    TextoPadrao(texto: 'Observações Gerais/ O que é proibido e porque?',cor: Cores.primaria,negrito: FontWeight.bold,tamanhoFonte: 16,),
                                    TextoPadrao(texto: BadStateString(dadosEtapas, 'observacoes'),cor: Cores.cinzaTextoEscuro,tamanhoFonte: 16,),
                                    Container(
                                        width: 670,
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
                                          Column(
                                            children: [
                                              Container(
                                                width: 650,
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Container(
                                                        width: 50,
                                                        child: TextoPadrao(texto:'Versão',cor: Cores.primaria,tamanhoFonte: 14,)
                                                    ),
                                                    Container(
                                                        width: 100,
                                                        child: TextoPadrao(texto:'Data',cor: Cores.primaria,tamanhoFonte: 14,alinhamentoTexto: TextAlign.center,)
                                                    ),
                                                    SizedBox(width: 10,),
                                                    Container(
                                                        width: 200,
                                                        child: TextoPadrao(texto:'Resp. Alteração',cor: Cores.primaria,tamanhoFonte: 14,)
                                                    ),
                                                    SizedBox(width: 10,),
                                                    Container(
                                                        width: 250,
                                                        child: TextoPadrao(texto:'Razão',cor: Cores.primaria,tamanhoFonte: 14,)
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                width: 650,
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Container(
                                                      width: 50,
                                                      child: TextoPadrao(
                                                        texto:BadStateInt(dadosEspecificacao, 'versao').toString(),
                                                        cor: Cores.cinzaTextoEscuro,
                                                        tamanhoFonte: 14,
                                                        alinhamentoTexto: TextAlign.center,
                                                      )
                                                    ),
                                                    Container(
                                                      width: 100,
                                                      child: TextoPadrao(
                                                        texto:dadosEspecificacao==null?'':VariavelEstatica.mascaraData.format(dadosEspecificacao!['dataVersao'].toDate()),
                                                        cor: Cores.cinzaTextoEscuro,
                                                        tamanhoFonte: 14,
                                                        alinhamentoTexto: TextAlign.center,
                                                      )
                                                    ),
                                                    SizedBox(width: 10,),
                                                    Container(
                                                      width: 200,
                                                      child: TextoPadrao(texto:BadStateString(dadosEspecificacao, 'visto'),cor: Cores.cinzaTextoEscuro,tamanhoFonte: 14,)
                                                    ),
                                                    SizedBox(width: 10,),
                                                    Container(
                                                      width: 250,
                                                      child: TextoPadrao(texto:BadStateString(dadosEtapas, 'alteracao'),cor: Cores.cinzaTextoEscuro,tamanhoFonte: 14,)
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
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
                                          onPressed: ()=>
                                            FirebaseFirestore.instance.collection('documentos').doc(idDoc).update({
                                              'situacao':'autorizado'
                                            }).then((value) =>
                                            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                                              builder: (context)=>HomeTela(emailLogado: widget.emailLogado)),(route) => false,
                                            )),
                                        ),
                                        SizedBox(width: VariavelEstatica.largura*0.025,),
                                      ],
                                    )
                                  ],
                                ),
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
