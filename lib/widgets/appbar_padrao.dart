import 'package:flutter/material.dart';
import 'package:instrucao_de_processos/telas/home_tela.dart';
import 'package:instrucao_de_processos/telas/login_tela.dart';
import 'package:instrucao_de_processos/telas/usuarios_tela.dart';
import 'package:instrucao_de_processos/widgets/texto_padrao.dart';
import '../servicos/shared_preferences_servicos.dart';
import '../telas/comentarios_tela.dart';
import '../utilidades/cores.dart';
import '../utilidades/variavel_estatica.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AppBarPadrao extends StatelessWidget implements PreferredSizeWidget{
  bool mostrarUsuarios;
  bool mostrarComentarios;
  String emailLogado;

  AppBarPadrao({
    required this.emailLogado,
    this.mostrarUsuarios = false,
    this.mostrarComentarios = false,
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
            Container(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(radius: 35,backgroundColor: Cores.azul_escuro_degrade,backgroundImage: AssetImage('assets/imagens/logo.png',)),
            ),
            TextoPadrao(texto: 'Instrução de processos',tamanhoFonte: 24,negrito: FontWeight.bold),
            Spacer(),
            mostrarComentarios?Padding(
              padding: const EdgeInsets.all(8.0),
              child: Tooltip(
                message: 'Comentários',
                child: IconButton(
                    onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>ComentarioTela(emailLogado: emailLogado,))),
                    icon: Icon(Icons.report_problem,color: Colors.white,size: 35,)),
              ),
            ):Container(),
            mostrarUsuarios && mostrarComentarios?Tooltip(
              message: 'Cadastrar novo usuário',
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>UsuariosTela(emailLogado: emailLogado,))), icon: Icon(Icons.person_add_alt_1,color: Colors.white,size: 35,)),
              ),
            ):Tooltip(
              message: 'Tela Inicial',
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(onPressed: ()=>Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomeTela(emailLogado: emailLogado,))), icon: Icon(Icons.home,color: Colors.white,size: 35,)),
              ),
            ),
            Tooltip(
              message: 'Sair',
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                    onPressed: ()=>
                      PrefService().removerConta().then((value)=>
                        FirebaseAuth.instance.signOut().then((value) =>
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginTela()))
                        )
                      ),
                    icon: Icon(Icons.logout,color: Colors.white,size: 35,)),
              ),
            ),
          ],
        ),
      ),
    );
  }
  @override
  Size get preferredSize => Size.fromHeight(100);
}
