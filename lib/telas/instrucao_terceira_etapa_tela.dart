import 'package:flutter/material.dart';
import '../utilidades/cores.dart';
import '../utilidades/variavel_estatica.dart';
import '../widgets/appbar_padrao.dart';
import '../widgets/nivel_etapa.dart';

class InstrucaoTerceiraEtapaTela extends StatefulWidget {
  String emailLogado;
  String idEtapa;

  InstrucaoTerceiraEtapaTela({
    required this.emailLogado,
    required this.idEtapa,
  });

  @override
  State<InstrucaoTerceiraEtapaTela> createState() =>
      _InstrucaoTerceiraEtapaTelaState();
}

class _InstrucaoTerceiraEtapaTelaState
    extends State<InstrucaoTerceiraEtapaTela> {
  bool carregando = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Cores.cinzaClaro,
        appBar: carregando? null: AppBarPadrao(showUsuarios: false, emailLogado: widget.emailLogado),
        body: Container(
            height: VariavelEstatica.altura,
            width: VariavelEstatica.largura,
            child: ListView(
                children: [
                  NivelEtapa(nivel: 3),
                  Container(
                    width: VariavelEstatica.largura * 0.8,
                    height: VariavelEstatica.altura * 0.75,
                    margin: EdgeInsets.all(20),
                    padding: EdgeInsets.all(36),
                    alignment: Alignment.topLeft,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(15))
                    ),
                  )
                ]
            )
        )
    );
  }
}
