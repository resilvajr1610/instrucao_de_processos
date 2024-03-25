import 'package:flutter/material.dart';
import 'package:instrucao_de_processos/modelos/modelo_analise3.dart';
import 'package:instrucao_de_processos/widgets/texto_padrao.dart';
import '../utilidades/cores.dart';
import '../utilidades/variavel_estatica.dart';

class ItemEtapa3 extends StatelessWidget {
  num numeroEtapa;
  String nomeEtapa;
  String tempoTotalEtapa;
  List<ModeloAnalise3> listaAnalise;
  bool comentario;
  var funcaoComentario;

  ItemEtapa3({
    required this.numeroEtapa,
    required this.nomeEtapa,
    required this.tempoTotalEtapa,
    required this.listaAnalise,
    required this.funcaoComentario,
    this.comentario = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: VariavelEstatica.largura * 0.3,
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.symmetric(vertical: 5,horizontal: 5),
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
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextoPadrao(texto: 'Etapa $numeroEtapa',cor: Cores.primaria,negrito: FontWeight.bold,tamanhoFonte: 16,),
          Container(
            width: VariavelEstatica.largura>1500?VariavelEstatica.largura * 0.7:VariavelEstatica.largura * 0.15,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: VariavelEstatica.largura>1500?VariavelEstatica.largura * 0.44:VariavelEstatica.largura * 0.15,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextoPadrao(texto: 'Nome da Etapa',cor: Cores.primaria,tamanhoFonte: 14,),
                      SizedBox(width: 10,),
                      Container(
                          width: VariavelEstatica.largura * 0.1,
                          child: TextoPadrao(texto: nomeEtapa,cor: Cores.cinzaTextoEscuro,tamanhoFonte: 14,)
                      ),
                    ],
                  ),
                ),
                Container(
                  width: VariavelEstatica.largura>1500?VariavelEstatica.largura * 0.2:VariavelEstatica.largura * 0.15,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextoPadrao(texto: 'Tempo total da etapa',cor: Cores.primaria,tamanhoFonte: 14,),
                      SizedBox(width: 10,),
                      Container(
                          width: VariavelEstatica.largura * 0.1,
                          child: TextoPadrao(texto: '$tempoTotalEtapa min',cor: Cores.cinzaTextoEscuro,tamanhoFonte: 14,)
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
              width:1000,
              child: Divider()
          ),
          Container(
            width: 1000,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                    width: 110,
                    child: TextoPadrao(texto:'Característica',cor: Cores.primaria,tamanhoFonte: 14,)
                ),
                Container(
                    width: 60,
                    child: TextoPadrao(texto:'Análise',cor: Cores.primaria,tamanhoFonte: 14,)
                ),
                SizedBox(width: 10,),
                Container(
                    width: 110,
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
          ),
          //criar list
          Container(
            width: 1050,
            height: listaAnalise.length*50,
            child: ListView.builder(
              itemCount: listaAnalise.length,
              itemBuilder: (context,i){
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      width: 90,
                      height: 50,
                      child: listaAnalise[i].imagemSelecionada==''?TextoPadrao(texto: '-',cor: Cores.cinzaTextoEscuro,):Image.asset(listaAnalise[i].imagemSelecionada),
                      margin: EdgeInsets.only(right: 20),
                    ),
                    Container(
                      height: 50,
                      alignment: Alignment.center,
                      width: 50,
                      child: TextoPadrao(texto:listaAnalise[i].numeroAnalise.toString(),cor: Cores.primaria,tamanhoFonte: 14,alinhamentoTexto: TextAlign.center,),
                      margin: EdgeInsets.only(right: 10),
                    ),
                    SizedBox(width: 10,),
                    Container(
                      height: 50,
                      width: 90,
                      child: IconButton(
                        icon: Icon(Icons.photo,color: Cores.cinzaTexto,),
                        onPressed: (){},
                      ),
                      margin: EdgeInsets.only(right: 20),
                    ),
                    Container(
                        height: 50,
                        alignment: Alignment.centerLeft,
                        width: 400,
                        child: TextoPadrao(texto:listaAnalise[i].nomeAnalise,cor: Cores.cinzaTextoEscuro,tamanhoFonte: 14,)
                    ),
                    SizedBox(width: 10,),
                    Container(
                      height: 50,
                      alignment: Alignment.center,
                      width: 120,
                      child: TextoPadrao(texto:listaAnalise[i].tempo,cor: Cores.cinzaTextoEscuro,tamanhoFonte: 14,alinhamentoTexto: TextAlign.center,),
                      margin: EdgeInsets.only(right: 10),
                    ),
                    SizedBox(width: 10,),
                    Container(
                        height: 50,
                        alignment: Alignment.centerLeft,
                        width: 160,
                        child: TextoPadrao(texto:listaAnalise[i].pontoChave,cor: Cores.cinzaTextoEscuro,tamanhoFonte: 14,)
                    ),
                    Spacer(),
                    comentario?IconButton(onPressed: funcaoComentario, icon: Icon(Icons.report_problem,color: Cores.amarelo_icone_comentario,)):Container()
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
