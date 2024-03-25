import 'package:shared_preferences/shared_preferences.dart';

class PrefService{
  Future salvarConta(String email, String senha)async{
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    _preferences.setString('email', email);
    _preferences.setString('senha', senha);
  }
  Future carregarConta() async{
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    var email = _preferences.getString('email');
    var senha = _preferences.getString('senha');
    List lista = [email,senha];
    return lista;
  }
  Future removerConta() async{
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    _preferences.remove('email');
    _preferences.remove('senha');
  }
}