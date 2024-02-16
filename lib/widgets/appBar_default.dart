import 'package:flutter/material.dart';
import 'package:instrucao_de_processos/widgets/text_default.dart';
import '../utilidades/paleta_cores.dart';
import '../utilidades/variavel_estatica.dart';

class AppBarDefault extends StatelessWidget implements PreferredSizeWidget{
  const AppBarDefault({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(100),
      child: Container(
        height: 100,
        width: VariavelEstatica.width,
        padding: EdgeInsets.all(0),
        margin: EdgeInsets.all(0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerRight,
            end: Alignment.centerLeft,
            colors: PaletaCores.degrade_azul, // Define your gradient colors here
          ),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(radius: 35,backgroundColor: PaletaCores.cinzaClaro),
            ),
            TextDefault(text: 'Instrução de processos',fontSize: 24,fontWeigth: FontWeight.bold),
            Spacer(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(onPressed: (){}, icon: Icon(Icons.person_add_alt_1,color: Colors.white,size: 35,)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(onPressed: (){}, icon: Icon(Icons.logout,color: Colors.white,size: 35,)),
            ),
          ],
        ),
      ),
    );
  }
  @override
  Size get preferredSize => Size.fromHeight(100);
}
