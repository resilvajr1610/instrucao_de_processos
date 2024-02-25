import 'package:flutter/material.dart';
import 'package:instrucao_de_processos/modelos/modelo_instrucao_item.dart';
import 'package:instrucao_de_processos/modelos/modelo_instrucao_lista.dart';
import 'package:instrucao_de_processos/utilidades/cores.dart';
import 'package:instrucao_de_processos/utilidades/variavel_estatica.dart';
import 'package:instrucao_de_processos/widgets/appbar_padrao.dart';
import 'package:instrucao_de_processos/widgets/caixa_texto_pesquisa.dart';
import 'package:instrucao_de_processos/widgets/item_instrucao.dart';
import '../widgets/texto_padrao.dart';

class HomeTela extends StatefulWidget {
  String emailLogado;

  HomeTela({
    required this.emailLogado
});

  @override
  State<HomeTela> createState() => _HomeTelaState();
}

class _HomeTelaState extends State<HomeTela> {

  List<ModeloInstrucaoLista> listaInstrucao=[];
  var pesquisa = TextEditingController();

  iniciarModelo(){

    List<ModeloInstrucaoItem> listaNivel1 = [];
    List<ModeloInstrucaoItem> listaNivel2 = [];
    List<ModeloInstrucaoItem> listaNivel3 = [];

    listaNivel1.add(ModeloInstrucaoItem(controller: TextEditingController(), check: false, largura: 550));
    listaNivel2.add(ModeloInstrucaoItem(controller: TextEditingController(), check: false, largura: 500));
    listaNivel3.add(ModeloInstrucaoItem(controller: TextEditingController(), check: false, largura: 450));

    listaInstrucao.add(
      ModeloInstrucaoLista(
        listaNivel1: listaNivel1,
        listaNivel2: listaNivel2,
        listaNivel3: listaNivel3,
        nivel1Check: false,
        nivel2Check: false,
        nivel3Check: false,
      )
    );
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    iniciarModelo();
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
                  height: VariavelEstatica.altura*0.45,
                  width: 650,
                  child: ListView.builder(
                    itemCount: listaInstrucao.length,
                    itemBuilder: (context,i){

                      print('listaInstrucao.length');
                      print(listaInstrucao.length);
                      print(listaInstrucao[i].listaNivel1.length);

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            height: listaInstrucao[i].listaNivel1.length*80,
                            width: 650,
                            child: ListView.builder(
                              itemCount: listaInstrucao[i].listaNivel1.length,
                              itemBuilder: (context,j){
                                return ItemInstrucao(
                                  controller: listaInstrucao[i].listaNivel1[j].controller,
                                  check: listaInstrucao[i].listaNivel1[j].check,
                                  largura: listaInstrucao[i].listaNivel1[j].largura,

                                  onPressed: (){
                                    print('teste');
                                    listaInstrucao[i+1].listaNivel1.add(ModeloInstrucaoItem(controller: TextEditingController(), check: false, largura: 500));
                                    setState(() {});
                                  },
                                );
                              }
                            ),
                          ),
                          Container(
                            height: listaInstrucao[i].listaNivel2.length*80,
                            width: 600,
                            child: ListView.builder(
                                itemCount: listaInstrucao[i].listaNivel2.length,
                                itemBuilder: (context,j){
                                  return ItemInstrucao(
                                    controller: listaInstrucao[i].listaNivel2[j].controller,
                                    check: listaInstrucao[i].listaNivel2[j].check,
                                    largura: listaInstrucao[i].listaNivel2[j].largura,
                                    onPressed: (){
                                      print('teste2');
                                    },
                                  );
                                }
                            ),
                          ),
                          Container(
                            height: VariavelEstatica.altura*0.5,
                            width: 550,
                            child: ListView.builder(
                                itemCount: listaInstrucao[i].listaNivel3.length,
                                itemBuilder: (context,j){
                                  return ItemInstrucao(
                                    controller: listaInstrucao[i].listaNivel3[j].controller,
                                    check: listaInstrucao[i].listaNivel3[j].check,
                                    largura: listaInstrucao[i].listaNivel3[j].largura,
                                    onPressed: (){
                                      print('teste3');
                                    },
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
        )
      )
    );
  }
}
