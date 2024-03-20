import 'package:flutter/material.dart';
import '../utilidades/cores.dart';
import '../widgets/appbar_padrao.dart';

class InstrucaoUsuarioTela extends StatefulWidget {
  String emailLogado;

  InstrucaoUsuarioTela({
    required this.emailLogado
  });

  @override
  State<InstrucaoUsuarioTela> createState() => _InstrucaoUsuarioTelaState();
}

class _InstrucaoUsuarioTelaState extends State<InstrucaoUsuarioTela> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Cores.cinzaClaro,
      appBar: AppBarPadrao(showUsuarios: false, emailLogado: widget.emailLogado),
    );
  }
}
