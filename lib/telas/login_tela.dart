import 'package:flutter/material.dart';
import 'package:instrucao_de_processos/telas/home_tela.dart';
import 'package:instrucao_de_processos/utilidades/cores.dart';
import 'package:instrucao_de_processos/widgets/caixa_texto.dart';
import 'package:instrucao_de_processos/widgets/snackBars.dart';
import '../utilidades/variavel_estatica.dart';
import '../widgets/botao_padrao.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginTela extends StatefulWidget {
  const LoginTela({super.key});

  @override
  State<LoginTela> createState() => _LoginTelaState();
}

class _LoginTelaState extends State<LoginTela> {

  // var email = TextEditingController(text: 'teste123@gmail.com');
  // var senha = TextEditingController(text: 'senha123');

  var email = TextEditingController();
  var senha = TextEditingController();

  bool obscure = true;

  checkLogin(){
    if(email.text.isNotEmpty && senha.text.isNotEmpty){
      FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.text.trim(),
        password: senha.text.trim())
      .then((user) async {
        showSnackBar(context, 'Usuário Logado!',Colors.green);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeTela(emailLogado: email.text,)));
      }).catchError((error) async {

        switch (error.toString()) {
          case '[firebase_auth/unknown] An unknown error occurred: FirebaseError: Firebase: The email address is badly formatted. (auth/invalid-email).':
            showSnackBar(context,'O e-mail digitado é inválido.\n Tente novamente.',Colors.red);
            break;
          case '[firebase_auth/unknown] An unknown error occurred: FirebaseError: Firebase: The supplied auth credential is incorrect, malformed or has expired. (auth/invalid-credential).':
            showSnackBar(context,'E-mail ou senha incorreta.\n Tente novamente.',Colors.red);
            break;
          case '[firebase_auth/wrong-password] The password is invalid or the user does not have a password.':
            showSnackBar(context,'E-mail ou senha incorreta.\n Tente novamente.',Colors.red);
            break;
          case '[firebase_auth/too-many-requests] Access to this account has been temporarily disabled due to many failed login attempts. You can immediately restore it by resetting your password or you can try again later.':
            showSnackBar(context, 'Sua conta foi bloqueada provisoriamente.\n Tente mais tarde.',Colors.red);
            break;
          default:
            showSnackBar(context, error.toString(),Colors.red);
            break;
        }
      });
    }else{
      showSnackBar(context, 'Preencha seu email e senha para continuar!',Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {

    VariavelEstatica.inicializarDimensoes(context);

    return Scaffold(
      body: Container(
        width: VariavelEstatica.largura,
        height: VariavelEstatica.altura,
        alignment: Alignment.bottomCenter,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerRight,
            end: Alignment.centerLeft,
            colors: Cores.degrade_azul, // Define your gradient colors here
          ),
        ),
        child: Container(
          width: VariavelEstatica.largura*0.35,
          height: VariavelEstatica.altura*0.8,
          decoration: BoxDecoration(
              color: Cores.cinzaClaro,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40.0),
                topRight: Radius.circular(40.0),
              )
          ),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: VariavelEstatica.altura*0.07,bottom: VariavelEstatica.altura*0.08),
                child: Text(
                  'Instrução\nde\nProcessos',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Cores.primaria,
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.bold,
                    fontSize: 48.0,
                  ),
                ),
              ),
              CaixaTexto(
                titulo: 'E-mail',
                controller: email,
                largura: VariavelEstatica.largura*0.2
              ),
              CaixaTexto(
                titulo: 'Senha',
                controller: senha,
                largura: VariavelEstatica.largura*0.2,
                obscure: obscure,
                mostrarOlho: true,
                onPressedSenha: ()=>setState(()=>obscure?obscure=false:obscure=true),
              ),
              BotaoPadrao(
                texto: 'Entrar',
                onTap: checkLogin,
                largura: VariavelEstatica.largura*0.2,
              )
            ],
          ),
        ),
      ),
    );
  }
}
