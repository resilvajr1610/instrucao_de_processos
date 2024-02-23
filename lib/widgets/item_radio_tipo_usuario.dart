import 'package:flutter/material.dart';
import 'package:instrucao_de_processos/widgets/texto_padrao.dart';
import 'package:instrucao_de_processos/widgets/titulo_padrao.dart';

import '../utilidades/cores.dart';

class ItemRadioTipoUsuario extends StatelessWidget {
  int tipoAcesso;
  var onChanged;
  int value;
  String texto;

  ItemRadioTipoUsuario({
    required this.tipoAcesso,
    required this.onChanged,
    required this.value,
    required this.texto
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          children: [
            TituloPadrao(title: ' '),
            Container(
              height: 52,
              width: 35,
              child: Radio(
                  value: value,
                  groupValue: tipoAcesso,
                  activeColor: Cores.primaria,
                  onChanged: onChanged
              ),
            ),
          ],
        ),
        Column(
          children: [
            TituloPadrao(title: ' '),
            Container(
                alignment: Alignment.center,
                height: 52,
                child: TextoPadrao(texto: texto ,cor: Cores.primaria,tamanhoFonte: 12,)
            ),
          ],
        ),
      ],
    );
  }
}
