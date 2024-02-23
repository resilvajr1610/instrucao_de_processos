import 'package:flutter/material.dart';
import 'package:instrucao_de_processos/widgets/appbar_padrao.dart';

class HomeTela extends StatefulWidget {
  String emailLogado;

  HomeTela({
    required this.emailLogado
});

  @override
  State<HomeTela> createState() => _HomeTelaState();
}

class _HomeTelaState extends State<HomeTela> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarPadrao(showUsuarios: true,emailLogado: widget.emailLogado),
    );
  }
}
