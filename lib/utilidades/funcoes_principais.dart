import 'package:clipboard/clipboard.dart';

class FuncoesPrincipais{

  Future<String> pegarTextoCopiado() async {
    String textoCopiado = await FlutterClipboard.paste();
    return textoCopiado.trim();
  }
}