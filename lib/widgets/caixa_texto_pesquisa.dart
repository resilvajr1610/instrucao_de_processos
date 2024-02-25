import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:instrucao_de_processos/utilidades/cores.dart';
import 'package:instrucao_de_processos/widgets/titulo_padrao.dart';

class CaixaTextoPesquisa extends StatelessWidget {
  String textoCaixa;
  var controller;
  double tamanhoFonte;
  double largura;
  TextInputType textInputType;
  Color corCaixa;
  var onChanged;
  List<TextInputFormatter> inputFormatters;

  CaixaTextoPesquisa({
    required this.controller,
    required this.largura,
    this.tamanhoFonte = 16.0,
    this.textoCaixa = '',
    this.textInputType = TextInputType.text,
    this.corCaixa = Colors.white,
    this.onChanged = null,
    List<TextInputFormatter>? inputFormatters,
  }) : inputFormatters = inputFormatters ?? [];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: largura,
      margin: EdgeInsets.only(bottom: 5),
      decoration: BoxDecoration(
        color: corCaixa,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: Cores.primaria)
      ),
      child: Row(
        children: [
          Container(
            width: largura*0.9,
            child: TextFormField(
              keyboardType: textInputType,
              maxLines: 1,
              onChanged: onChanged,
              inputFormatters: inputFormatters,
              controller: this.controller,
              cursorColor: Cores.primaria,
              style: TextStyle(
                color: Cores.cinzaTexto,
                fontSize: this.tamanhoFonte,
              ),
              decoration: InputDecoration(
                fillColor: Colors.black87,
                // labelText: label,
                border: OutlineInputBorder(
                  borderSide: BorderSide(width: 1,color: Colors.white)
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 1, color: Colors.white),
                  borderRadius: BorderRadius.circular(3),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 1, color: Colors.white),
                  borderRadius: BorderRadius.circular(3),
                ),
                disabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 1, color: Colors.white),
                  borderRadius: BorderRadius.circular(3),
                ),
                hintText: textoCaixa,
                hintStyle: TextStyle(
                  color: Cores.cinzaTexto,
                  fontSize: this.tamanhoFonte,
                  fontFamily: "Nunito"
                )
              )
            ),
          ),
          Icon(Icons.search, color: Cores.primaria,)
        ],
      ),
    );
  }
}
