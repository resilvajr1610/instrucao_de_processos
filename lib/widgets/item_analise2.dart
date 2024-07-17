import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:instrucao_de_processos/modelos/modelo_analise2.dart';
import 'package:instrucao_de_processos/widgets/texto_padrao.dart';
import '../utilidades/cores.dart';
import 'caixa_texto.dart';

class ItemAnalise2 extends StatelessWidget {

  ModeloAnalise2 modeloAnalise;
  var botaoSalvarNovaAnalise;
  var botaoMostrarListaImagem;
  Widget listViewImagens;
  var funcaoFotoVideo;
  var funcaoAlterar;
  int indice;

  ItemAnalise2({
    required this.modeloAnalise,
    required this.botaoSalvarNovaAnalise,
    required this.listViewImagens,
    required this.botaoMostrarListaImagem,
    required this.funcaoFotoVideo,
    required this.funcaoAlterar,
    required this.indice
  });

  @override
  Widget build(BuildContext context) {

    return  Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 100,
          height: modeloAnalise.mostrarListaImagens?300:50,
          child: modeloAnalise.mostrarListaImagens?listViewImagens
              :GestureDetector(
            onTap: modeloAnalise.analiseAtiva?botaoMostrarListaImagem:null,
            child: Container(
              width: 30,
              height: 30,
              child: modeloAnalise.imagemSelecionada==''?Container(
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
                onTap: modeloAnalise.analiseAtiva?botaoMostrarListaImagem:null,
                child: Container(
                    padding: EdgeInsets.all(5),
                    width: 50,
                    height: 50,
                    child: Image.asset(modeloAnalise.imagemSelecionada)
                ),
              ),
            ),
          ),
        ),
        Container(
            padding: EdgeInsets.symmetric(vertical: 12),
            width: 50,
            child: TextoPadrao(texto:'${indice+1}0',cor: Cores.primaria,tamanhoFonte: 14,alinhamentoTexto: TextAlign.center,)
        ),
        Container(
          width: 100,
          padding: EdgeInsets.symmetric(vertical: 8),
          child: IconButton(
            icon: Icon(Icons.add_photo_alternate_outlined,color: Cores.cinzaTexto,),
            onPressed: !modeloAnalise.analiseAtiva?null:funcaoFotoVideo,
          ),
        ),
        SizedBox(width: 10,),
        CaixaTexto(
          mostrarTitulo: false,
          textoCaixa: 'Inserir nova análise',
          titulo: '',
          controller: modeloAnalise.nomeAnalise,
          largura: 400-40,
          corCaixa: Cores.cinzaClaro,
          ativarCaixa: modeloAnalise.analiseAtiva,
          maximoLinhas: 3,
          textInputType: TextInputType.multiline,
          copiar: true,
        ),
        SizedBox(width: 10,),
        CaixaTexto(
          mostrarTitulo: false,
          textoCaixa: 'Inserir tempo',
          titulo: '',
          controller: modeloAnalise.tempoAnalise,
          largura: 130,
          corCaixa: Cores.cinzaClaro,
          ativarCaixa: modeloAnalise.analiseAtiva,
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
          controller: modeloAnalise.pontoChave,
          largura: 350-40,
          corCaixa: Cores.cinzaClaro,
          ativarCaixa: modeloAnalise.analiseAtiva,
          textInputType: TextInputType.multiline,
          maximoLinhas: 3,
          copiar: true,
        ),
        Spacer(),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: IconButton(
            icon: !modeloAnalise.listaCompleta?Icon(Icons.add_box,color: Cores.primaria,):Icon(Icons.clear,color: Colors.red,),
            onPressed: botaoSalvarNovaAnalise,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: IconButton(
            icon: Icon(Icons.edit,color: Colors.orange,),
            onPressed: funcaoAlterar,
          ),
        ),
      ],
    );
  }
}
