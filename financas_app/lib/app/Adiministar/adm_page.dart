import 'package:financas_app/app/Adiministar/gerenciar_usuarios.dart';
import 'package:flutter/material.dart';

class Admin extends StatefulWidget {
  @override
  _AdminState createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Admin")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(padding: EdgeInsets.only(top: 60)),
            _botaoMenu(
                Image.asset("images/aviso.png", width: 40), "Publicar Aviso",
                funcaobotao: _irCadAvisoPage),
            // _botaoMenu(Image.asset("images/phone.png", width: 50),
            //     "Gerenciar Solicitações"),
            _botaoMenu(
                Image.asset("images/calendar.png", width: 50), "Novo Evento",
                funcaobotao: _irCadAvisoEventoPage),
            _botaoMenu(Image.asset("images/usuarios.png", width: 50),
                "Gerenciar Usuários",
                funcaobotao: _irGerUserPage),
          ],
        ),
      ),
    );
  }

  _irCadAvisoPage() {
    Navigator.pushNamed(context, 'cadastrar_aviso');
  }

  _irCadAvisoEventoPage() {
    Navigator.pushNamed(context, 'cadastrar_evento');
  }

  _irGerUserPage() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => GerUsuarios()));
  }

  Container _botaoMenu(Image ico, String texto,
      {Function funcaobotao, int avisos, double tam = 400}) {
    return Container(
      padding: EdgeInsets.all(10),
      width: tam,
      height: 160,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
            side: BorderSide(color: Colors.grey)),
        color: Colors.white,
        elevation: 10,
        onPressed: funcaobotao,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            avisos != null && avisos > 0
                ? Padding(
                    padding: EdgeInsets.only(left: 110),
                    child: CircleAvatar(
                      radius: 15,
                      child: Text(avisos.toString()),
                    ),
                  )
                : Container(),
            ico,
            Padding(padding: EdgeInsets.only(top: 30)),
            Text(texto)
          ],
        ),
      ),
    );
  }
}
