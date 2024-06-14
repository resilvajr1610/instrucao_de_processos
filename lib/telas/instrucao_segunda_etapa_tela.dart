import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:instrucao_de_processos/modelos/bad_state_list.dart';
import 'package:instrucao_de_processos/modelos/bad_state_string.dart';
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
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class InstrucaoSegundaEtapaTela extends StatefulWidget {
  String emailLogado;
  String nomeProcesso;
  String FIP;
  String idEspAtual;
  String idEspAnterior;
  bool etapaCriada;

  InstrucaoSegundaEtapaTela({
    required this.emailLogado,
    required this.nomeProcesso,
    required this.FIP,
    required this.idEspAtual,
    required this.idEspAnterior,
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
            idEsp: widget.idEspAnterior,
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
                listaCompleta: false,
                listaFotos: [],
                listaVideos: []
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

    double tempoTotal = 0;

    FirebaseFirestore.instance
        .collection('etapas')
        .doc(widget.idEspAnterior)
        .get()
        .then((etapasDoc) {
      List<dynamic> listaMapEtapa = BadStateList(etapasDoc,'listaEtapa');

      for (int i = 0; i < listaMapEtapa.length; i++) {
        List<dynamic> listaMapAnalise = listaMapEtapa[i]['listaAnalise'];
        List<ModeloAnalise2> listaAnalise = [];

        for (int j = 0; j < listaMapAnalise.length; j++) {
          listaAnalise.add(
              ModeloAnalise2(
                  analiseAtiva: true,
                  etapaAtiva: true,
                  imagemSelecionada: listaMapAnalise[j]['imagemSelecionada'],
                  numeroAnalise: int.parse('${j+1}0'),
                  nomeAnalise: TextEditingController(text: listaMapAnalise[j]['nomeAnalise']),
                  tempoAnalise: TextEditingController(text: listaMapAnalise[j]['tempoAnalise']),
                  pontoChave: TextEditingController(text: listaMapAnalise[j]['pontoChave']),
                  mostrarListaImagens: false,
                  listaCompleta: true,
                  listaFotos: [],
                  listaVideos: []
              )
          );
          tempoTotal = tempoTotal + double.parse(listaMapAnalise[j]['tempoAnalise']);
        }

        listaEtapas.add(
            ModeloEtapa2(
                idEsp: widget.idEspAnterior,
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
      FirebaseFirestore.instance.collection('especificacao').doc(widget.idEspAtual).update({
        'totalEtapas' : tempoTotal
      });
      observacoes.text = BadStateString(etapasDoc,'observacoes');
      alteracao.text = BadStateString(etapasDoc,'alteracao');
      if(listaEtapas.length!=0){
        iniciarEtapa(false,0);
      }
      setState(() {});
    });
  }

  editarEtapa() {

    double tempoTotal = 0;

    if(listaEtapas[0].adicionaNovo!=0){

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

          tempoTotal = tempoTotal + listaEtapas[i].tempoTotalEtapaSegundos;

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

      FirebaseFirestore.instance.collection('etapas').doc(widget.idEspAtual).set({
        'idEsp'       : widget.idEspAtual,
        'listaEtapa'  : listaMapEtapa,
        'observacoes' : observacoes.text,
        'alteracao'   : alteracao.text,
        'idUsuario'   : FirebaseAuth.instance.currentUser!.uid,
        'idEmail'     : FirebaseAuth.instance.currentUser!.email,
        'dataCriacao' : DateTime.now(),
      },SetOptions(merge: true)).then((value){
        FirebaseFirestore.instance.collection('especificacao').doc(widget.idEspAtual).update({
          'etapa'     : 'criada',
          'tempoTotal': tempoTotal
        }).then((value){
          showSnackBar(context, 'Etapas foram salvas', Colors.green);
          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>InstrucaoTerceiraEtapaTela(emailLogado: widget.emailLogado,idEtapa: widget.idEspAtual,FIP: widget.FIP,)));
        });
      });
    }else{
      showSnackBar(context, 'Insira ao menos uma etapa e uma análise para avançar', Colors.red);
    }
  }

  salvarEtapa() {

    double tempoTotal = 0;

    if(listaEtapas[0].adicionaNovo!=0){

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

          tempoTotal = tempoTotal + listaEtapas[i].tempoTotalEtapaSegundos;

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

      FirebaseFirestore.instance.collection('etapas').doc(widget.idEspAtual).set({
        'idEsp'       : widget.idEspAtual,
        'listaEtapa'  : listaMapEtapa,
        'observacoes' : observacoes.text,
        'alteracao'   : alteracao.text,
        'idUsuario'   : FirebaseAuth.instance.currentUser!.uid,
        'idEmail'     : FirebaseAuth.instance.currentUser!.email,
        'dataCriacao' : DateTime.now(),
      },SetOptions(merge: true)).then((value){
        FirebaseFirestore.instance.collection('especificacao').doc(widget.idEspAtual).update({
          'etapa'     : 'criada',
          'tempoTotal': tempoTotal
        }).then((value){
          showSnackBar(context, 'Etapas foram salvas', Colors.green);
          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>InstrucaoTerceiraEtapaTela(emailLogado: widget.emailLogado,idEtapa: widget.idEspAtual,FIP: widget.FIP)));
        });
      });
    }else{
      showSnackBar(context, 'Insira ao menos uma etapa e uma análise para avançar', Colors.red);
    }
  }

  carregarWidget(int posicaoEtapa, int posicaoAnalise){
    showDialog(context: context,
        builder: (context){
          return Center(
            child: AlertDialog(
              title: TextoPadrao(texto: 'Qual mídia gostaria de adicionar?',cor: Cores.primaria,negrito: FontWeight.bold,),
              content: Container(
                height: 150,
                width: 200,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextoPadrao(
                      texto: 'Fotos adicionadas : ${listaEtapas[posicaoEtapa].listaAnalise[posicaoAnalise].listaFotos.length}',
                      cor: Cores.cinzaTextoEscuro,
                    ),
                    SizedBox(height: 20,),
                    TextoPadrao(
                      texto: 'Videos adicionados : ${listaEtapas[posicaoEtapa].listaAnalise[posicaoAnalise].listaVideos.length}',
                      cor: Cores.cinzaTextoEscuro,
                    ),
                    SizedBox(height: 20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Card(
                          child: TextButton(
                            child: TextoPadrao(texto: 'Foto',cor: Cores.cinzaTextoEscuro,negrito: FontWeight.bold,),
                            onPressed: ()=>escolherImagens(posicaoEtapa,posicaoAnalise)
                          ),
                        ),
                        Card(
                          child: TextButton(
                            child: TextoPadrao(texto: 'Video',cor: Cores.cinzaTextoEscuro,negrito: FontWeight.bold,),
                            onPressed: ()=>escolherVideo(posicaoEtapa,posicaoAnalise)
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(child: TextoPadrao(texto: 'Voltar',cor: Colors.red,negrito: FontWeight.bold,),onPressed: ()=>Navigator.pop(context),),
              ],
            ),
          );
        });
  }

  Future escolherImagens(int posicaoEtapa, int posicaoAnalise) async {
    final multiPicker = ImagePicker();
    List <XFile> imageFromWebList = [];
    if(imageFromWebList!=[]){
      imageFromWebList.clear();
    }

    if(mounted){
      await multiPicker.pickMultiImage(imageQuality: 30,).then((value){
        setState(() {
          if(value.isNotEmpty){
            listaEtapas[posicaoEtapa].listaAnalise[posicaoAnalise].listaFotos.addAll(value);
            Navigator.pop(context);
            carregando = true;
            salvarFotos(posicaoEtapa,posicaoAnalise);
          }else{
            print('sem imagens');
          }
        });
      });
    }
  }

  salvarFotos(int posicaoEtapa, int posicaoAnalise)async{
    for(int i = 0; listaEtapas[posicaoEtapa].listaAnalise[posicaoAnalise].listaFotos.length > i ; i++){
      Uint8List arquivoSelecionado = await listaEtapas[posicaoEtapa].listaAnalise[posicaoAnalise].listaFotos[i].readAsBytes();
      FirebaseStorage storage = FirebaseStorage.instance;
      String nomearquivo = "Processo/${listaEtapas[posicaoEtapa].nomeProcesso}/Etapa/${listaEtapas[posicaoEtapa].nomeEtapa.text}/Analise/"
          "${listaEtapas[posicaoEtapa].listaAnalise[posicaoAnalise].nomeAnalise.text}/Fotos/${DateTime.now()}.jpeg";
      Reference reference = storage.ref(nomearquivo);
      UploadTask uploadTaskSnapshot = reference.putData(arquivoSelecionado, SettableMetadata(contentType: 'image/jpeg'));
      await uploadTaskSnapshot.whenComplete(()async{
        print(reference.getDownloadURL().toString());
        await uploadTaskSnapshot.then((downloadUrl)async{
          await downloadUrl.ref.getDownloadURL().then((url){
            FirebaseFirestore.instance.collection('etapas').doc(widget.idEspAtual).set({
              "idEsp": widget.idEspAtual,
              "fotos_etapa${posicaoEtapa}_analise${posicaoAnalise}": FieldValue.arrayUnion([url])
            },SetOptions(merge: true)).then((value){
              print('url : $url');
            });
          });
        });
      });
    }
    carregando = false;
    carregarWidget(posicaoEtapa,posicaoAnalise);
    setState(() {});
  }

  salvarVideo(String nomeArquivo,var arquivo,int posicaoEtapa, int posicaoAnalise)async{
    String url='';
    Uint8List arquivoSelecionado = await arquivo.readAsBytes();
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference reference = storage.ref(nomeArquivo);
    UploadTask uploadTaskSnapshot = reference.putData(arquivoSelecionado, SettableMetadata(contentType: '	video/mp4'));
    final TaskSnapshot downloadUrl = await uploadTaskSnapshot;
    url = (await downloadUrl.ref.getDownloadURL());
    if(url!=''){
      FirebaseFirestore.instance.collection('etapas').doc(widget.idEspAtual).set({
        "idEsp": widget.idEspAtual,
        "videos_etapa${posicaoEtapa}_analise${posicaoAnalise}": FieldValue.arrayUnion([url])
      },SetOptions(merge: true)).then((value){
        carregando = false;
        carregarWidget(posicaoEtapa,posicaoAnalise);
        setState(() {});
      });
      print('url dentro $url');
    }
  }

  escolherVideo(int posicaoEtapa, int posicaoAnalise)async {

    if (kIsWeb) {
      FilePickerResult? result;
      try {
        result = await FilePicker.platform.pickFiles(type: FileType.custom,
          allowedExtensions: ['avi', 'wmv', 'wma', 'mp4', 'mov'],
        );
      } catch (e) {
        print(e);
      }

      if (result != null) {
        try {
          setState(() {
            Uint8List?uploadfile = result!.files.single.bytes;
            int tamanhoBytes = uploadfile!.length;
            double tamnhoArquivoMB = tamanhoBytes / (1024 * 1024);

            print(tamnhoArquivoMB);
            double maxTamnhoMB = 100.0;

            if(tamnhoArquivoMB > maxTamnhoMB){
              showSnackBar(context, 'Tamanho máximo permitido é de 100 MB por vídeo', Colors.red);
            }else{
              // String filename = result.files.single.name;
              // nomearquivo.text = result.files.single.name;
              listaEtapas[posicaoEtapa].listaAnalise[posicaoAnalise].listaVideos.add(uploadfile!);
              print('videos');
              print(listaEtapas[posicaoEtapa].listaAnalise[posicaoAnalise].listaVideos.length);
              if (listaEtapas[posicaoEtapa].listaAnalise[posicaoAnalise].listaVideos.isNotEmpty) {
                var arquivo = XFile.fromData(uploadfile);
                String nomearquivo = "Processo/${listaEtapas[posicaoEtapa].nomeProcesso}/Etapa/${listaEtapas[posicaoEtapa].nomeEtapa.text}/Analise/"
                    "${listaEtapas[posicaoEtapa].listaAnalise[posicaoAnalise].nomeAnalise.text}/Videos/${DateTime.now()}.mp4";
                carregando = true;
                Navigator.pop(context);
                salvarVideo(nomearquivo, arquivo,posicaoEtapa,posicaoAnalise);
              }
            }
          });
        } catch (e) {
          print(e);
        }
      }
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
            carregando?Container(
              width: VariavelEstatica.largura,
              height: VariavelEstatica.altura*0.8,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextoPadrao(texto: 'Aguarde ...',cor: Cores.primaria,),
                    CircularProgressIndicator(color: Cores.primaria,),
                  ],
                ),
              ),
            ):Container(
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
                          TextoPadrao(texto: widget.FIP,cor: Cores.cinzaTextoEscuro,negrito: FontWeight.bold,tamanhoFonte: 16,),
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
                                      alturaMostrarIcones = alturaMostrarIcones + 120;
                                    }else{
                                      if(listaEtapas[i].listaAnalise.length!=1){
                                        alturaMostrarIcones = alturaMostrarIcones - 120;
                                      }
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
                                height: listaEtapas[i].listaAnalise.length*160+alturaMostrarIcones,
                                child: ListView.builder(
                                    itemCount: listaEtapas[i].listaAnalise.length,
                                    itemBuilder: (context, j){
                                      return Container(
                                        height: 120,
                                        child: ItemAnalise2(
                                            indice: j,
                                            modeloAnalise: listaEtapas[i].listaAnalise[j],
                                            botaoMostrarListaImagem:  ()=>setState((){
                                              listaEtapas[i].listaAnalise[j].mostrarListaImagens=true;
                                              alturaMostrarIcones = 200;
                                            }),
                                            botaoSalvarNovaAnalise: (){
                                              if(!listaEtapas[i].listaAnalise[j].listaCompleta){
                                                if(listaEtapas[i].listaAnalise[j].nomeAnalise.text.isNotEmpty
                                                    && listaEtapas[i].listaAnalise[j].tempoAnalise.text.isNotEmpty
                                                ){
                                                  if(listaEtapas[i].listaAnalise[j].analiseAtiva){
                                                    listaEtapas[i].tempoTotalEtapaSegundos = int.parse(listaEtapas[i].listaAnalise[j].tempoAnalise.text.trim()) + listaEtapas[i].tempoTotalEtapaSegundos;
                                                    listaEtapas[i].listaAnalise[j].listaCompleta = true;

                                                      if(listaEtapas[i].adicionaNovo==0){
                                                        iniciarEtapa(false, i);
                                                      }

                                                    listaEtapas[i].listaAnalise.add(
                                                        ModeloAnalise2(
                                                            etapaAtiva: true,
                                                            imagemSelecionada: '',
                                                            numeroAnalise: int.parse('${j+1}0'),
                                                            nomeAnalise: TextEditingController(),
                                                            tempoAnalise: TextEditingController(),
                                                            pontoChave: TextEditingController(),
                                                            mostrarListaImagens: false,
                                                            analiseAtiva: true,
                                                            listaCompleta: false,
                                                            listaFotos: [],
                                                            listaVideos: []
                                                        )
                                                    );
                                                    int minutos = listaEtapas[i].tempoTotalEtapaSegundos ~/60;
                                                    double segundos = listaEtapas[i].tempoTotalEtapaSegundos % 60;
                                                    listaEtapas[i].tempoTotalEtapaMinutos = '${minutos>9?'':'0'}${minutos}:${segundos>9?'':'0'}$segundos';

                                                    setState(()=>listaEtapas[i].listaAnalise[j].analiseAtiva=listaEtapas[i].listaAnalise[j].analiseAtiva?false:true);
                                                  }
                                                }else{
                                                  // setState(()=>listaEtapas[i].listaAnalise[j].analiseAtiva=false);
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
                                                    alturaMostrarIcones = 100;
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
                                            ),
                                            funcaoFotoVideo: (){
                                              carregarWidget(i,j);
                                            },
                                           funcaoAlterar: ()=> setState(()=>listaEtapas[i].listaAnalise[j].analiseAtiva=listaEtapas[i].listaAnalise[j].analiseAtiva?false:true),
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
                      maximoLinhas: 3,
                      textInputType: TextInputType.multiline,
                    ),
                    TextoPadrao(texto:'Motivo da alteração',cor: Cores.primaria,negrito: FontWeight.bold,tamanhoFonte: 14,),
                    CaixaTexto(
                      mostrarTitulo: false,
                      textoCaixa: 'Informe o que alterou',
                      titulo: '',
                      controller: alteracao,
                      largura: 950,
                      corCaixa: Cores.cinzaClaro,
                      textInputType: TextInputType.multiline,
                      maximoLinhas: 3,
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
