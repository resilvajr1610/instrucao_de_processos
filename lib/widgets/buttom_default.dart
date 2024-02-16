import 'package:flutter/material.dart';
import 'package:instrucao_de_processos/widgets/text_default.dart';
import '../utilidades/paleta_cores.dart';
import '../utilidades/variavel_estatica.dart';

class ButtomDefault extends StatelessWidget {
  String texto;
  var onTap;

  ButtomDefault({
    required this.texto,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: VariavelEstatica.width*0.2,
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.symmetric(vertical: 45),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          gradient: LinearGradient(
            begin: Alignment.centerRight,
            end: Alignment.centerLeft,
            colors: PaletaCores.degrade_azul, // Define your gradient colors here
          ),
        ),
        child: TextDefault(text: 'Entrar',textAlign: TextAlign.center,),
      ),
    );
  }
}
