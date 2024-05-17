import 'package:flutter/material.dart';
import 'package:instrucao_de_processos/utilidades/variavel_estatica.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../utilidades/cores.dart';
import '../widgets/appbar_padrao.dart';
import '../widgets/item_comentario.dart';
import '../widgets/texto_padrao.dart';

class ComentarioTela extends StatefulWidget {
  String emailLogado;

  ComentarioTela({
    required this.emailLogado
  });

  @override
  State<ComentarioTela> createState() => _ComentarioTelaState();
}

class _ComentarioTelaState extends State<ComentarioTela> {

  DocumentSnapshot? docComentarios;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarPadrao(emailLogado: widget.emailLogado),
      body: Container(
        padding: EdgeInsets.all(20),
        height: VariavelEstatica.altura,
        width: VariavelEstatica.largura,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(width: 150,child: TextoPadrao(texto: 'Data',cor: Cores.primaria,alinhamentoTexto: TextAlign.center,)),
                Container(width: 100,child: TextoPadrao(texto: 'FIP',cor: Cores.primaria,alinhamentoTexto: TextAlign.center)),
                Container(width: 200,child:TextoPadrao(texto: 'Nome Processo',cor: Cores.primaria,alinhamentoTexto: TextAlign.center)),
                Container(width: 100,child: TextoPadrao(texto: 'Versão',cor: Cores.primaria,alinhamentoTexto: TextAlign.center)),
                Container(width: 150,child: TextoPadrao(texto: 'Número Etapa',cor: Cores.primaria,alinhamentoTexto: TextAlign.center)),
                Container(width: 250,child: TextoPadrao(texto: 'Nome Etapa',cor: Cores.primaria,alinhamentoTexto: TextAlign.center)),
                Container(width: 350,child: TextoPadrao(texto: 'Comentário',cor: Cores.primaria,alinhamentoTexto: TextAlign.center)),
              ],
            ),
            Container(
              width: VariavelEstatica.largura*0.7,
              height: VariavelEstatica.altura*0.8,
              child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('comentarios').snapshots(),
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
                            return ItemComentario(document: document,);
                          }).toList(),
                        ): Center(child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Não há comentários cadastros.', style: TextStyle(fontSize: 18.0),),
                        ));
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
