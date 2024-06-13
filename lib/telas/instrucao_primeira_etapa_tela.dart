import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:instrucao_de_processos/modelos/bad_state_int.dart';
import 'package:instrucao_de_processos/modelos/bad_state_list.dart';
import 'package:instrucao_de_processos/modelos/bad_state_string.dart';
import 'package:instrucao_de_processos/telas/instrucao_segunda_etapa_tela.dart';
import 'package:instrucao_de_processos/utilidades/variavel_estatica.dart';
import 'package:instrucao_de_processos/widgets/botao_padrao.dart';
import 'package:instrucao_de_processos/widgets/nivel_etapa2.dart';
import 'package:instrucao_de_processos/widgets/snackBars.dart';
import 'package:instrucao_de_processos/widgets/texto_padrao.dart';
import '../utilidades/cores.dart';
import '../widgets/appbar_padrao.dart';
import '../widgets/botao_padrao_nova_instrucao.dart';
import '../widgets/caixa_texto.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/titulo_padrao.dart';

class InstrucaoPrimeiraEtapaTela extends StatefulWidget {
  String idFirebase;
  String idDocumento;
  String idEsp;
  String emailLogado;
  String nomeProcedimento;

  InstrucaoPrimeiraEtapaTela({
    required this.idFirebase,
    required this.idDocumento,
    required this.idEsp,
    required this.emailLogado,
    required this.nomeProcedimento,
  });

  @override
  State<InstrucaoPrimeiraEtapaTela> createState() => _InstrucaoPrimeiraEtapaTelaState();
}

class _InstrucaoPrimeiraEtapaTelaState extends State<InstrucaoPrimeiraEtapaTela> {

  bool carregando = true;
  TextEditingController nomeProcesso = TextEditingController();
  TextEditingController maquina = TextEditingController();
  TextEditingController epi = TextEditingController();
  TextEditingController ferramentas = TextEditingController();
  TextEditingController materiaPrima = TextEditingController();
  TextEditingController tempoEtapas = TextEditingController(text: 'Cálculo automático após finalização das etapas');
  TextEditingController espeficicacao = TextEditingController();
  TextEditingController prazo = TextEditingController();
  TextEditingController esp_maquina = TextEditingController();
  TextEditingController licenca_qualificacoes = TextEditingController();

  List listaFiltroBancoEpi = [];
  List listaFiltroBancoFerramenta = [];
  List listaFiltroBancoMaterial = [];

  List listaTagBancoEpi = [];
  List listaTagBancoFerramenta = [];
  List listaTagBancoMaterial = [];

  List listaTagDocEpi = [];
  List listaTagDocFerramenta = [];
  List listaTagDocMaterial = [];

  var dadosUsuarioFire;
  int versao = 0;

  final ScrollController scrollEPI = ScrollController();
  final ScrollController scrollFerramenta = ScrollController();
  final ScrollController scrollMaterial = ScrollController();

  DateTime dataCriacao = DateTime.now();
  DateTime dataVersao = DateTime.now();

  buscarDadosProcesso()async{
    nomeProcesso.text = widget.nomeProcedimento;
    if(widget.idEsp == ''){
      FirebaseFirestore.instance.collection('especificacao').get().then((dadosEspecificacao){
          carregando=false;
          setState(() {});
      });
    }else{
      FirebaseFirestore.instance.collection('especificacao').doc(widget.idEsp).get().then((dados){
        versao = BadStateInt(dados, 'versao');
        nomeProcesso.text = BadStateString(dados, 'nome');
        listaTagDocEpi = BadStateList(dados, 'epi');
        listaTagDocFerramenta = BadStateList(dados, 'ferramentas');
        listaTagDocMaterial = BadStateList(dados, 'materiaPrima');
        maquina.text = BadStateString(dados, 'maquina');
        espeficicacao.text = BadStateString(dados, 'espeficicacao');
        prazo.text = BadStateString(dados, 'prazo');
        esp_maquina.text = BadStateString(dados, 'esp_maquina');
        licenca_qualificacoes.text = BadStateString(dados, 'licenca_qualificacoes');
        tempoEtapas.text = BadStateInt(dados, 'totalEtapas')!=0?'${BadStateInt(dados, 'totalEtapas')} min':'Cálculo automático após finalização das etapas';
        dataCriacao = dados['dataCriacao'].toDate();
        dataVersao = dados['dataVersao'].toDate();
        carregando=false;
        setState(() {});
      });
    }
  }

