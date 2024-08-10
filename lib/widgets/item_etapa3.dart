import 'package:flutter/material.dart';
import 'package:instrucao_de_processos/modelos/modelo_analise3.dart';
import 'package:instrucao_de_processos/widgets/texto_padrao.dart';
import '../utilidades/cores.dart';
import 'package:video_player/video_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ItemEtapa3 extends StatelessWidget {
  String idEsp;
  num numeroEtapa;
  String nomeEtapa;
  int tempoTotalEtapa;
  List<ModeloAnalise3> listaAnalise;
  bool comentario;
  var funcaoComentario;
  var funcaoVideo;
  bool pc;

  ItemEtapa3({
    required this.idEsp,
    required this.numeroEtapa,
    required this.nomeEtapa,
    required this.tempoTotalEtapa,
    required this.listaAnalise,
    required this.funcaoComentario,
    required this.pc,
    this.comentario = false,
  });

  @override
  Widget build(BuildContext context) {

    double largura = MediaQuery.of(context).size.width;
    double altura = MediaQuery.of(context).size.height;

    int minutos = (tempoTotalEtapa/60).toInt();
    int segundos = (tempoTotalEtapa%60).toInt();

    return pc?Container(
      width: largura * 0.9,
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.symmetric(vertical: 5,horizontal: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2, // Define o raio de propagação da sombra
            blurRadius: 3, // Define o raio de desfoque da sombra
            offset: Offset(0, 3), // Define o deslocamento da sombra
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextoPadrao(texto: 'Etapa $numeroEtapa',cor: Cores.primaria,negrito: FontWeight.bold,tamanhoFonte: 16,),
          Container(
            width: largura>1200?largura * 0.7:largura * 0.15,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: largura>1200?largura * 0.44:largura * 0.15,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextoPadrao(texto: 'Nome da Etapa',cor: Cores.primaria,tamanhoFonte: 14,),
                      SizedBox(width: 10,),
                      Container(
                          width: largura * 0.2,
                          child: TextoPadrao(texto: nomeEtapa,cor: Cores.cinzaTextoEscuro,tamanhoFonte: 14,maxLines: 5,)
                      ),
                    ],
                  ),
                ),
                Container(
                  width: largura>1200?largura * 0.2:largura * 0.15,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextoPadrao(texto: 'Tempo total da etapa',cor: Cores.primaria,tamanhoFonte: 14,),
                      SizedBox(width: 10,),
                      Container(
                          width: largura * 0.1,
                          child: TextoPadrao(texto: '$minutos min $segundos seg',cor: Cores.cinzaTextoEscuro,tamanhoFonte: 14,)
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
              width:largura*0.9,
              child: Divider()
          ),
          Container(
            width:largura*0.9,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                    width: 110,
                    child: TextoPadrao(texto:'Característica',cor: Cores.primaria,tamanhoFonte: 14,)
                ),
                Container(
                    width: 60,
                    child: TextoPadrao(texto:'Análise',cor: Cores.primaria,tamanhoFonte: 14,)
                ),
                SizedBox(width: 10,),
                Container(
                    width: 110,
                    child: TextoPadrao(texto:'Imagem/Vídeo',cor: Cores.primaria,tamanhoFonte: 14,)
                ),
                Container(
                    width: 400,
                    child: TextoPadrao(texto:'Análise da Operação',cor: Cores.primaria,tamanhoFonte: 14,)
                ),
                SizedBox(width: 10,),
                Container(
                    width: 130,
                    child: TextoPadrao(texto:'Tempo (segundos)',cor: Cores.primaria,tamanhoFonte: 14,)
                ),
                SizedBox(width: 10,),
                TextoPadrao(texto:'Ponto Chave/Razão',cor: Cores.primaria,tamanhoFonte: 14,),
              ],
            ),
          ),
          //criar list
          Container(
            width: largura*0.9,
            height: listaAnalise.length*70,
            child: ListView.separated(
              separatorBuilder: (context,i)=>Divider(),
              itemCount: listaAnalise.length,
              itemBuilder: (context,i){
                return Container(
                  width: largura*0.8,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        width: 90,
                        height: 40,
                        child: listaAnalise[i].imagemSelecionada==''?TextoPadrao(texto: '-',cor: Cores.cinzaTextoEscuro,):Image.asset(listaAnalise[i].imagemSelecionada),
                        margin: EdgeInsets.only(right: 20),
                      ),
                      Container(
                        height: 50,
                        alignment: Alignment.center,
                        width: 50,
                        child: TextoPadrao(texto:'${i+1}0',cor: Cores.primaria,tamanhoFonte: 14,alinhamentoTexto: TextAlign.center,),
                        margin: EdgeInsets.only(right: 10),
                      ),
                      SizedBox(width: 10,),
                      listaAnalise[i].urlVideos.length==0 && listaAnalise[i].urlFotos.length==0?
                      Container(
                        height: 50,
                        width: 90,
                        margin: EdgeInsets.only(right: 20),
                      ):
                      Container(
                        height: 50,
                        width: 90,
                        child: IconButton(
                          icon: Icon(Icons.photo,color: Cores.cinzaTexto,),
                          onPressed: (){
                              showDialog(context: context,
                                  builder: (context){
                                    return Center(
                                      child: AlertDialog(
                                        title: TextoPadrao(texto: 'Mídias',cor: Cores.primaria,negrito: FontWeight.bold,),
                                        content: Container(
                                          height: 750,
                                          width: 1000,
                                          child: ListView(
                                            children: [
                                              listaAnalise[i].urlFotos.length==0?Container(
                                                height: 300,
                                                width: 500,
                                                child: Center(
                                                  child: TextoPadrao(texto: 'Sem Fotos',cor: Cores.primaria,),
                                                ),
                                              ):Container(
                                                height: 400,
                                                width: 500,
                                                padding: EdgeInsets.symmetric(horizontal: 5),
                                                child: ListView.builder(
                                                  scrollDirection: Axis.horizontal,
                                                  itemCount: listaAnalise[i].urlFotos.length,
                                                  itemBuilder: (context, j) {
                                                    return Column(
                                                      children: [
                                                        FutureBuilder(
                                                          future: precacheImage(NetworkImage(listaAnalise[i].urlFotos[j]), context),
                                                          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                                                            if (snapshot.connectionState == ConnectionState.waiting) {
                                                              return Center(child: CircularProgressIndicator());
                                                            } else if (snapshot.hasError) {
                                                              return Center(child: Text('Erro ao carregar imagem'));
                                                            } else {
                                                              return Image.network(listaAnalise[i].urlFotos[j],height: 350,);
                                                            }
                                                          },
                                                        ),
                                                        idEsp==''?Container():IconButton(
                                                          icon: Icon(Icons.clear,color: Colors.red,),
                                                          onPressed: (){
                                                            print('id $idEsp');
                                                            showDialog(context: context,
                                                                builder: (context){
                                                                  return Center(
                                                                    child: AlertDialog(
                                                                      title: TextoPadrao(texto: 'Deseja excluír esse item?',cor: Cores.primaria,negrito: FontWeight.bold,),
                                                                      content: Container(
                                                                        height: 40,
                                                                        width: 350,
                                                                        child: TextoPadrao(
                                                                          texto: 'Após exclusão esse item não aparecerá novamente.',
                                                                          cor: Cores.cinzaTextoEscuro,
                                                                        ),
                                                                      ),
                                                                      actions: [
                                                                        TextButton(child: TextoPadrao(texto: 'Não',cor: Colors.green,negrito: FontWeight.bold,),onPressed: ()=>Navigator.pop(context),),
                                                                        TextButton(child: TextoPadrao(texto: 'Confimar Exclusão',cor: Colors.red,negrito: FontWeight.bold,),onPressed: (){
                                                                          print('id $idEsp');
                                                                          print('quero apagar fotos_etapa${numeroEtapa-1}_analise${i}');
                                                                          print(listaAnalise[i].urlFotos[j]);
                                                                          FirebaseFirestore.instance.collection('etapas').doc(idEsp).update({
                                                                            'fotos_etapa${numeroEtapa-1}_analise${i}':FieldValue.arrayRemove([listaAnalise[i].urlFotos[j]])
                                                                          }).then((_){
                                                                            listaAnalise[i].urlFotos.removeAt(j);
                                                                            Navigator.pop(context);
                                                                            Navigator.pop(context);
                                                                          });
                                                                        }),
                                                                      ],
                                                                    ),
                                                                  );
                                                                });
                                                          },
                                                        )
                                                      ],
                                                    );
                                                  },
                                                ),
                                              ),
                                              listaAnalise[i].urlVideos.length==0?Container(
                                                height: 350,
                                                width: 500,
                                                child: Center(
                                                  child: TextoPadrao(texto: 'Sem Videos',cor: Cores.primaria,),
                                                ),
                                              ):Container(
                                                padding: EdgeInsets.symmetric(horizontal: 5),
                                                alignment: Alignment.center,
                                                height: 350,
                                                width: 500,
                                                child: ListView.builder(
                                                  scrollDirection: Axis.horizontal,
                                                  itemCount: listaAnalise[i].urlVideos.length,
                                                  itemBuilder: (context, j) {

                                                    VideoPlayerController? controller;
                                                    Future<void>? iniciarVideo;
                                                    controller = VideoPlayerController.networkUrl(Uri.parse(listaAnalise[i].urlVideos[j]));
                                                    controller.setLooping(true);
                                                    controller.setVolume(1.0);
                                                    iniciarVideo = controller!.initialize();

                                                    return Column(
                                                      children: [
                                                        FutureBuilder(
                                                          future: iniciarVideo,
                                                          builder: (context,snapshot){
                                                            if(snapshot.connectionState == ConnectionState.done){
                                                              return Container(
                                                                height: 300,
                                                                alignment: Alignment.center,
                                                                child: Column(
                                                                  mainAxisSize: MainAxisSize.min,
                                                                  children: [
                                                                    Container(
                                                                      alignment: Alignment.center,
                                                                      height: 250,
                                                                      width: 400,
                                                                      child: AspectRatio(
                                                                        aspectRatio: controller!.value.aspectRatio,
                                                                        child: VideoPlayer(controller),
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      child: IconButton(
                                                                        style: IconButton.styleFrom(backgroundColor: Cores.primaria),
                                                                        icon: Icon(controller.value.isPlaying? Icons.pause:Icons.play_arrow,color: Colors.white),
                                                                        onPressed: (){
                                                                          if(controller!.value.isPlaying){
                                                                            controller!.pause();
                                                                          }else{
                                                                            controller.play();
                                                                          }
                                                                          // setState(() {});
                                                                        },
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                        width: 400,
                                                                        child: VideoProgressIndicator(controller, allowScrubbing: true,)
                                                                    )
                                                                  ],
                                                                ),
                                                              );
                                                            }else{
                                                              return Container(
                                                                  width: 400,
                                                                  height: 350,
                                                                  child: Center(child: CircularProgressIndicator(),)
                                                              );
                                                            }
                                                          },
                                                        ),
                                                        idEsp==''?Container():IconButton(
                                                          icon: Icon(Icons.clear,color: Colors.red),
                                                          onPressed: (){
                                                            print('id $idEsp');
                                                            showDialog(context: context,
                                                                builder: (context){
                                                                  return Center(
                                                                    child: AlertDialog(
                                                                      title: TextoPadrao(texto: 'Deseja excluír esse item?',cor: Cores.primaria,negrito: FontWeight.bold,),
                                                                      content: Container(
                                                                        height: 40,
                                                                        width: 350,
                                                                        child: TextoPadrao(
                                                                          texto: 'Após exclusão esse item não aparecerá novamente.',
                                                                          cor: Cores.cinzaTextoEscuro,
                                                                        ),
                                                                      ),
                                                                      actions: [
                                                                        TextButton(child: TextoPadrao(texto: 'Não',cor: Colors.green,negrito: FontWeight.bold,),onPressed: ()=>Navigator.pop(context),),
                                                                        TextButton(child: TextoPadrao(texto: 'Confimar Exclusão',cor: Colors.red,negrito: FontWeight.bold,),onPressed: (){
                                                                          print('id $idEsp');
                                                                          print('quero apagar videos_etapa${numeroEtapa-1}_analise${i}');
                                                                          print(listaAnalise[i].urlVideos[j]);
                                                                          FirebaseFirestore.instance.collection('etapas').doc(idEsp).update({
                                                                            'videos_etapa${numeroEtapa-1}_analise${i}':FieldValue.arrayRemove([listaAnalise[i].urlVideos[j]])
                                                                          }).then((_){
                                                                            listaAnalise[i].urlVideos.removeAt(j);
                                                                            Navigator.pop(context);
                                                                            Navigator.pop(context);
                                                                          });
                                                                        }),
                                                                      ],
                                                                    ),
                                                                  );
                                                                });
                                                          },
                                                        )
                                                      ],
                                                    );
                                                  },
                                                ),
                                              )
                                            ],
                                          )
                                        ),
                                        actions: [
                                          TextButton(child: TextoPadrao(texto: 'Voltar',cor: Colors.red,negrito: FontWeight.bold,),onPressed: ()=>Navigator.pop(context),),
                                        ],
                                      ),
                                    );
                                  }
                              );
                          },
                        ),
                        margin: EdgeInsets.only(right: 20),
                      ),
                      Container(
                          height: 50,
                          alignment: Alignment.centerLeft,
                          width: 400,
                          child: TextoPadrao(texto:listaAnalise[i].nomeAnalise,cor: Cores.cinzaTextoEscuro,tamanhoFonte: 12,maxLines: 5,)
                      ),
                      SizedBox(width: 10,),
                      Container(
                        height: 50,
                        alignment: Alignment.center,
                        width: 120,
                        child: TextoPadrao(texto:listaAnalise[i].tempo,cor: Cores.cinzaTextoEscuro,tamanhoFonte: 14,alinhamentoTexto: TextAlign.center,),
                        margin: EdgeInsets.only(right: 10),
                      ),
                      SizedBox(width: 10,),
                      Container(
                          height: 50,
                          alignment: Alignment.centerLeft,
                          width: comentario?largura*0.3:largura*0.35,
                          child: TextoPadrao(texto:listaAnalise[i].pontoChave,cor: Cores.cinzaTextoEscuro,tamanhoFonte: 12,maxLines: 5,)
                      ),
                      Spacer(),
                      comentario?IconButton(onPressed: funcaoComentario, icon: Icon(Icons.report_problem,color: Cores.amarelo_icone_comentario,)):Container()
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    ):Container(
      width: largura,
      height: (listaAnalise.length*250),
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.symmetric(vertical: 5,horizontal: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2, // Define o raio de propagação da sombra
            blurRadius: 3, // Define o raio de desfoque da sombra
            offset: Offset(0, 3), // Define o deslocamento da sombra
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextoPadrao(texto: 'Etapa $numeroEtapa',cor: Cores.primaria,negrito: FontWeight.bold,tamanhoFonte: 12,),
          Container(
            width: largura * 0.8,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: largura * 0.8,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextoPadrao(texto: 'Nome da Etapa',cor: Cores.primaria,tamanhoFonte: 12,),
                      SizedBox(width: 10,),
                      Container(
                          width: largura * 0.5,
                          child: TextoPadrao(texto: nomeEtapa,cor: Cores.cinzaTextoEscuro,tamanhoFonte: 10,maxLines: 5,)
                      ),
                    ],
                  ),
                ),
                Container(
                  width: largura * 0.85,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextoPadrao(texto: 'Tempo total da etapa',cor: Cores.primaria,tamanhoFonte: 12,),
                      SizedBox(width: 10,),
                      Container(
                          width: largura * 0.45,
                          child: TextoPadrao(texto: '$minutos min $segundos seg',cor: Cores.cinzaTextoEscuro,tamanhoFonte: 10,)
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
              width:largura*0.8,
              child: Divider()
          ),
          Container(
            width: largura*0.9,
            height: listaAnalise.length*200,
            child: ListView.separated(
              // physics: NeverScrollableScrollPhysics(),
              separatorBuilder: (context,i)=>Divider(),
              itemCount: listaAnalise.length,
              itemBuilder: (context,i){
                return Container(
                  // color: Colors.blue,
                  width: largura*0.8,
                  // height: (listaAnalise.length*200),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Column(
                            children: [
                              Container(
                                  width: 110,
                                  child: TextoPadrao(texto:'Característica',cor: Cores.primaria,tamanhoFonte: 14,)
                              ),
                              Container(
                                alignment: Alignment.center,
                                width: 90,
                                height: 40,
                                child: listaAnalise[i].imagemSelecionada==''?TextoPadrao(texto: '-',cor: Cores.cinzaTextoEscuro,):Image.asset(listaAnalise[i].imagemSelecionada),
                                margin: EdgeInsets.only(right: 20),
                              ),
                            ],
                          ),
                          SizedBox(width: 5,),
                          Column(
                            children: [
                              Container(
                                child: TextoPadrao(texto:'Análise',cor: Cores.primaria,tamanhoFonte: 14,)
                              ),
                              Container(
                                height: 40,
                                alignment: Alignment.center,
                                child: TextoPadrao(texto:'${i+1}0',cor: Cores.primaria,tamanhoFonte: 14,alinhamentoTexto: TextAlign.center,),
                                margin: EdgeInsets.only(right: 5,)
                              ),
                            ],
                          ),
                          listaAnalise[i].urlVideos.length==0 && listaAnalise[i].urlFotos.length==0?
                          Container(
                            height: 50,
                            width: 50,
                            margin: EdgeInsets.only(right: 20),
                          ):
                          Container(
                            height: 50,
                            width: 50,
                            child: IconButton(
                              icon: Icon(Icons.photo,color: Cores.cinzaTexto,),
                              onPressed: (){
                                showDialog(context: context,
                                    builder: (context){
                                      return Center(
                                        child: AlertDialog(
                                          title: TextoPadrao(texto: 'Mídias',cor: Cores.primaria,negrito: FontWeight.bold,),
                                          content: Container(
                                              height: 750,
                                              width: 1000,
                                              child: ListView(
                                                children: [
                                                  listaAnalise[i].urlFotos.length==0?Container(
                                                    height: 300,
                                                    width: 500,
                                                    child: Center(
                                                      child: TextoPadrao(texto: 'Sem Fotos',cor: Cores.primaria,),
                                                    ),
                                                  ):Container(
                                                    height: 400,
                                                    width: 500,
                                                    padding: EdgeInsets.symmetric(horizontal: 5),
                                                    child: ListView.builder(
                                                      scrollDirection: Axis.horizontal,
                                                      itemCount: listaAnalise[i].urlFotos.length,
                                                      itemBuilder: (context, j) {
                                                        return Column(
                                                          children: [
                                                            FutureBuilder(
                                                              future: precacheImage(NetworkImage(listaAnalise[i].urlFotos[j]), context),
                                                              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                                                                if (snapshot.connectionState == ConnectionState.waiting) {
                                                                  return Center(child: CircularProgressIndicator());
                                                                } else if (snapshot.hasError) {
                                                                  return Center(child: Text('Erro ao carregar imagem'));
                                                                } else {
                                                                  return Image.network(listaAnalise[i].urlFotos[j],height: 350,);
                                                                }
                                                              },
                                                            ),
                                                            idEsp==''?Container():IconButton(
                                                              icon: Icon(Icons.clear,color: Colors.red,),
                                                              onPressed: (){
                                                                print('id $idEsp');
                                                                showDialog(context: context,
                                                                    builder: (context){
                                                                      return Center(
                                                                        child: AlertDialog(
                                                                          title: TextoPadrao(texto: 'Deseja excluír esse item?',cor: Cores.primaria,negrito: FontWeight.bold,),
                                                                          content: Container(
                                                                            height: 40,
                                                                            width: 350,
                                                                            child: TextoPadrao(
                                                                              texto: 'Após exclusão esse item não aparecerá novamente.',
                                                                              cor: Cores.cinzaTextoEscuro,
                                                                            ),
                                                                          ),
                                                                          actions: [
                                                                            TextButton(child: TextoPadrao(texto: 'Não',cor: Colors.green,negrito: FontWeight.bold,),onPressed: ()=>Navigator.pop(context),),
                                                                            TextButton(child: TextoPadrao(texto: 'Confimar Exclusão',cor: Colors.red,negrito: FontWeight.bold,),onPressed: (){
                                                                              print('id $idEsp');
                                                                              print('quero apagar fotos_etapa${numeroEtapa-1}_analise${i}');
                                                                              print(listaAnalise[i].urlFotos[j]);
                                                                              FirebaseFirestore.instance.collection('etapas').doc(idEsp).update({
                                                                                'fotos_etapa${numeroEtapa-1}_analise${i}':FieldValue.arrayRemove([listaAnalise[i].urlFotos[j]])
                                                                              }).then((_){
                                                                                listaAnalise[i].urlFotos.removeAt(j);
                                                                                Navigator.pop(context);
                                                                                Navigator.pop(context);
                                                                              });
                                                                            }),
                                                                          ],
                                                                        ),
                                                                      );
                                                                    });
                                                              },
                                                            )
                                                          ],
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                  listaAnalise[i].urlVideos.length==0?Container(
                                                    height: 350,
                                                    width: 500,
                                                    child: Center(
                                                      child: TextoPadrao(texto: 'Sem Videos',cor: Cores.primaria,),
                                                    ),
                                                  ):Container(
                                                    padding: EdgeInsets.symmetric(horizontal: 5),
                                                    alignment: Alignment.center,
                                                    height: 350,
                                                    width: 500,
                                                    child: ListView.builder(
                                                      scrollDirection: Axis.horizontal,
                                                      itemCount: listaAnalise[i].urlVideos.length,
                                                      itemBuilder: (context, j) {

                                                        VideoPlayerController? controller;
                                                        Future<void>? iniciarVideo;
                                                        controller = VideoPlayerController.networkUrl(Uri.parse(listaAnalise[i].urlVideos[j]));
                                                        controller.setLooping(true);
                                                        controller.setVolume(1.0);
                                                        iniciarVideo = controller!.initialize();

                                                        return Column(
                                                          children: [
                                                            FutureBuilder(
                                                              future: iniciarVideo,
                                                              builder: (context,snapshot){
                                                                if(snapshot.connectionState == ConnectionState.done){
                                                                  return Container(
                                                                    height: 300,
                                                                    alignment: Alignment.center,
                                                                    child: Column(
                                                                      mainAxisSize: MainAxisSize.min,
                                                                      children: [
                                                                        Container(
                                                                          alignment: Alignment.center,
                                                                          height: 250,
                                                                          width: 400,
                                                                          child: AspectRatio(
                                                                            aspectRatio: controller!.value.aspectRatio,
                                                                            child: VideoPlayer(controller),
                                                                          ),
                                                                        ),
                                                                        Container(
                                                                          child: IconButton(
                                                                            style: IconButton.styleFrom(backgroundColor: Cores.primaria),
                                                                            icon: Icon(controller.value.isPlaying? Icons.pause:Icons.play_arrow,color: Colors.white),
                                                                            onPressed: (){
                                                                              if(controller!.value.isPlaying){
                                                                                controller!.pause();
                                                                              }else{
                                                                                controller.play();
                                                                              }
                                                                              // setState(() {});
                                                                            },
                                                                          ),
                                                                        ),
                                                                        Container(
                                                                            width: 400,
                                                                            child: VideoProgressIndicator(controller, allowScrubbing: true,)
                                                                        )
                                                                      ],
                                                                    ),
                                                                  );
                                                                }else{
                                                                  return Container(
                                                                      width: 400,
                                                                      height: 350,
                                                                      child: Center(child: CircularProgressIndicator(),)
                                                                  );
                                                                }
                                                              },
                                                            ),
                                                            idEsp==''?Container():IconButton(
                                                              icon: Icon(Icons.clear,color: Colors.red),
                                                              onPressed: (){
                                                                print('id $idEsp');
                                                                showDialog(context: context,
                                                                    builder: (context){
                                                                      return Center(
                                                                        child: AlertDialog(
                                                                          title: TextoPadrao(texto: 'Deseja excluír esse item?',cor: Cores.primaria,negrito: FontWeight.bold,),
                                                                          content: Container(
                                                                            height: 40,
                                                                            width: 350,
                                                                            child: TextoPadrao(
                                                                              texto: 'Após exclusão esse item não aparecerá novamente.',
                                                                              cor: Cores.cinzaTextoEscuro,
                                                                            ),
                                                                          ),
                                                                          actions: [
                                                                            TextButton(child: TextoPadrao(texto: 'Não',cor: Colors.green,negrito: FontWeight.bold,),onPressed: ()=>Navigator.pop(context),),
                                                                            TextButton(child: TextoPadrao(texto: 'Confimar Exclusão',cor: Colors.red,negrito: FontWeight.bold,),onPressed: (){
                                                                              print('id $idEsp');
                                                                              print('quero apagar videos_etapa${numeroEtapa-1}_analise${i}');
                                                                              print(listaAnalise[i].urlVideos[j]);
                                                                              FirebaseFirestore.instance.collection('etapas').doc(idEsp).update({
                                                                                'videos_etapa${numeroEtapa-1}_analise${i}':FieldValue.arrayRemove([listaAnalise[i].urlVideos[j]])
                                                                              }).then((_){
                                                                                listaAnalise[i].urlVideos.removeAt(j);
                                                                                Navigator.pop(context);
                                                                                Navigator.pop(context);
                                                                              });
                                                                            }),
                                                                          ],
                                                                        ),
                                                                      );
                                                                    });
                                                              },
                                                            )
                                                          ],
                                                        );
                                                      },
                                                    ),
                                                  )
                                                ],
                                              )
                                          ),
                                          actions: [
                                            TextButton(child: TextoPadrao(texto: 'Voltar',cor: Colors.red,negrito: FontWeight.bold,),onPressed: ()=>Navigator.pop(context),),
                                          ],
                                        ),
                                      );
                                    }
                                );
                              },
                            ),
                            margin: EdgeInsets.only(right: 20),
                          ),
                          SizedBox(width: 10,),
                          Column(
                            children: [
                              Container(
                                width: 80,
                                child: TextoPadrao(texto:'Tempo',cor: Cores.primaria,tamanhoFonte: 14,)
                              ),
                              Container(
                                height: 50,
                                alignment: Alignment.center,
                                width: 80,
                                child: TextoPadrao(texto:listaAnalise[i].tempo,cor: Cores.cinzaTextoEscuro,tamanhoFonte: 14,alinhamentoTexto: TextAlign.center,),
                                margin: EdgeInsets.only(right: 10),
                              ),
                            ],
                          )
                        ],
                      ),
                      Container(
                          width: 480,
                          child: TextoPadrao(texto:'Análise da Operação',cor: Cores.primaria,tamanhoFonte: 14,)
                      ),
                      Container(
                          alignment: Alignment.centerLeft,
                          width: 480,
                          child: TextoPadrao(texto: listaAnalise[i].nomeAnalise,cor: Cores.cinzaTextoEscuro,tamanhoFonte: 12,maxLines: 5,)
                      ),
                      Row(
                        children: [
                          TextoPadrao(texto:'Ponto Chave/Razão',cor: Cores.primaria,tamanhoFonte: 14,),
                          Container(
                              height: 50,
                              alignment: Alignment.centerLeft,
                              width: comentario?largura*0.3:largura*0.35,
                              child: TextoPadrao(texto:listaAnalise[i].pontoChave,cor: Cores.cinzaTextoEscuro,tamanhoFonte: 12,maxLines: 5,)
                          ),
                          comentario?IconButton(onPressed: funcaoComentario, icon: Icon(Icons.report_problem,color: Cores.amarelo_icone_comentario,)):Container()
                        ],
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
