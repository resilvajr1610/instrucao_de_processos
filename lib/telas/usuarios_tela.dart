import 'package:flutter/material.dart';
import 'package:instrucao_de_processos/utilidades/cores.dart';
import 'package:instrucao_de_processos/widgets/item_radio_tipo_usuario.dart';
import 'package:instrucao_de_processos/widgets/snackBars.dart';
import 'package:instrucao_de_processos/widgets/texto_padrao.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instrucao_de_processos/widgets/titulo_padrao.dart';
import '../utilidades/variavel_estatica.dart';
import '../widgets/appbar_padrao.dart';
import '../widgets/botao_padrao.dart';
import '../widgets/caixa_texto.dart';
import '../widgets/item_usuario.dart';

class UsuariosTela extends StatefulWidget {
  String emailLogado;

  UsuariosTela({
    required this.emailLogado
  });

  @override
  State<UsuariosTela> createState() => _UsuariosTelaState();
}

class _UsuariosTelaState extends State<UsuariosTela> {

  var nome = TextEditingController();
  var funcao = TextEditingController();
  var email = TextEditingController();

  int tipoAcesso = 1;

  verificarDados(){
    if(nome.text.contains(' ') && funcao.text.isNotEmpty && email.text.contains('@') ){

      FirebaseAuth.instance.createUserWithEmailAndPassword(email: email.text.trim(), password: 'senha123')
      .catchError((error) async {
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
      })
      .then((usuario) {
        FirebaseFirestore.instance.collection('usuarios').doc(usuario.user!.uid).set({
          'email':usuario.user!.email,
          'id':usuario.user!.uid,
          'nome':nome.text.toUpperCase().trim(),
          'funcao':funcao.text.toUpperCase().trim(),
          'tipo_acesso' : tipoAcesso == 0?'ADM':'VISUALIZADOR',
          'cadastrado_por' : widget.emailLogado,
          'data_cadastro':DateTime.now()
        }).then((value){
          nome.clear();
          email.clear();
          funcao.clear();
          tipoAcesso = 0;
          showSnackBar(context, 'Cadastrado realizado com sucesso!', Colors.green);
        });
      });
    }else{
      showSnackBar(context, 'Dados incompletos para finalizar o cadastro!', Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {

    double largura = MediaQuery.of(context).size.width;
    double altura = MediaQuery.of(context).size.height;
    
    return Scaffold(
      backgroundColor: Cores.cinzaClaro,
      appBar: AppBarPadrao(emailLogado: widget.emailLogado),
      body: Container(
        width: largura>700?largura*0.7:largura,
        height: altura,
        padding: EdgeInsets.symmetric(vertical: 25,horizontal: largura>700?60:0),
        child: ListView(
          children:[
            Card(
              child: Container(
                width: largura*0.7,
                height: 380,
                padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextoPadrao(texto: 'Cadastrar novo usuário',cor: Cores.primaria,negrito: FontWeight.bold,tamanhoFonte: 20,),
                    Container(
                      width: largura>700?580:largura*0.8,
                      child: CaixaTexto(
                        titulo: 'Nome',
                        textoCaixa: 'Nome Completo',
                        controller: nome,
                        largura:largura>700?580:largura*0.8,
                        corCaixa: Cores.cinzaClaro,
                      ),
                    ),
                    Container(
                      width: largura>700?580:largura*0.8,
                      height: 80,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CaixaTexto(
                            titulo: 'Função',
                            textoCaixa: 'Função do usuário',
                            controller: funcao,
                            largura:largura>700?350:largura*0.31,
                            corCaixa: Cores.cinzaClaro,
                          ),
                          Spacer(),
                          ItemRadioTipoUsuario(
                              value: 0,
                              texto: 'ADM',
                              tipoAcesso: tipoAcesso,
                              onChanged: (int? value){
                                setState(() {
                                  tipoAcesso = value!;
                                  print("tipo acesso : $tipoAcesso");
                                });
                              }
                          ),
                          ItemRadioTipoUsuario(
                              value: 1,
                              texto: 'VISUALIZADOR',
                              tipoAcesso: tipoAcesso,
                              onChanged: (int? value){
                                setState(() {
                                  tipoAcesso = value!;
                                  print("tipo acesso : $tipoAcesso");
                                });
                              }
                          ),
                          SizedBox(width: 5,)
                        ],
                      ),
                    ),
                    Container(
                      width: largura>700?580:largura*0.8,
                      child: CaixaTexto(
                        titulo: 'E - mail',
                        textoCaixa: 'usuario@email.com',
                        controller: email,
                        largura:largura>700?580:largura*0.8,
                        corCaixa: Cores.cinzaClaro,
                      ),
                    ),
                    Container(
                      height: 50,
                      width: largura>700?580:largura*0.8,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          largura>700?TextoPadrao(texto: 'Observação: A senha padrão é “senha123”, deverá ser alterada no primeiro acesso!',cor: Cores.primaria,tamanhoFonte: 14,negrito: FontWeight.bold,):Container(),
                          Spacer(),
                          BotaoPadrao(onTap: ()=>verificarDados(),texto: 'Cadastrar',largura: 142,margemVertical: 0,)
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Card(
              child: Container(
                width: largura>700?largura*0.7:largura,
                padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextoPadrao(texto: 'Usuários cadastrados',cor: Cores.primaria,negrito: FontWeight.bold,tamanhoFonte: 20,),
                    Row(
                      children: [
                        Container(width: largura>700?300:largura*0.5,child: TextoPadrao(texto: 'Nome',cor: Cores.primaria,)),
                        largura>700?Container(width: 200,child: TextoPadrao(texto: 'Função',cor: Cores.primaria)):Container(),
                        largura>700?Container(width: 300,child:TextoPadrao(texto: 'E-mail',cor: Cores.primaria)):Container(),
                        largura>700?Container():SizedBox(width: 10,),
                        Container(width: largura>700?200:largura*0.3,child: TextoPadrao(texto: 'Tipo',cor: Cores.primaria)),
                      ],
                    ),
                    Container(
                      width: largura>700?largura*0.7:largura,
                      height: 380,
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance.collection('usuarios').snapshots(),
                        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError) {
                            print(snapshot.error);
                            return Text('Isto é um erro. Por gentileza, contate o suporte.');
                          }
                          switch (snapshot.connectionState) {
                            case ConnectionState.waiting:
                              return Container();
                            default:
                              return (snapshot.data!.docs.length >= 1)
                                  ? ListView(
                                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                                  return ItemUsuario(
                                    document: document,
                                  );
                                }).toList(),
                              ): Center(child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Não há usuários cadastros.', style: TextStyle(fontSize: 18.0),),
                              ));
                          }
                        }),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