  buscarDadosUsuario()async{
    FirebaseFirestore.instance.collection('usuarios').doc(FirebaseAuth.instance.currentUser!.uid).get().then((dadosUsuario){
      dadosUsuarioFire = dadosUsuario;
      buscarListaEPI();
    });
  }

  salvarNovaInstrucao()async{
    if(nomeProcesso.text.isNotEmpty && maquina.text.isNotEmpty && espeficicacao.text.isNotEmpty
        && esp_maquina.text.isNotEmpty && licenca_qualificacoes.text.isNotEmpty){

        DocumentReference docRef = FirebaseFirestore.instance.collection('especificacao').doc();
        docRef.set({
          'id' : docRef.id,
          'nome' : nomeProcesso.text.trim().toUpperCase(),
          'maquina' : maquina.text.trim().toUpperCase(),
          'epi' : listaTagDocEpi,
          'ferramentas' : listaTagDocFerramenta,
          'materiaPrima' : listaTagDocMaterial,
          'espeficicacao' : espeficicacao.text.trim().toUpperCase(),
          'esp_maquina' : esp_maquina.text.trim().toUpperCase(),
          'licenca_qualificacoes' : licenca_qualificacoes.text.trim().toUpperCase(),
          'prazo' : prazo.text.trim().toUpperCase(),
          'visto': dadosUsuarioFire['nome'],
          'idCriador': dadosUsuarioFire['id'],
          'numeroFIP' : widget.idDocumento,
          'versao' : versao+1,
          'dataCriacao':DateTime.now(),
          'dataVersao':DateTime.now(),
        }).then((value){
          FirebaseFirestore.instance.collection('documentos').doc(widget.idFirebase).update({
            'listaIdEsp'  : FieldValue.arrayUnion([docRef.id]),
            'listaVersao':FieldValue.arrayUnion([nomeProcesso.text.trim().toUpperCase() +' ${versao+1}']),
            'versao' : versao+1,
            'numeroFIP' : widget.idDocumento,
          }).then((value){
            showSnackBar(context, 'Dados salvos com sucesso!', Colors.green);
            Navigator.push(context, MaterialPageRoute(builder: (context)=>
                InstrucaoSegundaEtapaTela(
                  emailLogado: widget.emailLogado,
                  nomeProcesso: nomeProcesso.text,
                  FIP: widget.idDocumento,
                  idEspAtual: docRef.id,
                  etapaCriada: false,
                  idEspAnterior: '',
                )
              )
            );
          });
        });
    }else{
      showSnackBar(context, 'Preencha todos os campos para avançar!', Colors.red);
    }
  }

  editarInstrucao() {
    if(nomeProcesso.text.isNotEmpty && maquina.text.isNotEmpty && espeficicacao.text.isNotEmpty
        && esp_maquina.text.isNotEmpty && licenca_qualificacoes.text.isNotEmpty){

      DocumentReference docRef = FirebaseFirestore.instance.collection('especificacao').doc();
      docRef.set({
        'id' : docRef.id,
        'nome' : nomeProcesso.text.trim().toUpperCase(),
        'maquina' : maquina.text.trim().toUpperCase(),
        'epi' : listaTagDocEpi,
        'ferramentas' : listaTagDocFerramenta,
        'materiaPrima' : listaTagDocMaterial,
        'espeficicacao' : espeficicacao.text.trim().toUpperCase(),
        'esp_maquina' : esp_maquina.text.trim().toUpperCase(),
        'licenca_qualificacoes' : licenca_qualificacoes.text.trim().toUpperCase(),
        'prazo' : prazo.text.trim().toUpperCase(),
        'visto': dadosUsuarioFire['nome'],
        'idCriador': dadosUsuarioFire['id'],
        'numeroFIP' : widget.idDocumento,
        'versao' : versao+1,
        'dataCriacao':dataCriacao,
        'dataVersao':DateTime.now(),
      }).then((value){
        FirebaseFirestore.instance.collection('documentos').doc(widget.idFirebase).update({
          'listaIdEsp'  : FieldValue.arrayUnion([docRef.id]),
          'nomeProcesso': nomeProcesso.text.trim().toUpperCase(),
          'listaVersao' : FieldValue.arrayUnion(['${nomeProcesso.text.trim().toUpperCase()} - versão ${versao+1}']),
          'numeroFIP'   : widget.idDocumento,
        }).then((value){
          showSnackBar(context, 'Dados salvos com sucesso!', Colors.green);
          Navigator.push(context, MaterialPageRoute(builder: (context)=>
              InstrucaoSegundaEtapaTela(
                emailLogado: widget.emailLogado,
                nomeProcesso: nomeProcesso.text,
                FIP: widget.idDocumento,
                idEspAtual: docRef.id,
                etapaCriada: true,
                idEspAnterior: widget.idEsp,
              )
            )
          );
        });
      });
    }else{
      showSnackBar(context, 'Preencha todos os campos para avançar!', Colors.red);
    }
  }

