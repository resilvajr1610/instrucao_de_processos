import 'package:flutter/material.dart';
import 'package:instrucao_de_processos/telas/login_tela.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: LoginTela(),
    );
  }
}
