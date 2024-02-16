import 'package:flutter/material.dart';
import 'package:instrucao_de_processos/utilidades/paleta_cores.dart';
import 'package:instrucao_de_processos/widgets/text_default.dart';

class TitleInput extends StatelessWidget {
  String title;

  TitleInput({
    required this.title,
});

  @override
  Widget build(BuildContext context) {
    return TextDefault(text: title,color: PaletaCores.primaria,fontSize: 14,textAlign: TextAlign.start,);
  }
}
