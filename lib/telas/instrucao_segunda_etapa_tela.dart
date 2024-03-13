import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:instrucao_de_processos/widgets/item_etapa.dart';
import 'package:instrucao_de_processos/widgets/snackBars.dart';
import '../utilidades/cores.dart';
import '../utilidades/variavel_estatica.dart';
import '../widgets/appbar_padrao.dart';
import '../widgets/caixa_texto.dart';
import '../widgets/nivel_etapa.dart';
import '../widgets/texto_padrao.dart';

class InstrucaoSegundaEtapaTela extends StatefulWidget {
  String emailLogado;
  String nomeProcesso;
  int FIP;

  InstrucaoSegundaEtapaTela({
    required this.emailLogado,
    required this.nomeProcesso,
    required this.FIP,
  });

  @override
  State<InstrucaoSegundaEtapaTela> createState() =>_InstrucaoSegundaEtapaTelaState();
}

class _InstrucaoSegundaEtapaTelaState extends State<InstrucaoSegundaEtapaTela> {
  bool carregando = false;

  bool adicionarChaveRazao = false;
  bool etapaAtiva = false;
  bool mostrarListaImagens = false;
  bool analiseAtiva = false;

  String imagemSelecionada = '';

  var nomeEtapa = TextEditingController();
  var nomeAnalise = TextEditingController();
  var tempoAnalise = TextEditingController();
  var pontoChave = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Cores.cinzaClaro,
      appBar: carregando ? null: AppBarPadrao(showUsuarios: false, emailLogado: widget.emailLogado),
      body: Container(
        height: VariavelEstatica.altura,
        width: VariavelEstatica.largura,
        child: ListView(
          children: [
            NivelEtapa(nivel: 2),
            Container(
              width: VariavelEstatica.largura*0.8,
              height: VariavelEstatica.altura*0.75,
              margin: EdgeInsets.all(20),
              padding: EdgeInsets.all(36),
              alignment: Alignment.topLeft,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(15))
              ),
              child: Container(
                width: 1300,
                child: ListView(
                  children: [
                    TextoPadrao(texto: 'Inserir Etapas da Instrução de Processos',cor: Cores.primaria,negrito: FontWeight.bold,tamanhoFonte: 20,),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        crossAxisAlignment:CrossAxisAlignment.center ,
                        children: [
                          TextoPadrao(texto: 'N° FIP',cor: Cores.primaria,negrito: FontWeight.bold,tamanhoFonte: 16,),
                          SizedBox(width: 10,),
                          TextoPadrao(texto: widget.FIP.toString(),cor: Cores.cinzaTextoEscuro,negrito: FontWeight.bold,tamanhoFonte: 16,),
                          SizedBox(width: 40,),
                          TextoPadrao(texto: 'Nome de Processos',cor: Cores.primaria,negrito: FontWeight.bold,tamanhoFonte: 16,),
                          SizedBox(width: 10,),
                          TextoPadrao(texto: widget.nomeProcesso,cor: Cores.cinzaTextoEscuro,negrito: FontWeight.bold,tamanhoFonte: 16,),
                        ],
                      ),
                    ),
                    // Container(
                    //   width: 1200,
                    //   height: mostrarListaImagens?620:adicionarChaveRazao?300:120,
                    //   padding: EdgeInsets.all(20),
                    //   decoration: BoxDecoration(
                    //     color: Colors.white,
                    //     borderRadius: BorderRadius.circular(10),
                    //     boxShadow: [
                    //       BoxShadow(
                    //         color: Colors.grey.withOpacity(0.5),
                    //         spreadRadius: 2, // Define o raio de propagação da sombra
                    //         blurRadius: 3, // Define o raio de desfoque da sombra
                    //         offset: Offset(0, 3), // Define o deslocamento da sombra
                    //       ),
                    //     ],
                    //   ),
                    //   child: Column(
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: [
                    //       TextoPadrao(texto:'Etapa 1',cor: Cores.primaria,negrito: FontWeight.bold,tamanhoFonte: 14,),
                    //       Row(
                    //         crossAxisAlignment: CrossAxisAlignment.center,
                    //         children: [
                    //           TextoPadrao(texto:'Nome da Etapa',cor: Cores.primaria,tamanhoFonte: 14,),
                    //           SizedBox(width: 5,),
                    //           CaixaTexto(
                    //             mostrarTitulo: false,
                    //             textoCaixa: 'Inserir nome da etapa',
                    //             titulo: '',
                    //             controller: nomeEtapa,
                    //             largura: 420,
                    //             corCaixa: Cores.cinzaClaro,
                    //             ativarCaixa: !etapaAtiva,
                    //           ),
                    //           SizedBox(width: 20,),
                    //           TextoPadrao(texto:'Tempo total da etapa',cor: Cores.primaria,tamanhoFonte: 14,),
                    //           SizedBox(width: 10,),
                    //           TextoPadrao(texto:'0 min',cor: Cores.cinzaTextoEscuro,tamanhoFonte: 14,),
                    //           Spacer(),
                    //           IconButton(
                    //             icon: adicionarChaveRazao
                    //                 ?Icon(Icons.arrow_drop_down,color: Cores.cinzaTextoEscuro,size: 30,)
                    //                 :etapaAtiva?Icon(Icons.arrow_right,color: Cores.cinzaTextoEscuro,size: 30,):Icon(Icons.add_box,color: Cores.primaria,),
                    //             onPressed: (){
                    //               if(nomeEtapa.text.isNotEmpty){
                    //                 adicionarChaveRazao = adicionarChaveRazao?false:true;
                    //                 if(!etapaAtiva){
                    //                   etapaAtiva = true;
                    //                 }
                    //                 setState(() {});
                    //               }else{
                    //                 showSnackBar(context, 'Adicionar um texto para avançar', Colors.red);
                    //               }
                    //             },
                    //           )
                    //         ],
                    //       ),
                    //       adicionarChaveRazao?Column(
                    //         crossAxisAlignment: CrossAxisAlignment.start,
                    //        children: [
                    //          Row(
                    //            children: [
                    //              Container(
                    //                width: 100,
                    //                child: TextoPadrao(texto:'Característica',cor: Cores.primaria,tamanhoFonte: 14,)
                    //              ),
                    //              Container(
                    //                width: 50,
                    //                child: TextoPadrao(texto:'Análise',cor: Cores.primaria,tamanhoFonte: 14,)
                    //              ),
                    //              SizedBox(width: 10,),
                    //              Container(
                    //                width: 100,
                    //                child: TextoPadrao(texto:'Imagem/Vídeo',cor: Cores.primaria,tamanhoFonte: 14,)
                    //              ),
                    //              Container(
                    //                width: 400,
                    //                child: TextoPadrao(texto:'Análise da Operação',cor: Cores.primaria,tamanhoFonte: 14,)
                    //              ),
                    //              SizedBox(width: 10,),
                    //              Container(
                    //                 width: 130,
                    //                 child: TextoPadrao(texto:'Tempo (segundos)',cor: Cores.primaria,tamanhoFonte: 14,)
                    //              ),
                    //              SizedBox(width: 10,),
                    //              TextoPadrao(texto:'Ponto Chave/Razão',cor: Cores.primaria,tamanhoFonte: 14,),
                    //            ],
                    //          ),
                    //          Divider(),
                    //          Row(
                    //            crossAxisAlignment: CrossAxisAlignment.start,
                    //            children: [
                    //              Container(
                    //                width: 100,
                    //                height: mostrarListaImagens?450:60,
                    //                child: mostrarListaImagens?ListView.builder(
                    //                  itemCount: VariavelEstatica.listaImagens.length,
                    //                  itemBuilder: (context, i){
                    //                    return GestureDetector(
                    //                      onTap: (){
                    //                        imagemSelecionada = VariavelEstatica.listaImagens[i];
                    //                        mostrarListaImagens = false;
                    //                        setState(() {});
                    //                      },
                    //                      child: Container(
                    //                          padding: EdgeInsets.all(5),
                    //                          width: 50,
                    //                          height: 50,
                    //                          child: Image.asset(VariavelEstatica.listaImagens[i])
                    //                      ),
                    //                    );
                    //                  },
                    //                ):GestureDetector(
                    //                  onTap: analiseAtiva?null:()=>setState(()=>mostrarListaImagens=true),
                    //                  child: Container(
                    //                    width: 30,
                    //                    height: 30,
                    //                    child: imagemSelecionada==''?Container(
                    //                      margin: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                    //                      width: 20,
                    //                      height: 20,
                    //                      decoration: BoxDecoration(
                    //                        color: Cores.cinzaClaro,
                    //                        borderRadius: BorderRadius.circular(10),
                    //                      ),
                    //                      child: Row(
                    //                        mainAxisSize: MainAxisSize.min,
                    //                        mainAxisAlignment: MainAxisAlignment.center,
                    //                        children: [
                    //                          TextoPadrao(texto: '-',cor: Cores.cinzaTextoEscuro,),
                    //                          Icon(Icons.arrow_drop_down,size: 20,color: Cores.cinzaTextoEscuro,)
                    //                        ],
                    //                      ),
                    //                    ):GestureDetector(
                    //                      onTap: analiseAtiva?null:()=>setState(()=>mostrarListaImagens=true),
                    //                      child: Container(
                    //                          padding: EdgeInsets.all(5),
                    //                          width: 50,
                    //                          height: 50,
                    //                          child: Image.asset(imagemSelecionada)
                    //                      ),
                    //                    ),
                    //                  ),
                    //                ),
                    //              ),
                    //              Container(
                    //                width: 50,
                    //                child: TextoPadrao(texto:'10',cor: Cores.primaria,tamanhoFonte: 14,alinhamentoTexto: TextAlign.center,)
                    //              ),
                    //              Container(
                    //                 width: 100,
                    //                 child: IconButton(
                    //                   icon: Icon(Icons.add_photo_alternate_outlined,color: Cores.cinzaTexto,),
                    //                   onPressed: analiseAtiva?null:(){},
                    //                 ),
                    //              ),
                    //              SizedBox(width: 10,),
                    //              CaixaTexto(
                    //                mostrarTitulo: false,
                    //                textoCaixa: 'Inserir nova análise',
                    //                titulo: '',
                    //                controller: nomeAnalise,
                    //                largura: 400,
                    //                corCaixa: Cores.cinzaClaro,
                    //                ativarCaixa: !analiseAtiva,
                    //              ),
                    //              SizedBox(width: 10,),
                    //              CaixaTexto(
                    //                mostrarTitulo: false,
                    //                textoCaixa: 'Inserir tempo',
                    //                titulo: '',
                    //                controller: tempoAnalise,
                    //                largura: 130,
                    //                corCaixa: Cores.cinzaClaro,
                    //                ativarCaixa: !analiseAtiva,
                    //                textInputType: TextInputType.number,
                    //                inputFormatters: [
                    //                  FilteringTextInputFormatter.digitsOnly
                    //                ],
                    //              ),
                    //              SizedBox(width: 10,),
                    //              CaixaTexto(
                    //                mostrarTitulo: false,
                    //                textoCaixa: 'Inserir ponto chave',
                    //                titulo: '',
                    //                controller: pontoChave,
                    //                largura: 350,
                    //                corCaixa: Cores.cinzaClaro,
                    //                ativarCaixa: !analiseAtiva,
                    //              ),
                    //              Spacer(),
                    //              IconButton(
                    //                icon: !analiseAtiva?Icon(Icons.add_box,color: Cores.primaria,):Icon(Icons.clear,color: Colors.red,),
                    //                onPressed: ()=>setState(()=>analiseAtiva=analiseAtiva?false:true),
                    //              )
                    //            ],
                    //          )
                    //        ],
                    //      ):Container(),
                    //     ],
                    //   ),
                    // ),
                    ItemEtapa(
                        mostrarListaImagens: mostrarListaImagens,
                        adicionarChaveRazao: adicionarChaveRazao,
                        numeroEtapa: 1,
                        nomeEtapa: nomeEtapa,
                        etapaAtiva: etapaAtiva,
                        analiseAtiva: analiseAtiva,
                        imagemSelecionada: imagemSelecionada,
                        nomeAnalise: nomeAnalise,
                        tempoAnalise: tempoAnalise,
                        pontoChave: pontoChave,
                        botaoAtivaEtapa: (){
                            if(nomeEtapa.text.isNotEmpty){
                              adicionarChaveRazao = adicionarChaveRazao?false:true;
                              if(!etapaAtiva){
                                etapaAtiva = true;
                              }
                              setState(() {});
                            }else{
                              showSnackBar(context, 'Adicionar um texto para avançar', Colors.red);
                            }
                        },
                        botaoMostrarListaImagem:  analiseAtiva?null:()=>setState(()=>mostrarListaImagens=true),
                        botaoSalvarNovaAnalise: ()=>setState(()=>analiseAtiva=analiseAtiva?false:true),
                        listView: ListView.builder(
                          itemCount: VariavelEstatica.listaImagens.length,
                          itemBuilder: (context, i){
                            return GestureDetector(
                              onTap: (){
                                imagemSelecionada = VariavelEstatica.listaImagens[i];
                                mostrarListaImagens = false;
                                setState(() {});
                              },
                              child: Container(
                                  padding: EdgeInsets.all(5),
                                  width: 50,
                                  height: 50,
                                  child: Image.asset(VariavelEstatica.listaImagens[i])
                              ),
                            );
                          },
                        ),
                    )
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
