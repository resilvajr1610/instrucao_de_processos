import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../utilidades/cores.dart';

class Teste extends StatefulWidget {
  const Teste({super.key});

  @override
  State<Teste> createState() => _TesteState();
}

class _TesteState extends State<Teste> {

  VideoPlayerController? controller;
  Future<void>? iniciarVideo;

  @override
  void initState() {
    super.initState();
    controller = VideoPlayerController.networkUrl(Uri.parse('https://firebasestorage.googleapis.com/v0/b/instrucao-de-trabalho.appspot.com/o/Processo%2FLIMPEZA%20INTERNA%2FEtapa%2FETAPA1%2FAnalise%2FANALISE%201%2FVideos%2F2024-03-27%2011%3A44%3A05.426.mp4?alt=media&token=92605272-4e0a-4623-9a20-556c2eaf1c80'));
    iniciarVideo = controller!.initialize();
    controller!.setLooping(true);
    controller!.setVolume(1.0);
  }

  @override
  void dispose() {
    super.dispose();
    controller!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: iniciarVideo,
        builder: (context,snapshot){
          if(snapshot.connectionState == ConnectionState.done){
            return Container(
              height: 700,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 650,
                    width: 1500,
                    child: AspectRatio(
                      aspectRatio: controller!.value.aspectRatio,
                      child: VideoPlayer(controller!),
                    ),
                  ),
                    IconButton(
                       style: IconButton.styleFrom(backgroundColor: Cores.primaria),
                       icon: Icon(controller!.value.isPlaying? Icons.pause:Icons.play_arrow,color: Colors.white),
                       onPressed: (){
                        if(controller!.value.isPlaying){
                          controller!.pause();
                        }else{
                          controller!.play();
                        }
                        setState(() {});
                      },
                  ),
                  Container(
                    width: 1500,
                    child: VideoProgressIndicator(controller!, allowScrubbing: true,)
                  )
                ],
              ),
            );
          }else{
            return Center(child: CircularProgressIndicator(),);
          }
        },
      ),
    );
  }
}
