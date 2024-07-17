import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:instrucao_de_processos/utilidades/cores.dart';
import 'package:instrucao_de_processos/widgets/titulo_padrao.dart';

import '../utilidades/funcoes_principais.dart';

class CaixaTexto extends StatelessWidget {
  bool obscure;
  bool mostrarOlho;
  String titulo;
  String textoCaixa;
  var controller;
  double tamanhoFonte;
  double largura;
  TextInputType textInputType;
  int maximoLinhas;
  Color corBorda;
  Color corCaixa;
  var onChanged;
  List<TextInputFormatter> inputFormatters;
  var onPressedSenha;
  bool mostrarTitulo;
  bool escrever;
  double margimBottom;
  bool ativarCaixa;
  bool copiar;

  CaixaTexto({
    required this.controller,
    required this.largura,
    this.obscure = false,
    this.tamanhoFonte = 12.0,
    this.titulo = '',
    this.textoCaixa = '',
    this.textInputType = TextInputType.text,
    this.maximoLinhas = 1,
    this.corBorda = Colors.white,
    this.corCaixa = Colors.white,
    this.onChanged = null,
    List<TextInputFormatter>? inputFormatters,
    this.onPressedSenha = null,
    this.mostrarOlho = false,
    this.mostrarTitulo = true,
    this.escrever = true,
    this.margimBottom = 5,
    this.ativarCaixa = true,
    this.copiar = false,
  }) : inputFormatters = inputFormatters ?? [];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        mostrarTitulo?TituloPadrao(title:titulo):Container(),
        Container(
          width: copiar?largura+40:largura,
          margin: EdgeInsets.only(bottom: margimBottom),
          decoration: BoxDecoration(
            color: corCaixa,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Row(
            children: [
              Container(
                width: mostrarOlho?largura*0.9:largura,
                child: TextFormField(
                  keyboardType: textInputType,
                  maxLines: maximoLinhas,
                  onChanged: onChanged,
                  inputFormatters: inputFormatters,
                  obscureText: this.obscure,
                  controller: this.controller,
                  cursorColor: Cores.primaria,
                  enabled: ativarCaixa,
                  style: TextStyle(
                    color: Cores.cinzaTexto,
                    fontSize: this.tamanhoFonte,
                  ),
                  decoration: InputDecoration(
                    fillColor: Colors.black87,
                    // labelText: label,
                    border: OutlineInputBorder(
                      borderSide: BorderSide(width: 1,color: corBorda)
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 1, color: corBorda),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 1, color: corBorda),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 1, color: corBorda),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    enabled: escrever,
                    hintText: textoCaixa,
                    hintStyle: TextStyle(
                      color: Cores.cinzaTexto,
                      fontSize: this.tamanhoFonte,
                      fontFamily: "Nunito"
                    )
                  )
                ),
              ),
              copiar?IconButton(
                onPressed:()async{
                  controller.text = await FuncoesPrincipais().pegarTextoCopiado();
                },
                icon: Icon(Icons.copy)
              ):Container(),
              mostrarOlho?Container(
                width: mostrarOlho?largura*0.1:0,
                child: IconButton(
                    onPressed: onPressedSenha,
                    icon: Icon(obscure?Icons.remove_red_eye_outlined:Icons.remove_red_eye, color: Cores.primaria,)
                ),
              ):Container()
            ],
          ),
        ),
      ],
    );
  }
}
