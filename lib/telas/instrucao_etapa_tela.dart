import 'package:flutter/material.dart';
import 'package:instrucao_de_processos/utilidades/variavel_estatica.dart';
import 'package:instrucao_de_processos/widgets/botao_padrao.dart';
import 'package:instrucao_de_processos/widgets/botao_padrao_nova_instrucao.dart';
import 'package:instrucao_de_processos/widgets/nivel_etapa.dart';
import 'package:instrucao_de_processos/widgets/snackBars.dart';
import 'package:instrucao_de_processos/widgets/texto_padrao.dart';
import '../utilidades/cores.dart';
import '../widgets/appbar_padrao.dart';
import '../widgets/caixa_texto.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class InstrucaoEtapaTela extends StatefulWidget {
  String idFirebase;
  String idDocumento;
  String emailLogado;

  InstrucaoEtapaTela({
    required this.idFirebase,
    required this.idDocumento,
    required this.emailLogado,
  });

  @override
  State<InstrucaoEtapaTela> createState() => _InstrucaoEtapaTelaState();
}

class _InstrucaoEtapaTelaState extends State<InstrucaoEtapaTela> {

  bool carregando = false;
  TextEditingController nomeProcesso = TextEditingController();
  TextEditingController maquina = TextEditingController();
  TextEditingController epi = TextEditingController();
  TextEditingController ferramentas = TextEditingController();
  TextEditingController materiaPrima = TextEditingController();
  TextEditingController espeficicacao = TextEditingController();
  TextEditingController prazo = TextEditingController();
  TextEditingController esp_maquina = TextEditingController();
  TextEditingController licenca_qualificacoes = TextEditingController();

  var dadosUsuarioFire;
  int numFIP = 0;
  int versao = 0;

  buscarDadosProcesso()async{
    FirebaseFirestore.instance.collection('especificacao').get().then((dadosEspecificacao){
      print(dadosEspecificacao.docs.length);
      numFIP = dadosEspecificacao.docs.length+1;
      versao = dadosEspecificacao.docs.length;
      setState(() {});
    });
  }

  buscarDadosUsuario()async{
    FirebaseFirestore.instance.collection('usuarios').doc(FirebaseAuth.instance.currentUser!.uid).get().then((dadosUsuario){
      dadosUsuarioFire = dadosUsuario;
      setState(() {});
    });
  }

  salvarNovaInstrucao()async{
    if(nomeProcesso.text.isNotEmpty && maquina.text.isNotEmpty && epi.text.isNotEmpty
        && ferramentas.text.isNotEmpty && materiaPrima.text.isNotEmpty && espeficicacao.text.isNotEmpty
        && esp_maquina.text.isNotEmpty && licenca_qualificacoes.text.isNotEmpty){

        DocumentReference docRef = FirebaseFirestore.instance.collection('especificacao').doc();
        docRef.set({
          'id' : docRef.id,
          'nome' : nomeProcesso.text.trim().toUpperCase(),
          'maquina' : maquina.text.trim().toUpperCase(),
          'epi' : epi.text.trim().toUpperCase(),
          'ferramentas' : ferramentas.text.trim().toUpperCase(),
          'materiaPrima' : materiaPrima.text.trim().toUpperCase(),
          'espeficicacao' : espeficicacao.text.trim().toUpperCase(),
          'esp_maquina' : esp_maquina.text.trim().toUpperCase(),
          'licenca_qualificacoes' : licenca_qualificacoes.text.trim().toUpperCase(),
          'visto': dadosUsuarioFire['nome'],
          'idCriador': dadosUsuarioFire['id'],
          'numeroFIP' : numFIP,
          'versao' : versao+1,
          'dataCriacao':DateTime.now(),
          'dataVersao':DateTime.now(),
        }).then((value){
          FirebaseFirestore.instance.collection('documentos').doc(widget.idFirebase).update({
            'idEsp' : docRef.id,
            'nomeProcesso':nomeProcesso.text.trim().toUpperCase()
          }).then((value){
            showSnackBar(context, 'Dados salvos com sucesso!', Colors.green);
          });
        });
    }else{
      showSnackBar(context, 'Preencha todos os campos para avançar!', Colors.red);
    }
  }

