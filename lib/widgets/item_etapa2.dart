import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:instrucao_de_processos/modelos/modelo_etapa2.dart';
import 'package:instrucao_de_processos/widgets/texto_padrao.dart';
import '../utilidades/cores.dart';
import 'caixa_texto.dart';

class ItemEtapa2 extends StatelessWidget {

  ModeloEtapa2 modeloEtapa;
  var botaoAtivaEtapa;
  Widget listViewAnalise;

  ItemEtapa2({
    required this.modeloEtapa,
    required this.botaoAtivaEtapa,
    required this.listViewAnalise,
  });



  @override
  Widget build(BuildContext context) {

    List tempo = modeloEtapa.tempoTotalEtapaMinutos.split(':');
    String minutos = tempo[0];
    String segundos = tempo[1];

    return Container(
        width: 1200,
        height: modeloEtapa.aumentarAlturaContainer?400:modeloEtapa.adicionarChaveRazao?400:120,
        padding: EdgeInsets.all(20),
        margin: EdgeInsets.symmetric(vertical: 10,horizontal: 5),
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
        child: ListView(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextoPadrao(texto:'Etapa ${modeloEtapa.numeroEtapa}',cor: Cores.primaria,negrito: FontWeight.bold,tamanhoFonte: 14,),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextoPadrao(texto:'Nome da Etapa',cor: Cores.primaria,tamanhoFonte: 14,),
                SizedBox(width: 5,),
                CaixaTexto(
                  mostrarTitulo: false,
                  textoCaixa: 'Inserir nome da etapa',
                  titulo: '',
                  controller: modeloEtapa.nomeEtapa,
                  largura: 400,
                  corCaixa: Cores.cinzaClaro,
                  ativarCaixa: true,
                ),
                SizedBox(width: 20,),
                TextoPadrao(texto:'Tempo total da etapa',cor: Cores.primaria,tamanhoFonte: 14,),
                SizedBox(width: 10,),
                TextoPadrao(texto:'$minutos min $segundos seg',cor: Cores.cinzaTextoEscuro,tamanhoFonte: 14,),
                Spacer(),
                IconButton(
                  icon: modeloEtapa.adicionarChaveRazao
                          ?Icon(Icons.arrow_drop_down,color: Cores.cinzaTextoEscuro,size: 30,)
                          :modeloEtapa.ativarCaixaEtapa
                            ?Icon(Icons.arrow_right,color: Cores.cinzaTextoEscuro,size: 30,)
                            :Icon(Icons.add_box,color: Cores.primaria,),
                  onPressed: botaoAtivaEtapa,
                )
              ],
            ),
            modeloEtapa.adicionarChaveRazao?Column(
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
                listViewAnalise
              ],
            ):Container(),
          ],
        ),
      );
  }
}
