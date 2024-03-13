import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:instrucao_de_processos/widgets/texto_padrao.dart';
import '../utilidades/cores.dart';
import '../utilidades/variavel_estatica.dart';
import 'caixa_texto.dart';

class ItemEtapa extends StatelessWidget {
  bool mostrarListaImagens;
  bool adicionarChaveRazao;
  int numeroEtapa;
  var nomeEtapa;
  bool etapaAtiva;
  bool analiseAtiva;
  var botaoAtivaEtapa;
  String imagemSelecionada;
  var nomeAnalise;
  var tempoAnalise;
  var pontoChave;
  var botaoMostrarListaImagem;
  var botaoSalvarNovaAnalise;
  Widget listView;

  ItemEtapa({
    required this.mostrarListaImagens,
    required this.adicionarChaveRazao,
    required this.numeroEtapa,
    required this.nomeEtapa,
    required this.etapaAtiva,
    required this.analiseAtiva,
    required this.botaoAtivaEtapa,
    required this.imagemSelecionada,
    required this.nomeAnalise,
    required this.tempoAnalise,
    required this.pontoChave,
    required this.botaoMostrarListaImagem,
    required this.botaoSalvarNovaAnalise,
    required this.listView
  });


  @override
  Widget build(BuildContext context) {
    return Container(
        width: 1200,
        height: mostrarListaImagens?620:adicionarChaveRazao?220:120,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2, // Define o raio de propagação da sombra
              blurRadius: 3, // Define o raio de desfoque da sombra
              offset: Offset(0, 3), // Define o deslocamento da sombra
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextoPadrao(texto:'Etapa $numeroEtapa',cor: Cores.primaria,negrito: FontWeight.bold,tamanhoFonte: 14,),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextoPadrao(texto:'Nome da Etapa',cor: Cores.primaria,tamanhoFonte: 14,),
                SizedBox(width: 5,),
                CaixaTexto(
                  mostrarTitulo: false,
                  textoCaixa: 'Inserir nome da etapa',
                  titulo: '',
                  controller: nomeEtapa,
                  largura: 400,
                  corCaixa: Cores.cinzaClaro,
                  ativarCaixa: !etapaAtiva,
                ),
                SizedBox(width: 20,),
                TextoPadrao(texto:'Tempo total da etapa',cor: Cores.primaria,tamanhoFonte: 14,),
                SizedBox(width: 10,),
                TextoPadrao(texto:'0 min',cor: Cores.cinzaTextoEscuro,tamanhoFonte: 14,),
                Spacer(),
                IconButton(
                  icon: adicionarChaveRazao
                      ?Icon(Icons.arrow_drop_down,color: Cores.cinzaTextoEscuro,size: 30,)
                      :etapaAtiva?Icon(Icons.arrow_right,color: Cores.cinzaTextoEscuro,size: 30,):Icon(Icons.add_box,color: Cores.primaria,),
                  onPressed: botaoAtivaEtapa,
                  // onPressed: (){
                  //   if(nomeEtapa.text.isNotEmpty){
                  //     adicionarChaveRazao = adicionarChaveRazao?false:true;
                  //     if(!etapaAtiva){
                  //       etapaAtiva = true;
                  //     }
                  //     setState(() {});
                  //   }else{
                  //     showSnackBar(context, 'Adicionar um texto para avançar', Colors.red);
                  //   }
                  // },
                )
              ],
            ),
            adicionarChaveRazao?Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                        width: 100,
                        child: TextoPadrao(texto:'Característica',cor: Cores.primaria,tamanhoFonte: 14,)
                    ),
                    Container(
                        width: 50,
                        child: TextoPadrao(texto:'Análise',cor: Cores.primaria,tamanhoFonte: 14,)
                    ),
                    SizedBox(width: 10,),
                    Container(
                        width: 100,
                        child: TextoPadrao(texto:'Imagem/Vídeo',cor: Cores.primaria,tamanhoFonte: 14,)
                    ),
                    Container(
                        width: 400,
                        child: TextoPadrao(texto:'Análise da Operação',cor: Cores.primaria,tamanhoFonte: 14,)
                    ),
                    SizedBox(width: 10,),
                    Container(
                        width: 130,
                        child: TextoPadrao(texto:'Tempo (segundos)',cor: Cores.primaria,tamanhoFonte: 14,)
                    ),
                    SizedBox(width: 10,),
                    TextoPadrao(texto:'Ponto Chave/Razão',cor: Cores.primaria,tamanhoFonte: 14,),
                  ],
                ),
                Divider(),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 100,
                      height: mostrarListaImagens?450:60,
                      child: mostrarListaImagens?listView
                      // ListView.builder(
                      //   itemCount: VariavelEstatica.listaImagens.length,
                      //   itemBuilder: (context, i){
                      //     return GestureDetector(
                      //       onTap: botaoSelecionarImagem,
                      //       // onTap: (){
                      //       //   imagemSelecionada = VariavelEstatica.listaImagens[i];
                      //       //   mostrarListaImagens = false;
                      //       //   setState(() {});
                      //       // },
                      //       child: Container(
                      //           padding: EdgeInsets.all(5),
                      //           width: 50,
                      //           height: 50,
                      //           child: Image.asset(VariavelEstatica.listaImagens[i])
                      //       ),
                      //     );
                      //   },
                      // )
                          :GestureDetector(
                        // onTap: analiseAtiva?null:()=>setState(()=>mostrarListaImagens=true),
                        onTap: botaoMostrarListaImagem,
                        child: Container(
                          width: 30,
                          height: 30,
                          child: imagemSelecionada==''?Container(
                            margin: EdgeInsets.symmetric(vertical: 5,horizontal: 20),
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: Cores.cinzaClaro,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextoPadrao(texto: '-',cor: Cores.cinzaTextoEscuro,),
                                Icon(Icons.arrow_drop_down,size: 20,color: Cores.cinzaTextoEscuro,)
                              ],
                            ),
                          ):GestureDetector(
                            // onTap: analiseAtiva?null:()=>setState(()=>mostrarListaImagens=true),
                            onTap: botaoMostrarListaImagem,
                            child: Container(
                                padding: EdgeInsets.all(5),
                                width: 50,
                                height: 50,
                                child: Image.asset(imagemSelecionada)
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        width: 50,
                        child: TextoPadrao(texto:'10',cor: Cores.primaria,tamanhoFonte: 14,alinhamentoTexto: TextAlign.center,)
                    ),
                    Container(
                      width: 100,
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: IconButton(
                        icon: Icon(Icons.add_photo_alternate_outlined,color: Cores.cinzaTexto,),
                        onPressed: analiseAtiva?null:(){},
                      ),
                    ),
                    SizedBox(width: 10,),
                    CaixaTexto(
                      mostrarTitulo: false,
                      textoCaixa: 'Inserir nova análise',
                      titulo: '',
                      controller: nomeAnalise,
                      largura: 400,
                      corCaixa: Cores.cinzaClaro,
                      ativarCaixa: !analiseAtiva,
                    ),
                    SizedBox(width: 10,),
                    CaixaTexto(
                      mostrarTitulo: false,
                      textoCaixa: 'Inserir tempo',
                      titulo: '',
                      controller: tempoAnalise,
                      largura: 130,
                      corCaixa: Cores.cinzaClaro,
                      ativarCaixa: !analiseAtiva,
                      textInputType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly
                      ],
                    ),
                    SizedBox(width: 10,),
                    CaixaTexto(
                      mostrarTitulo: false,
                      textoCaixa: 'Inserir ponto chave',
                      titulo: '',
                      controller: pontoChave,
                      largura: 350,
                      corCaixa: Cores.cinzaClaro,
                      ativarCaixa: !analiseAtiva,
                    ),
                    Spacer(),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: IconButton(
                        icon: !analiseAtiva?Icon(Icons.add_box,color: Cores.primaria,):Icon(Icons.clear,color: Colors.red,),
                        onPressed: botaoSalvarNovaAnalise,
                        // onPressed: ()=>setState(()=>analiseAtiva=analiseAtiva?false:true),
                      ),
                    )
                  ],
                )
              ],
            ):Container(),
          ],
        ),
      );
  }
}
