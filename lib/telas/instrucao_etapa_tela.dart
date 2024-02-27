import 'package:flutter/material.dart';

class InstrucaoEtapaTela extends StatefulWidget {
  String idFirebase;
  String idDocumento;

  InstrucaoEtapaTela({
    required this.idFirebase,
    required this.idDocumento,
  });

  @override
  State<InstrucaoEtapaTela> createState() => _InstrucaoEtapaTelaState();
}

class _InstrucaoEtapaTelaState extends State<InstrucaoEtapaTela> {

  @override
  void initState() {
    super.initState();
    print(widget.idFirebase);
    print(widget.idDocumento);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