  @override
  void initState() {
    super.initState();
    buscarDadosUsuario();
    buscarDadosProcesso();
    print(widget.idFirebase);
    print(widget.idDocumento);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Cores.cinzaClaro,
      appBar: carregando?null:AppBarPadrao(showUsuarios: false,emailLogado: widget.emailLogado),
      body: Container(
        height: VariavelEstatica.altura,
        width: VariavelEstatica.largura,
        child: ListView(
          children: [
            NivelEtapa(nivel: 1),
            Container(
              width: VariavelEstatica.largura*0.8,
              height: VariavelEstatica.altura*0.75,
              margin: EdgeInsets.all(20),
              padding: EdgeInsets.all(36),
              alignment: Alignment.topLeft,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(15))
              ),
              child: ListView(
                children: [
                  Row(
                  crossAxisAlignment:CrossAxisAlignment.center ,
                  children: [
                    TextoPadrao(texto: 'Cadastrar nova Instrução de Processos',cor: Cores.primaria,negrito: FontWeight.bold,tamanhoFonte: 20,),
                    SizedBox(width: 100,),
                    TextoPadrao(texto: 'N° FIP',cor: Cores.primaria,negrito: FontWeight.bold,tamanhoFonte: 16,),
                    SizedBox(width: 10,),
                    TextoPadrao(texto: numFIP.toString(),cor: Cores.cinzaTextoEscuro,negrito: FontWeight.bold,tamanhoFonte: 16,),
                    SizedBox(width: 40,),
                    TextoPadrao(texto: 'Data de criação',cor: Cores.primaria,tamanhoFonte: 14,),
                    SizedBox(width: 10,),
                    TextoPadrao(texto: '01/03/2024',cor: Cores.cinzaTextoEscuro,tamanhoFonte: 14,),
                    SizedBox(width: 40,),
                    TextoPadrao(texto: 'Visto',cor: Cores.primaria,tamanhoFonte: 14,),
                    SizedBox(width: 10,),
                    TextoPadrao(texto: dadosUsuarioFire==null?'':dadosUsuarioFire['nome'],cor: Cores.cinzaTextoEscuro,tamanhoFonte: 14,),
                    SizedBox(width: 50,),
                    TextoPadrao(texto: 'Versão',cor: Cores.primaria,tamanhoFonte: 14,),
                    SizedBox(width: 10,),
                    TextoPadrao(texto: versao==0?'1':versao.toString(),cor: Cores.cinzaTextoEscuro,tamanhoFonte: 14,),
                    SizedBox(width: 30,),
                    TextoPadrao(texto: 'Data',cor: Cores.primaria,tamanhoFonte: 14,),
                    SizedBox(width: 10,),
                    TextoPadrao(texto: VariavelEstatica.mascaraData.format(DateTime.now()),cor: Cores.cinzaTextoEscuro,tamanhoFonte: 14,),
                  ],
                ),
                  CaixaTexto(
                    titulo: 'Nome do Processo',
                    controller: nomeProcesso,
                    largura: VariavelEstatica.largura*0.3,
                    corCaixa: Cores.cinzaClaro,
                  ),
                  Row(
                    children: [
                      CaixaTexto(
                        titulo: 'Máquina',
                        controller: maquina,
                        largura: VariavelEstatica.largura*0.45,
                        corCaixa: Cores.cinzaClaro,
                      ),
                      SizedBox(width: 30,),
                      CaixaTexto(
                        titulo: 'EPI necessário',
                        controller: epi,
                        largura: VariavelEstatica.largura*0.45,
                        corCaixa: Cores.cinzaClaro,
                      ),
                    ],
                  ),
                  CaixaTexto(
                    titulo: 'Ferramentas utilizadas',
                    controller: ferramentas,
                    largura: VariavelEstatica.largura*0.9+30,
                    corCaixa: Cores.cinzaClaro,
                  ),
                  Row(
                    children: [
                      CaixaTexto(
                        titulo: 'Matéria-prima utilizada',
                        controller: materiaPrima,
                        largura: VariavelEstatica.largura*0.45,
                        corCaixa: Cores.cinzaClaro,
                      ),
                      SizedBox(width: 30,),
                      CaixaTexto(
                        titulo: 'Tempo total das Etapas',
                        controller: TextEditingController(text: 'Cálculo automático após finalização das etapas'),
                        largura: VariavelEstatica.largura*0.25,
                        corCaixa: Cores.cinzaClaro,
                        escrever: false,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      CaixaTexto(
                        titulo: 'Específicações do Processo',
                        controller: espeficicacao,
                        largura: VariavelEstatica.largura*0.45,
                        corCaixa: Cores.cinzaClaro,
                      ),
                      SizedBox(width: 30,),
                      CaixaTexto(
                        titulo: 'Prazo de Aprendizagem',
                        controller: prazo,
                        largura: VariavelEstatica.largura*0.25,
                        corCaixa: Cores.cinzaClaro,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      CaixaTexto(
                        titulo: 'Específicações máquina',
                        controller: esp_maquina,
                        largura: VariavelEstatica.largura*0.45,
                        corCaixa: Cores.cinzaClaro,
                      ),
                      SizedBox(width: 30,),
                      CaixaTexto(
                        titulo: 'Licenças ou qualificações',
                        controller: licenca_qualificacoes,
                        largura: VariavelEstatica.largura*0.45,
                        corCaixa: Cores.cinzaClaro,
                      ),
                    ],
                  ),
                  SizedBox(height: VariavelEstatica.altura*0.1,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      BotaoPadraoNovaInstrucao(
                        texto: 'Cancelar',
                        largura: 150,
                        margemVertical: 5,
                        corBotao: Colors.black,
                        onPressed: ()=>Navigator.pop(context),
                      ),
                      SizedBox(width: 10,),
                      BotaoPadraoNovaInstrucao(
                        texto: 'Avançar',
                        largura: 150,
                        margemVertical: 5,
                        onPressed: ()=>salvarNovaInstrucao(),
                      ),
                      SizedBox(width: VariavelEstatica.largura*0.025,),
                    ],
                  )
                ]
              ),
            ),
          ],
        ),
      ),
    );
  }
}
