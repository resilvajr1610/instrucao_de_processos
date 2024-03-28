import 'package:flutter/material.dart';
import 'package:instrucao_de_processos/telas/login_tela.dart';
import 'package:firebase_core/firebase_core.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
        apiKey: "AIzaSyDMZEqs-YW1yQ9q2EzT6Mf6STnSnQ9Du1I",
        authDomain: "instrucao-de-trabalho.firebaseapp.com",
        projectId: "instrucao-de-trabalho",
        storageBucket: "instrucao-de-trabalho.appspot.com",
        databaseURL: "https://instrucao-de-trabalho.firebaseio.com",
        messagingSenderId: "349119442488",
        appId: "1:349119442488:web:61c64129c8e1e1d4f400cd",
        measurementId: "G-BFCT2REF57"
    )
  );
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
