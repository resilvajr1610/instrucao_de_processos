import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:instrucao_de_processos/modelos/modelo_etapa2.dart';
import 'package:instrucao_de_processos/modelos/modelo_analise2.dart';
import 'package:instrucao_de_processos/telas/instrucao_terceira_etapa_tela.dart';
import 'package:instrucao_de_processos/widgets/item_etapa2.dart';
import 'package:instrucao_de_processos/widgets/snackBars.dart';
import '../utilidades/cores.dart';
import '../utilidades/variavel_estatica.dart';
import '../widgets/appbar_padrao.dart';
import '../widgets/botao_padrao_nova_instrucao.dart';
import '../widgets/caixa_texto.dart';
import '../widgets/item_analise2.dart';
import '../widgets/nivel_etapa2.dart';
import '../widgets/texto_padrao.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class InstrucaoSegundaEtapaTela extends StatefulWidget {
  String emailLogado;
  String nomeProcesso;
  int FIP;
  String idEsp;
  bool etapaCriada;

  InstrucaoSegundaEtapaTela({
    required this.emailLogado,
    required this.nomeProcesso,
    required this.FIP,
    required this.idEsp,
    required this.etapaCriada,
  });

  @override
  State<InstrucaoSegundaEtapaTela> createState() =>_InstrucaoSegundaEtapaTelaState();
}

class _InstrucaoSegundaEtapaTelaState extends State<InstrucaoSegundaEtapaTela> {
  bool carregando = false;
  var observacoes = TextEditingController();
  var alteracao = TextEditingController();

  List  <ModeloEtapa2> listaEtapas = [];

  double alturaMostrarIcones = 0;

  double alturaGeral = 150;
  double estenderItem = 40;

  iniciarEtapa(bool iniciar, int i){

    if(!iniciar){
      listaEtapas[i].adicionaNovo = 1;
    }

    listaEtapas.add(
        ModeloEtapa2(
            idEsp: widget.idEsp,
            nomeProcesso: widget.nomeProcesso,
            numeroFIP: widget.FIP,
            numeroEtapa: listaEtapas.length +1,
            nomeEtapa: TextEditingController(),
            tempoTotalEtapaSegundos: 0,
            tempoTotalEtapaMinutos: '0:00',
            etapaAtiva: false,
            listaAnalise: [
              ModeloAnalise2(
                analiseAtiva: false,
                etapaAtiva: false,
                imagemSelecionada: '',
                numeroAnalise: i!=0?i*10:10,
                nomeAnalise: TextEditingController(),
                tempoAnalise: TextEditingController(),
                pontoChave: TextEditingController(),
                mostrarListaImagens: false,
                listaCompleta: false
              )
            ],
            aumentarAlturaContainer: false,
            adicionarChaveRazao: false,
            ativarCaixaEtapa: false,
            adicionaNovo: 0
        )
    );
  }

  carregarEtapa() {
    FirebaseFirestore.instance
        .collection('etapas')
        .doc(widget.idEsp)
        .get()
        .then((etapasDoc) {
      List<dynamic> listaMapEtapa = etapasDoc['listaEtapa'];

      for (int i = 0; i < listaMapEtapa.length; i++) {
        List<dynamic> listaMapAnalise = listaMapEtapa[i]['listaAnalise'];
        List<ModeloAnalise2> listaAnalise = [];

        for (int j = 0; j < listaMapAnalise.length; j++) {
          listaAnalise.add(
              ModeloAnalise2(
                  analiseAtiva: true,
                  etapaAtiva: true,
                  imagemSelecionada: listaMapAnalise[j]['imagemSelecionada'],
                  numeroAnalise: listaMapAnalise[j]['numeroAnalise'],
                  nomeAnalise: TextEditingController(text: listaMapAnalise[j]['nomeAnalise']),
                  tempoAnalise: TextEditingController(text: listaMapAnalise[j]['tempoAnalise']),
                  pontoChave: TextEditingController(text: listaMapAnalise[j]['pontoChave']),
                  mostrarListaImagens: false,
                  listaCompleta: true,
              )
          );
        }

        listaEtapas.add(
            ModeloEtapa2(
                idEsp: widget.idEsp,
                nomeProcesso: widget.nomeProcesso,
                numeroFIP: widget.FIP,
                numeroEtapa: listaMapEtapa[i]['numeroEtapa'],
                nomeEtapa: TextEditingController(text: listaMapEtapa[i]['nomeEtapa']),
                tempoTotalEtapaSegundos: listaMapEtapa[i]['tempoTotalEtapaSegundos'],
                tempoTotalEtapaMinutos: listaMapEtapa[i]['tempoTotalEtapaMinutos'],
                etapaAtiva: true,
                listaAnalise: listaAnalise,
                aumentarAlturaContainer: false,
                adicionarChaveRazao: false,
                ativarCaixaEtapa: true,
                adicionaNovo: 1
            )
        );
      }
      observacoes.text = etapasDoc['observacoes'];
      alteracao.text = etapasDoc['alteracao'];
      iniciarEtapa(false,0);
      setState(() {});
    });
  }



