import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:instrucao_de_processos/utilidades/paleta_cores.dart';
import 'package:instrucao_de_processos/widgets/title_input.dart';

class InputText extends StatelessWidget {
  bool obscure;
  bool mostrarOlho;
  String title;
  var controller;
  double fontSize;
  double width;
  TextInputType textInputType;
  int maxLines;
  Color colorBorder;
  var onChanged;
  List<TextInputFormatter> inputFormatters;
  var onPressedSenha;

  InputText({
    required this.controller,
    required this.width,
    this.obscure = false,
    this.fontSize = 14.0,
    this.title = '',
    this.textInputType = TextInputType.text,
    this.maxLines = 1,
    this.colorBorder = Colors.white,
    this.onChanged = null,
    List<TextInputFormatter>? inputFormatters,
    this.onPressedSenha = null,
    this.mostrarOlho = false,
  }) : inputFormatters = inputFormatters ?? [];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleInput(title:title),
        Container(
          width: width,
          margin: EdgeInsets.only(bottom: 5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Row(
            children: [
              Container(
                width: mostrarOlho?width*0.9:width,
                child: TextFormField(
                  keyboardType: textInputType,
                  maxLines: maxLines,
                  onChanged: onChanged,
                  inputFormatters: inputFormatters,
                  obscureText: this.obscure,
                  controller: this.controller,
                  cursorColor: PaletaCores.primaria,
                  style: TextStyle(
                    color: PaletaCores.cinzaTexto,
                    fontSize: this.fontSize,
                  ),
                  decoration: InputDecoration(
                    fillColor: Colors.black87,
                    // labelText: label,
                    border: OutlineInputBorder(
                      borderSide: BorderSide(width: 1,color: colorBorder)
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 1, color: colorBorder),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 1, color: colorBorder),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 1, color: colorBorder),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    hintText: title,
                    hintStyle: TextStyle(
                      color: PaletaCores.cinzaTexto,
                      fontSize: this.fontSize,
                      fontFamily: "Nunito"
                    )
                  )
                ),
              ),
              mostrarOlho?Container(
                width: mostrarOlho?width*0.1:0,
                child: IconButton(
                    onPressed: onPressedSenha,
                    icon: Icon(obscure?Icons.remove_red_eye_outlined:Icons.remove_red_eye, color: PaletaCores.primaria,)
                ),
              ):Container()
            ],
          ),
        ),
      ],
    );
  }
}
