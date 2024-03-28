import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:instrucao_de_processos/telas/login_tela.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:instrucao_de_processos/telas/teste.dart';
import 'package:instrucao_de_processos/telas/usuarios_tela.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  kIsWeb? await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyDMZEqs-YW1yQ9q2EzT6Mf6STnSnQ9Du1I",
      appId: "1:349119442488:web:61c64129c8e1e1d4f400cd",
      messagingSenderId:"349119442488",
      projectId: "instrucao-de-trabalho",
      storageBucket: "instrucao-de-trabalho.appspot.com",
    ),
  ):await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Instrução de Processos',
      home: LoginTela(),
      // home: Teste(),
    );
  }
}
