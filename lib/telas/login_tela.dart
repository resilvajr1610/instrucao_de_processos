import 'package:flutter/material.dart';
import 'package:instrucao_de_processos/utilidades/paleta_cores.dart';

class LoginTela extends StatefulWidget {
  const LoginTela({super.key});

  @override
  State<LoginTela> createState() => _LoginTelaState();
}

class _LoginTelaState extends State<LoginTela> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerRight,
            end: Alignment.centerLeft,
            colors: PaletaCores().degrade_azul, // Define your gradient colors here
          ),
        ),
        child: Center(
          child: Text(
            'Hello, Flutter!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24.0,
            ),
          ),
        ),
      ),
    );
  }
}