  editarEtapa() {
    showSnackBar(context, 'Etapas foram salvas', Colors.green);
    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>InstrucaoTerceiraEtapaTela(emailLogado: widget.emailLogado,idEtapa: widget.idEsp,)));
  }

  salvarEtapa() {

    if(observacoes.text.isNotEmpty && alteracao.text.isNotEmpty && listaEtapas[0].adicionaNovo!=0){

      List <Map> listaMapEtapa = [];

      for(int i = 0; listaEtapas.length > i; i++){
        List <Map> listaMapAnalise = [];
        for(int j = 0; listaEtapas[i].listaAnalise.length > j; j++){
          if(listaEtapas[i].listaAnalise[j].nomeAnalise.text.isNotEmpty){
            listaMapAnalise.add({
              'j':j,
              'imagemSelecionada' : listaEtapas[i].listaAnalise[j].imagemSelecionada,
              'numeroAnalise' : listaEtapas[i].listaAnalise[j].numeroAnalise,
              'nomeAnalise' : listaEtapas[i].listaAnalise[j].nomeAnalise.text.trim().toUpperCase(),
              'tempoAnalise' : listaEtapas[i].listaAnalise[j].tempoAnalise.text,
              'pontoChave' : listaEtapas[i].listaAnalise[j].pontoChave.text.trim().toUpperCase(),
            });
          }
        }
        if(listaEtapas[i].nomeEtapa.text.isNotEmpty){
          listaMapEtapa.add({
            'i':i,
            'nomeProcesso': listaEtapas[i].nomeProcesso,
            'numeroFIP': listaEtapas[i].numeroFIP,
            'numeroEtapa': listaEtapas[i].numeroEtapa,
            'nomeEtapa': listaEtapas[i].nomeEtapa.text.trim().toUpperCase(),
            'tempoTotalEtapaSegundos': listaEtapas[i].tempoTotalEtapaSegundos,
            'tempoTotalEtapaMinutos': listaEtapas[i].tempoTotalEtapaMinutos,
            'listaAnalise': listaMapAnalise,
          });
        }
      }

      FirebaseFirestore.instance.collection('etapas').doc(widget.idEsp).set({
        'idEsp'       : widget.idEsp,
        'listaEtapa'  : listaMapEtapa,
        'observacoes' : observacoes.text,
        'alteracao'   : alteracao.text,
        'idUsuario'   : FirebaseAuth.instance.currentUser!.uid,
        'idEmail'     : FirebaseAuth.instance.currentUser!.email,
        'dataCriacao' : DateTime.now(),
      },SetOptions(merge: true)).then((value){
        FirebaseFirestore.instance.collection('especificacao').doc(widget.idEsp).update({
          'etapa' : 'criada'
        }).then((value){
          showSnackBar(context, 'Etapas foram salvas', Colors.green);
          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>InstrucaoTerceiraEtapaTela(emailLogado: widget.emailLogado,idEtapa: widget.idEsp,)));
        });
      });
    }else{
      showSnackBar(context, 'Insira ao menos uma etapa e uma análise para avançar', Colors.red);
    }
  }

  @override
  void initState() {
    super.initState();
    if(widget.etapaCriada){
      carregarEtapa();
    }else{
      iniciarEtapa(true,0);
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Cores.cinzaClaro,
      appBar: carregando ? null: AppBarPadrao(mostrarUsuarios: false, emailLogado: widget.emailLogado),
      body: Container(
        height: VariavelEstatica.altura,
        width: VariavelEstatica.largura,
        child: ListView(
          children: [
            NivelEtapa(nivel: 2),
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
              child: Container(
                width: 1300,
                child: ListView(
                  children: [
                    TextoPadrao(texto: 'Inserir Etapas da Instrução de Processos',cor: Cores.primaria,negrito: FontWeight.bold,tamanhoFonte: 20,),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        crossAxisAlignment:CrossAxisAlignment.center ,
                        children: [
                          TextoPadrao(texto: 'N° FIP',cor: Cores.primaria,negrito: FontWeight.bold,tamanhoFonte: 16,),
                          SizedBox(width: 10,),
                          TextoPadrao(texto: widget.FIP.toString(),cor: Cores.cinzaTextoEscuro,negrito: FontWeight.bold,tamanhoFonte: 16,),
                          SizedBox(width: 40,),
                          TextoPadrao(texto: 'Nome de Processos',cor: Cores.primaria,negrito: FontWeight.bold,tamanhoFonte: 16,),
                          SizedBox(width: 10,),
                          TextoPadrao(texto: widget.nomeProcesso,cor: Cores.cinzaTextoEscuro,negrito: FontWeight.bold,tamanhoFonte: 16,),
                        ],
                      ),
                    ),
                    Container(
                      height: (alturaGeral*listaEtapas.length)+alturaMostrarIcones,
                      child: ListView.builder(
                          itemCount: listaEtapas.length,
                          itemBuilder: (context,i){
                            return ItemEtapa2(
                              modeloEtapa: listaEtapas[i],
                              botaoAtivaEtapa: (){
                                  if(listaEtapas[i].nomeEtapa.text.isNotEmpty){
                                    listaEtapas[i].adicionarChaveRazao = listaEtapas[i].adicionarChaveRazao?false:true;
                                    if(listaEtapas[i].adicionarChaveRazao){
                                      alturaMostrarIcones = alturaMostrarIcones + 60;
                                      print('add geral');
                                      print(alturaGeral);
                                      print('add icones');
                                      print(alturaMostrarIcones);

                                    }else{
                                      if(listaEtapas[i].listaAnalise.length!=1){
                                        alturaMostrarIcones = alturaMostrarIcones - 60;
                                      }
                                      print('menos geral');
                                      print(alturaGeral);
                                      print('menos icones');
                                      print(alturaMostrarIcones);
                                    }

                                    if(!listaEtapas[i].ativarCaixaEtapa){
                                      listaEtapas[i].ativarCaixaEtapa = true;
                                      listaEtapas[i].listaAnalise[0].analiseAtiva = true;
                                    }
                                    setState(() {});
                                  }else{
                                    showSnackBar(context, 'Adicionar um texto para avançar', Colors.red);
                                  }
                                },
                              listViewAnalise: Container(
                                height: listaEtapas[i].listaAnalise.length*60+alturaMostrarIcones,
                                child: ListView.builder(
                                    itemCount: listaEtapas[i].listaAnalise.length,
                                    itemBuilder: (context, j){
                                      return Container(
                                        height: 60,
                                        child: ItemAnalise2(
                                            modeloAnalise: listaEtapas[i].listaAnalise[j],
                                            botaoMostrarListaImagem:  ()=>setState((){
                                              listaEtapas[i].listaAnalise[j].mostrarListaImagens=true;
                                              alturaMostrarIcones = 100;
                                            }),
                                            botaoSalvarNovaAnalise: (){
                                              if(!listaEtapas[i].listaAnalise[j].listaCompleta){
                                                if(listaEtapas[i].listaAnalise[j].nomeAnalise.text.isNotEmpty
                                                    && listaEtapas[i].listaAnalise[j].tempoAnalise.text.isNotEmpty
                                                    && listaEtapas[i].listaAnalise[j].pontoChave.text.isNotEmpty
                                                ){
                                                  if(listaEtapas[i].listaAnalise[j].analiseAtiva){
                                                    listaEtapas[i].tempoTotalEtapaSegundos = int.parse(listaEtapas[i].listaAnalise[j].tempoAnalise.text.trim()) + listaEtapas[i].tempoTotalEtapaSegundos;
                                                    listaEtapas[i].listaAnalise[j].listaCompleta = true;

                                                    print('verifica adicionar ${listaEtapas[i].adicionaNovo}');
                                                      if(listaEtapas[i].adicionaNovo==0){
                                                        print('novo adicionado ${i}');
                                                        print(listaEtapas[i].adicionaNovo);
                                                        iniciarEtapa(false, i);
                                                      }

                                                    listaEtapas[i].listaAnalise.add(
                                                        ModeloAnalise2(
                                                            etapaAtiva: true,
                                                            imagemSelecionada: '',
                                                            numeroAnalise: listaEtapas[i].listaAnalise[j].numeroAnalise+10,
                                                            nomeAnalise: TextEditingController(),
                                                            tempoAnalise: TextEditingController(),
                                                            pontoChave: TextEditingController(),
                                                            mostrarListaImagens: false,
                                                            analiseAtiva: true,
                                                            listaCompleta: false
                                                        )
                                                    );
                                                    int minutos = listaEtapas[i].tempoTotalEtapaSegundos ~/60;
                                                    double segundos = listaEtapas[i].tempoTotalEtapaSegundos % 60;
                                                    listaEtapas[i].tempoTotalEtapaMinutos = '${minutos>9?'':'0'}${minutos}:${segundos>9?'':'0'}$segundos';

                                                    setState(()=>listaEtapas[i].listaAnalise[j].analiseAtiva=listaEtapas[i].listaAnalise[j].analiseAtiva?false:true);
                                                  }
                                                }else{
                                                  setState(()=>listaEtapas[i].listaAnalise[j].analiseAtiva=false);
                                                  showSnackBar(context, 'preencha todas as informações para avançar', Colors.red);
                                                }
                                              }else{
                                                listaEtapas[i].tempoTotalEtapaSegundos = listaEtapas[i].tempoTotalEtapaSegundos - int.parse(listaEtapas[i].listaAnalise[j].tempoAnalise.text.trim());
                                                int minutos = listaEtapas[i].tempoTotalEtapaSegundos ~/60;
                                                double segundos = listaEtapas[i].tempoTotalEtapaSegundos % 60;
                                                listaEtapas[i].tempoTotalEtapaMinutos = '${minutos>9?'':'0'}${minutos}:${segundos>9?'':'0'}$segundos';

                                                listaEtapas[i].listaAnalise.removeAt(j);
                                                if(listaEtapas[i].listaAnalise.length!=1){
                                                  alturaMostrarIcones = alturaMostrarIcones-60;
                                                }

                                                setState(() {});
                                              }
                                            },
                                            listViewImagens: ListView.builder(
                                              itemCount: VariavelEstatica.listaImagens.length,
                                              itemBuilder: (context, k){
                                                return GestureDetector(
                                                  onTap: (){
                                                    listaEtapas[i].listaAnalise[j].imagemSelecionada = VariavelEstatica.listaImagens[k];
                                                    listaEtapas[i].listaAnalise[j].mostrarListaImagens=false;
                                                    listaEtapas[i].aumentarAlturaContainer = false;
                                                    alturaMostrarIcones = 0;
                                                    setState(() {});
                                                  },
                                                  child: Container(
                                                      padding: EdgeInsets.all(5),
                                                      width: 50,
                                                      height: 50,
                                                      child: Image.asset(VariavelEstatica.listaImagens[k])
                                                  ),
                                                );
                                              },
                                            )
                                        ),
                                      );
                                    }
                                ),
                              ),
                            );
                          }
                      ),
                    ),
                    SizedBox(height: 25,),
                    TextoPadrao(texto:'Observações Gerais/O que é proibido e porque?',cor: Cores.primaria,negrito: FontWeight.bold,tamanhoFonte: 14,),
                    CaixaTexto(
                      mostrarTitulo: false,
                      textoCaixa: 'Informar observações',
                      titulo: '',
                      controller: observacoes,
                      largura: 950,
                      corCaixa: Cores.cinzaClaro,
                    ),
                    TextoPadrao(texto:'Motivo da alteração',cor: Cores.primaria,negrito: FontWeight.bold,tamanhoFonte: 14,),
                    CaixaTexto(
                      mostrarTitulo: false,
                      textoCaixa: 'Informe o que alterou',
                      titulo: '',
                      controller: alteracao,
                      largura: 950,
                      corCaixa: Cores.cinzaClaro,
                    ),
                    SizedBox(height: VariavelEstatica.altura*0.1,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        BotaoPadraoNovaInstrucao(
                          texto: 'Voltar',
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
                          onPressed: ()=>widget.etapaCriada?editarEtapa():salvarEtapa(),
                        ),
                        SizedBox(width: VariavelEstatica.largura*0.025,),
                      ],
                    )
                  ],
                ),
              ),
            )
          ]
        )
      )
    );
  }
}
