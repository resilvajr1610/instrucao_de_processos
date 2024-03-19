import 'package:flutter/material.dart';
import 'package:instrucao_de_processos/modelos/bad_state_int.dart';
import 'package:instrucao_de_processos/modelos/bad_state_list.dart';
import 'package:instrucao_de_processos/modelos/bad_state_string.dart';
import 'package:instrucao_de_processos/widgets/item_etapa3_titulo.dart';
import '../utilidades/cores.dart';
import '../utilidades/variavel_estatica.dart';
import '../widgets/appbar_padrao.dart';
import '../widgets/nivel_etapa.dart';
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

  carregarDados(){
    FirebaseFirestore.instance.collection('especificacao').doc(widget.idEtapa).get().then((dadosEsp){
      dadosEspecificacao = dadosEsp;
      setState((){});
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
        appBar: carregando? null: AppBarPadrao(showUsuarios: false, emailLogado: widget.emailLogado),
        body: Container(
            height: VariavelEstatica.altura,
            width: VariavelEstatica.largura,
            child: ListView(
                children: [
                  NivelEtapa(nivel: 3),
                  Container(
                    width: VariavelEstatica.largura * 0.8,
                    height: VariavelEstatica.altura * 0.75,
                    margin: EdgeInsets.all(20),
                    padding: EdgeInsets.all(36),
                    alignment: Alignment.topLeft,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(15))
                    ),
                    child: Container(
                      width: VariavelEstatica.largura * 0.95,
                      child: ListView(
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
                          Row(
                            children: [
                              Container(
                                width: VariavelEstatica.largura>1500?VariavelEstatica.largura * 0.45:VariavelEstatica.largura * 0.15,
                                child: Row(
                                  children: [
                                    TextoPadrao(texto: 'EPI Necessário',cor: Cores.primaria,tamanhoFonte: 14,),
                                    SizedBox(width: 10,),
                                    TextoPadrao(texto: BadStateList(dadosEspecificacao, 'epi').toString().replaceAll('[', '').replaceAll(']', ''),cor: Cores.cinzaTextoEscuro,tamanhoFonte: 14,),
                                  ],
                                ) ,
                              ),
                              Container(
                                width: VariavelEstatica.largura>1500?VariavelEstatica.largura * 0.45:VariavelEstatica.largura * 0.15,
                                child: Row(
                                  children: [
                                    TextoPadrao(texto: 'Máquina',cor: Cores.primaria,tamanhoFonte: 14,),
                                    SizedBox(width: 10,),
                                    TextoPadrao(texto: BadStateString(dadosEspecificacao, 'maquina'),cor: Cores.cinzaTextoEscuro,tamanhoFonte: 14,),
                                  ],
                                ),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              TextoPadrao(texto: 'Ferramentas utilizadas',cor: Cores.primaria,tamanhoFonte: 14,),
                              SizedBox(width: 10,),
                              TextoPadrao(texto: BadStateList(dadosEspecificacao, 'ferramentas').toString().replaceAll('[', '').replaceAll(']', ''),cor: Cores.cinzaTextoEscuro,tamanhoFonte: 14,),
                            ],
                          ),
                          Divider(),
                          Row(
                            children: [
                              Container(
                                width: VariavelEstatica.largura>1500?VariavelEstatica.largura * 0.45:VariavelEstatica.largura * 0.15,
                                child: Row(
                                  children: [
                                    TextoPadrao(texto: 'Matéria-prima utilizada',cor: Cores.primaria,tamanhoFonte: 14,),
                                    SizedBox(width: 10,),
                                    TextoPadrao(texto: BadStateList(dadosEspecificacao, 'materiaPrima').toString().replaceAll('[', '').replaceAll(']', ''),cor: Cores.cinzaTextoEscuro,tamanhoFonte: 14,),
                                  ],
                                ),
                              ),
                              Container(
                                width: VariavelEstatica.largura>1500?VariavelEstatica.largura * 0.45:VariavelEstatica.largura * 0.15,
                                child: Row(
                                  children: [
                                    TextoPadrao(texto: 'Tempo total das etapas',cor: Cores.primaria,tamanhoFonte: 14,),
                                    SizedBox(width: 10,),
                                    TextoPadrao(texto: '2.77 min',cor: Cores.cinzaTextoEscuro,tamanhoFonte: 14,),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                width: VariavelEstatica.largura>1500?VariavelEstatica.largura * 0.45:VariavelEstatica.largura * 0.15,
                                child: Row(
                                  children: [
                                    TextoPadrao(texto: 'Especificações',cor: Cores.primaria,tamanhoFonte: 14,),
                                    SizedBox(width: 10,),
                                    TextoPadrao(texto: BadStateString(dadosEspecificacao, 'espeficicacao'),cor: Cores.cinzaTextoEscuro,tamanhoFonte: 14,),
                                  ],
                                ),
                              ),
                              Container(
                                width: VariavelEstatica.largura>1500?VariavelEstatica.largura * 0.45:VariavelEstatica.largura * 0.15,
                                child: Row(
                                  children: [
                                    TextoPadrao(texto: 'Prazo de aprendizagem',cor: Cores.primaria,tamanhoFonte: 14,),
                                    SizedBox(width: 10,),
                                    TextoPadrao(texto: BadStateString(dadosEspecificacao, 'prazo'),cor: Cores.cinzaTextoEscuro,tamanhoFonte: 14,),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          ItemEtapa3Titulo(
                              dadosEspecificacao: dadosEspecificacao,
                              item1: 'esp_maquina',
                              item2: 'licenca_qualificacoes',
                              titulo1: 'Especificações máquina',
                              titulo2: 'Licenças ou qualificações',
                          ),
                          Divider(),
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
