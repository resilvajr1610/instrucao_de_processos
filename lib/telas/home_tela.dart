import 'package:flutter/material.dart';
import 'package:instrucao_de_processos/modelos/modelo_instrucao_item.dart';
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

  double larguraInicioCard = 650;
  double larguraMeioCard = 600;
  double larguraFinalCard = 550;

  iniciarModelo(){

   List<ModeloInstrucaoLista_1_1_0> listaMeio = [];
    List<ModeloInstrucaoLista_1_1_1> listaFinal = [];
    listaFinal.add(ModeloInstrucaoLista_1_1_1(controller: TextEditingController(text: 'final'), checkFinal: false,largura: larguraFinalCaixaTexto,escrever: true));
    listaMeio.add(ModeloInstrucaoLista_1_1_0(controller: TextEditingController(text: 'meio'), ativarBotaoAdicionarItemLista: false, largura: larguraMeioCaixaTexto, escrever: true, listaFinal: listaFinal));

    listaInstrucaoPrincipal.add(
      ModeloInstrucaoLista_1_0_0(
        controller: TextEditingController(text: 'inicio'),
        ativarBotaoAdicionarItemLista: false,
        escrever: true,
        largura: 450,
        listaMeio: listaMeio
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
                    color: Colors.green,
                    height: VariavelEstatica.altura*0.4+150,
                    width: larguraInicioCard,
                    child: ListView.builder(
                      itemCount: listaInstrucaoPrincipal.length,
                      itemBuilder: (context,i){
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            ItemInstrucao(
                              controller: listaInstrucaoPrincipal[i].controller,
                              ativarBotaoAdicionarItemLista: listaInstrucaoPrincipal[i].ativarBotaoAdicionarItemLista,
                              largura: listaInstrucaoPrincipal[i].largura,
                              escrever: listaInstrucaoPrincipal[i].escrever,
                              onPressed: (){},
                            ),
                            Container(
                              color: Colors.red,
                              height: listaInstrucaoPrincipal[i].listaMeio.length*200,
                              width: larguraMeioCard,
                              child: ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: listaInstrucaoPrincipal[i].listaMeio.length,
                                itemBuilder: (context,j){
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      ItemInstrucao(
                                        // controller: listaInstrucaoPrincipal[i].listaMeio[j].controller,
                                        controller: TextEditingController(text: 'meio add'),
                                        ativarBotaoAdicionarItemLista: listaInstrucaoPrincipal[i].listaMeio[j].ativarBotaoAdicionarItemLista,
                                        largura: listaInstrucaoPrincipal[i].listaMeio[j].largura,
                                        escrever: listaInstrucaoPrincipal[i].listaMeio[j].escrever,
                                        onPressed: (){},
                                      ),
                                      Container(
                                        color: Colors.amber,
                                        height: 500,
                                        width: larguraFinalCard,
                                        child: ListView.builder(
                                            // physics: NeverScrollableScrollPhysics(),
                                            itemCount: listaInstrucaoPrincipal[i].listaMeio[j].listaFinal.length,
                                            itemBuilder: (context,k){

                                              print('len');
                                              print(listaInstrucaoPrincipal[i].listaMeio[j].listaFinal.length);

                                              return ItemInstrucao(
                                                controller: listaInstrucaoPrincipal[i].listaMeio[j].listaFinal[k].controller,
                                                ativarBotaoAdicionarItemLista: listaInstrucaoPrincipal[i].listaMeio[j].listaFinal[k].checkFinal,
                                                largura: listaInstrucaoPrincipal[i].listaMeio[j].listaFinal[k].largura,
                                                escrever: listaInstrucaoPrincipal[i].listaMeio[j].listaFinal[k].escrever,
                                                onPressed: (){
                                                  print('teste');
                                                  if(listaInstrucaoPrincipal[i].listaMeio[j].listaFinal[k].controller.text.isNotEmpty){
                                                    listaInstrucaoPrincipal[i].listaMeio[j].listaFinal[k].escrever = false;
                                                    listaInstrucaoPrincipal[i].listaMeio[j].listaFinal[k].checkFinal = true;
                                                    listaInstrucaoPrincipal[i].listaMeio[j].listaFinal.add(
                                                        ModeloInstrucaoLista_1_1_1(
                                                          controller: TextEditingController(text: 'adicionar meio'),
                                                          checkFinal: false,
                                                          largura: larguraFinalCaixaTexto,
                                                          escrever: true,
                                                        )
                                                    );
                                                    setState(() {});
                                                  }else{
                                                    showSnackBar(context, 'Insirar um texto para avançar', Colors.red);
                                                  }
                                                },
                                              );
                                            }
                                        ),
                                      ),
                                      ItemInstrucao(
                                        controller: TextEditingController(),
                                        ativarBotaoAdicionarItemLista: true,
                                        largura: larguraMeioCaixaTexto,
                                        escrever: true,
                                        onPressed: (){},
                                      ),
                                    ],
                                  );
                                }
                              ),
                            ),
                            ItemInstrucao(
                              controller: TextEditingController(),
                              ativarBotaoAdicionarItemLista: true,
                              largura: larguraInicioCaixaTexto,
                              escrever: true,
                              onPressed: (){},
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