  buscarListaEPI(){
    FirebaseFirestore.instance.collection('lista_tag').doc('lista_epi').get().then((dadosLista){
      listaTagBancoEpi = BadStateList(dadosLista, 'lista_epi');
      listaTagBancoEpi.sort((a, b) => a.compareTo(b));
      buscarListaFerramentas();
    });
  }

  buscarListaFerramentas(){
    FirebaseFirestore.instance.collection('lista_tag').doc('lista_ferramenta').get().then((dadosLista){
      listaTagBancoFerramenta = BadStateList(dadosLista, 'lista_ferramenta');
      listaTagBancoFerramenta.sort((a, b) => a.compareTo(b));
      buscarListaMateriaPrima();
    });
  }

  buscarListaMateriaPrima(){
    FirebaseFirestore.instance.collection('lista_tag').doc('lista_materia_prima').get().then((dadosLista){
      listaTagBancoMaterial = BadStateList(dadosLista, 'lista_materia_prima');
      listaTagBancoMaterial.sort((a, b) => a.compareTo(b));
      buscarDadosProcesso();
    });
  }

  salvarFirebasePalavraNovaTag(String palavra,String docFirebaseTag){
    FirebaseFirestore.instance.collection('lista_tag').doc(docFirebaseTag).set({
      docFirebaseTag:FieldValue.arrayUnion([palavra])
    },SetOptions(merge: true));
    if(!listaTagBancoEpi.contains(palavra)&& docFirebaseTag=='lista_epi'){
      listaTagBancoEpi.add(palavra);
      listaFiltroBancoEpi.sort();
    }else if(!listaTagBancoFerramenta.contains(palavra)&& docFirebaseTag=='lista_ferramenta'){
      listaTagBancoFerramenta.add(palavra);
      listaTagBancoFerramenta.sort();
    }else if(!listaTagBancoMaterial.contains(palavra)&& docFirebaseTag=='lista_materia_prima'){
      listaTagBancoMaterial.add(palavra);
      listaTagBancoMaterial.sort();
    }
    setState(() {});
  }

  void buscaEPI(String palavra) {
    List listaTodosEPI = [];
    listaTodosEPI.addAll(listaTagBancoEpi);
    if (palavra.isNotEmpty) {
      List<String> listaEPIFiltro = [];
      listaTodosEPI.forEach((item) {
        if (item.toLowerCase().contains(palavra.toLowerCase())) {
          listaEPIFiltro.add(item);
        }
      });
      setState(() {
        listaFiltroBancoEpi.clear();
        listaFiltroBancoEpi.addAll(listaEPIFiltro);
      });
      return;
    } else {
      setState(() {
        listaFiltroBancoEpi.clear();
        listaFiltroBancoEpi.addAll(listaTagBancoEpi);
      });
    }
  }

  void buscaFerramenta(String palavra) {
    List listaTodasFerramentas = [];
    listaTodasFerramentas.addAll(listaTagBancoFerramenta);
    if (palavra.isNotEmpty) {
      List<String> listaFerramentaFiltro = [];
      listaTodasFerramentas.forEach((item) {
        if (item.toLowerCase().contains(palavra.toLowerCase())) {
          listaFerramentaFiltro.add(item);
        }
      });
      setState(() {
        listaFiltroBancoFerramenta.clear();
        listaFiltroBancoFerramenta.addAll(listaFerramentaFiltro);
      });
      return;
    } else {
      setState(() {
        listaFiltroBancoFerramenta.clear();
        listaFiltroBancoFerramenta.addAll(listaTagBancoEpi);
      });
    }
  }

