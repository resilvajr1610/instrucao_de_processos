import 'package:flutter/material.dart';
import 'package:instrucao_de_processos/utilidades/paleta_cores.dart';

class TextDefault extends StatelessWidget {

  final String text;
  final double fontSize;
  final Color color;
  final FontWeight fontWeigth;
  final TextAlign textAlign;
  final int maxLines;

  TextDefault({
    required this.text,
    this.fontSize = 14.0,
    this.color = PaletaCores.cinzaClaro,
    this.fontWeigth = FontWeight.normal,
    this.textAlign = TextAlign.start,
    this.maxLines = 1
});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeigth,
        color: color,
        overflow: TextOverflow.ellipsis,
        fontFamily: "Nunito"
      ),
    );
  }
}
