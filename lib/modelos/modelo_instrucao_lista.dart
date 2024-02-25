import 'package:instrucao_de_processos/modelos/modelo_instrucao_item.dart';

class ModeloInstrucaoLista{
  List<ModeloInstrucaoItem> listaNivel1;
  List<ModeloInstrucaoItem> listaNivel2;
  List<ModeloInstrucaoItem> listaNivel3;
  bool nivel1Check;
  bool nivel2Check;
  bool nivel3Check;

  ModeloInstrucaoLista({
      required this.listaNivel1,
      required this.listaNivel2,
      required this.listaNivel3,
      required this.nivel1Check,
      required this.nivel2Check,
      required this.nivel3Check,
  });
}