  void buscaMaterial(String palavra) {
    List listaTodosMateriais = [];
    listaTodosMateriais.addAll(listaTagBancoMaterial);
    if (palavra.isNotEmpty) {
      List<String> listaFiltroMaterial = [];
      listaTodosMateriais.forEach((item) {
        if (item.toLowerCase().contains(palavra.toLowerCase())) {
          listaFiltroMaterial.add(item);
        }
      });
      setState(() {
        listaFiltroBancoMaterial.clear();
        listaFiltroBancoMaterial.addAll(listaFiltroMaterial);
      });
      return;
    } else {
      setState(() {
        listaFiltroBancoMaterial.clear();
        listaFiltroBancoMaterial.addAll(listaTagBancoMaterial);
      });
    }
  }

  @override
  void initState() {
    buscarDadosUsuario();
  }

  @override
  Widget build(BuildContext context) {

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints){
        VariavelEstatica.inicializarDimensoes(context);
        return  Scaffold(
          backgroundColor: Cores.cinzaClaro,
          appBar: carregando?null:AppBarPadrao(mostrarUsuarios: false,emailLogado: widget.emailLogado),
          body: carregando
              ?Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    TextoPadrao(texto: 'Carregando'),
                    BotaoPadrao(texto: 'Voltar', onTap: ()=>Navigator.of(context).pop())
                  ],
                ),
              )
              :Container(
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
                            TextoPadrao(texto: widget.idDocumento,cor: Cores.cinzaTextoEscuro,negrito: FontWeight.bold,tamanhoFonte: 16,),
                            SizedBox(width: 40,),
                            TextoPadrao(texto: 'Data de criação',cor: Cores.primaria,tamanhoFonte: 14,),
                            SizedBox(width: 10,),
                            TextoPadrao(texto: VariavelEstatica.mascaraData.format(dataCriacao),cor: Cores.cinzaTextoEscuro,tamanhoFonte: 14,),
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
                            TextoPadrao(texto: VariavelEstatica.mascaraData.format(dataVersao),cor: Cores.cinzaTextoEscuro,tamanhoFonte: 14,),
                          ],
                        ),
                        CaixaTexto(
                          textoCaixa: 'Infome o nome do processo',
                          titulo: 'Nome do Processo',
                          controller: nomeProcesso,
                          largura: VariavelEstatica.largura*0.3,
                          corCaixa: Cores.cinzaClaro,
                          ativarCaixa: widget.idEsp=='',
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CaixaTexto(
                              textoCaixa: 'Informe a máquina',
                              titulo: 'Máquina',
                              controller: maquina,
                              largura: VariavelEstatica.largura*0.45,
                              corCaixa: Cores.cinzaClaro,
                            ),
                            SizedBox(width: 30,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TituloPadrao(title:'EPI necessário'),
                                Container(
                                  height: 50,
                                  width: VariavelEstatica.largura*0.45,
                                  decoration: BoxDecoration(
                                      color: Cores.cinzaClaro,
                                      borderRadius: BorderRadius.all(Radius.circular(3))
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        color: Cores.cardEsp,
                                        padding: EdgeInsets.only(left: 5),
                                        height: 50,
                                        width: 200,
                                        child: TextField(
                                          controller: epi,
                                          onChanged: (value) {
                                            buscaEPI(value);
                                          },
                                          decoration: InputDecoration(
                                            hintText: 'Informe epi',
                                            border: InputBorder.none,
                                          ),
                                          style: TextStyle(
                                            color: Cores.cinzaTexto,
                                            fontSize: 14,
                                          ),
                                          onSubmitted: (String palavra){
                                            if(palavra.isNotEmpty){
                                              listaTagDocEpi.add(palavra.toUpperCase().trim());
                                              listaTagDocEpi.sort();
                                              salvarFirebasePalavraNovaTag(palavra.toUpperCase().trim(),'lista_epi');
                                              epi.clear();
                                            }
                                          },
                                        ),
                                      ),
                                      Spacer(),
                                      Container(
                                        width: VariavelEstatica.largura*0.3,
                                        height: 50,
                                        alignment: Alignment.centerLeft,
                                        child: GridView.builder(
                                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4,mainAxisExtent: 20),
                                            itemCount: listaTagDocEpi.length,
                                            itemBuilder: (context,i){

                                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                                setState(() {});
                                              });

                                              return Card(
                                                child: Container(
                                                  height: 20,
                                                  padding: const EdgeInsets.symmetric(vertical: 1,horizontal: 1),
                                                  child: GestureDetector(
                                                    onTap: (){
                                                      listaTagDocEpi.removeAt(i);
                                                      setState(() {});
                                                    },
                                                    child: Container(
                                                        height: 20,
                                                        child: Row(
                                                          mainAxisSize: MainAxisSize.min,
                                                          children: [
                                                            Container(
                                                              height: 15,
                                                              width: VariavelEstatica.largura*0.06,
                                                              child: TextoPadrao(texto: listaTagDocEpi[i],cor: Cores.cinzaTextoEscuro,tamanhoFonte: 10,alinhamentoTexto: TextAlign.center,)
                                                            ),
                                                            Icon(Icons.close,color: Colors.red,size: 10,)
                                                          ],
                                                        )
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }
                                        ),
                                      ),
                                      Spacer(),
                                    ],
                                  ),
                                ),
                                Container(
                                  height:epi.text.isNotEmpty? 200 :0,
                                  width: VariavelEstatica.largura*0.45,
                                  child: Scrollbar(
                                    controller: scrollEPI,
                                    thumbVisibility: true,
                                    trackVisibility: true,
                                    child: ListView.builder(
                                      controller: scrollEPI,
                                      itemCount: listaFiltroBancoEpi.length,
                                      itemBuilder: (BuildContext context, int index) {
                                        return ListTile(
                                          onTap: (){
                                            listaTagDocEpi.add(listaFiltroBancoEpi[index]);
                                            listaFiltroBancoEpi.clear();
                                            epi.clear();
                                            setState(() {});
                                          },
                                          title: Text(listaFiltroBancoEpi[index]),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TituloPadrao(title:'Ferramentas utilizadas'),
                            Container(
                              height: 53,
                              width: VariavelEstatica.largura*0.9+30,
                              decoration: BoxDecoration(
                                  color: Cores.cinzaClaro,
                                  borderRadius: BorderRadius.all(Radius.circular(3))
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    color: Cores.cardEsp,
                                    height: 50,
                                    width: 200,
                                    padding: EdgeInsets.only(left: 10),
                                    child: TextField(
                                      controller: ferramentas,
                                      onChanged: (texto) {
                                        buscaFerramenta(texto);
                                      },
                                      decoration: InputDecoration(
                                        hintText: 'Informe ferramentas',
                                        border: InputBorder.none,
                                      ),
                                      style: TextStyle(
                                        color: Cores.cinzaTexto,
                                        fontSize: 14,
                                      ),
                                      onSubmitted: (String palavra){
                                        if(palavra.isNotEmpty){
                                          listaTagDocFerramenta.add(palavra.toUpperCase().trim());
                                          listaTagDocFerramenta.sort();
                                          salvarFirebasePalavraNovaTag(palavra.toUpperCase().trim(),'lista_ferramenta');
                                          ferramentas.clear();
                                        }
                                      },
                                    ),
                                  ),
                                  Spacer(),
                                  Container(
                                    width: VariavelEstatica.largura*0.76,
                                    height: 50,
                                    alignment: Alignment.centerLeft,
                                    child: GridView.builder(
                                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 9,mainAxisExtent: 20),
                                        itemCount: listaTagDocFerramenta.length,
                                        itemBuilder: (context,i){
                                          WidgetsBinding.instance.addPostFrameCallback((_) {
                                            setState(() {});
                                          });

                                          return GestureDetector(
                                            onTap: (){
                                              listaTagDocFerramenta.removeAt(i);
                                              setState(() {});
                                            },
                                            child: Card(
                                                child: Container(
                                                    height: 20,
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          width: VariavelEstatica.largura*0.065,
                                                          height: 15,
                                                          child: TextoPadrao(texto: listaTagDocFerramenta[i],cor: Cores.cinzaTextoEscuro,tamanhoFonte: 10,alinhamentoTexto: TextAlign.center,)
                                                        ),
                                                        Icon(Icons.close,color: Colors.red,size: 10,)
                                                      ],
                                                    )
                                                )
                                            ),
                                          );
                                        }
                                    ),
                                  ),
                                  Spacer()
                                ],
                              ),
                            ),
                            Container(
                              height:ferramentas.text.isNotEmpty? 200 :0,
                              width: VariavelEstatica.largura*0.45,
                              child: Scrollbar(
                                controller: scrollFerramenta,
                                thumbVisibility: true,
                                trackVisibility: true,
                                child: ListView.builder(
                                  controller: scrollFerramenta,
                                  itemCount: listaFiltroBancoFerramenta.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return ListTile(
                                      onTap: (){
                                        listaTagDocFerramenta.add(listaFiltroBancoFerramenta[index]);
                                        listaFiltroBancoFerramenta.clear();
                                        ferramentas.clear();
                                        setState(() {});
                                      },
                                      title: Text(listaFiltroBancoFerramenta[index]),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TituloPadrao(title:'Matéria-prima utilizada'),
                                Container(
                                  height: 50,
                                  width: VariavelEstatica.largura*0.45,
                                  decoration: BoxDecoration(
                                      color: Cores.cinzaClaro,
                                      borderRadius: BorderRadius.all(Radius.circular(3))
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        color: Cores.cardEsp,
                                        padding: EdgeInsets.only(left: 10),
                                        height: 50,
                                        width: 200,
                                        child: TextField(
                                          controller: materiaPrima,
                                          onChanged: (value) {
                                            buscaMaterial(value);
                                          },
                                          decoration: InputDecoration(
                                            hintText: 'Informe matéria-prima ',
                                            border: InputBorder.none,
                                          ),
                                          style: TextStyle(
                                            color: Cores.cinzaTexto,
                                            fontSize: 14,
                                          ),
                                          onSubmitted: (String palavra){
                                            if(palavra.isNotEmpty){
                                              listaTagDocMaterial.add(palavra.toUpperCase().trim());
                                              listaTagDocMaterial.sort();
                                              salvarFirebasePalavraNovaTag(palavra.toUpperCase().trim(),'lista_materia_prima');
                                              materiaPrima.clear();
                                            }
                                          },
                                        ),
                                      ),
                                      Spacer(),
                                      Container(
                                        width: VariavelEstatica.largura*0.3,
                                        height: 50,
                                        alignment: Alignment.centerLeft,
                                        child: GridView.builder(
                                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4,mainAxisExtent: 20),
                                            itemCount: listaTagDocMaterial.length,
                                            itemBuilder: (context,i){

                                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                                setState(() {});
                                              });

                                              return Center(
                                                  child: GestureDetector(
                                                    onTap: (){
                                                      listaTagDocMaterial.removeAt(i);
                                                      setState(() {});
                                                    },
                                                    child: Card(
                                                        child: Container(
                                                            height: 20,
                                                            child: Row(
                                                              children: [
                                                                Container(
                                                                  height: 15,
                                                                  width: VariavelEstatica.largura*0.06,
                                                                  child: TextoPadrao(texto: listaTagDocMaterial[i],cor: Cores.cinzaTextoEscuro,tamanhoFonte: 10,alinhamentoTexto: TextAlign.center,)
                                                                ),
                                                                Icon(Icons.close,color: Colors.red,size: 10,)
                                                              ],
                                                            )
                                                        )
                                                    ),
                                                  )
                                              );
                                            }
                                        ),
                                      ),
                                      Spacer(),
                                    ],
                                  ),
                                ),
                                Container(
                                  height:materiaPrima.text.isNotEmpty? 200 :0,
                                  width: VariavelEstatica.largura*0.45,
                                  child: Scrollbar(
                                    controller: scrollMaterial,
                                    thumbVisibility: true,
                                    trackVisibility: true,
                                    child: ListView.builder(
                                      controller: scrollMaterial,
                                      itemCount: listaFiltroBancoMaterial.length,
                                      itemBuilder: (BuildContext context, int index) {
                                        return ListTile(
                                          onTap: (){
                                            listaTagDocMaterial.add(listaFiltroBancoMaterial[index]);
                                            listaFiltroBancoMaterial.clear();
                                            materiaPrima.clear();
                                            setState(() {});
                                          },
                                          title: Text(listaFiltroBancoMaterial[index]),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: 30,),
                            CaixaTexto(
                              titulo: 'Tempo total das Etapas',
                              controller: tempoEtapas,
                              largura: VariavelEstatica.largura*0.25,
                              corCaixa: Cores.cinzaClaro,
                              ativarCaixa: false,
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
                              onPressed: ()=>widget.idEsp==''?salvarNovaInstrucao():editarInstrucao(),
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
      },
    );
  }
}
