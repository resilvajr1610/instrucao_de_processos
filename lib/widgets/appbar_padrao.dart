import 'package:flutter/material.dart';
import 'package:instrucao_de_processos/telas/home_tela.dart';
import 'package:instrucao_de_processos/telas/login_tela.dart';
import 'package:instrucao_de_processos/telas/usuarios_tela.dart';
import 'package:instrucao_de_processos/widgets/texto_padrao.dart';
import '../utilidades/cores.dart';
import '../utilidades/variavel_estatica.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AppBarPadrao extends StatelessWidget implements PreferredSizeWidget{
  bool showUsuarios;
  String emailLogado;

  AppBarPadrao({
    required this.emailLogado,
    this.showUsuarios = false,
  });

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(100),
      child: Container(
        height: 100,
        width: VariavelEstatica.largura,
        padding: EdgeInsets.all(0),
        margin: EdgeInsets.all(0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerRight,
            end: Alignment.centerLeft,
            colors: Cores.degrade_azul, // Define your gradient colors here
          ),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(radius: 35,backgroundColor: Cores.cinzaClaro),
            ),
            TextoPadrao(texto: 'Instrução de processos',tamanhoFonte: 24,negrito: FontWeight.bold),
            Spacer(),
            showUsuarios?Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>UsuariosTela(emailLogado: emailLogado,))), icon: Icon(Icons.person_add_alt_1,color: Colors.white,size: 35,)),
            ):Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(onPressed: ()=>Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomeTela(emailLogado: emailLogado,))), icon: Icon(Icons.home,color: Colors.white,size: 35,)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                  onPressed: ()=>FirebaseAuth.instance.signOut().then((value) => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginTela()))),
                  icon: Icon(Icons.logout,color: Colors.white,size: 35,)),
            ),
          ],
        ),
      ),
    );
  }
  @override
  Size get preferredSize => Size.fromHeight(100);
}
