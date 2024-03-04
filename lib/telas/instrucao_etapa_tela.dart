import 'package:flutter/material.dart';

import '../utilidades/cores.dart';
import '../widgets/appbar_padrao.dart';

class InstrucaoEtapaTela extends StatefulWidget {
  String idFirebase;
  String idDocumento;
  String emailLogado;

  InstrucaoEtapaTela({
    required this.idFirebase,
    required this.idDocumento,
    required this.emailLogado,
  });

  @override
  State<InstrucaoEtapaTela> createState() => _InstrucaoEtapaTelaState();
}

class _InstrucaoEtapaTelaState extends State<InstrucaoEtapaTela> {


  bool carregando = false;

  @override
  void initState() {
    super.initState();
    print(widget.idFirebase);
    print(widget.idDocumento);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Cores.cinzaClaro,
      appBar: carregando?null:AppBarPadrao(showUsuarios: false,emailLogado: widget.emailLogado),
    );
  }
}
