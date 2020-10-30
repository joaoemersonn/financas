import 'package:financas_app/app/Adiministar/adm_page.dart';
import 'package:financas_app/app/avisos/model_avisos.dart';
import 'package:financas_app/app/calendario/calendario_page.dart';
import 'package:financas_app/app/contato/contato_page.dart';
import 'package:financas_app/app/ged/ged_page.dart';
import 'package:financas_app/shared/Constantes.dart';
import 'package:financas_app/shared/Dados.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<AvisoModelo> avisos = Dados.instancia.avisos;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('SerContábil'),
          backgroundColor: Constantes.CorPrincipal,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: AssetImage("images/person.png"))),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Bem Vindo!",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                Dados.instancia.userLogado.nome,
                                style: TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Container(),
                        ),
                        IconButton(
                            padding: EdgeInsets.only(bottom: 15),
                            icon: Icon(
                              Icons.exit_to_app,
                              size: 55,
                            ),
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text("Deseja Realmente Sair?"),
                                      content: Text(
                                          "Se sair deverá fazer login novamente!"),
                                      actions: [
                                        FlatButton(
                                          child: Text("Cancelar"),
                                          onPressed: () =>
                                              Navigator.pop(context),
                                        ),
                                        FlatButton(
                                            child: Text("Sair"),
                                            onPressed: () async {
                                              await Dados.instancia.logout();
                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                              Navigator.pushNamed(
                                                  context, 'login');
                                            }),
                                      ],
                                    );
                                  });
                            }),
                      ],
                    ),
                  ),
                ),
                onTap: () {},
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                _botaoMenu(Image.asset("images/aviso.png", width: 40), "Avisos",
                    avisos: Dados.instancia.avisosnaolidos,
                    funcaobotao: _irAvisoPage),
                //Padding(padding: EdgeInsets.only(left: 30)),
                _botaoMenu(
                    Image.asset("images/contato.png", width: 40), "Contato",
                    funcaobotao: _irContatoPage),
              ]),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                _botaoMenu(Image.asset("images/pasta.png", width: 40), "GED",
                    funcaobotao: _irGedPage),
                //Padding(padding: EdgeInsets.only(left: 30)),
                _botaoMenu(
                    Image.asset("images/calendar.png", width: 50), "Calendario",
                    funcaobotao: _irCandendarPage),
              ]),
              // Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              //   _botaoMenu(Image.asset("images/graph.png", width: 40),
              //       "Demonstrativo"),
              //   //Padding(padding: EdgeInsets.only(left: 30)),
              //   _botaoMenu(
              //       Image.asset("images/phone.png", width: 40), "Solicitações"),
              // ]),
              if (Dados.instancia.userLogado.administrador)
                _botaoMenu(
                    Image.asset("images/admin.png", width: 50), "Administrar",
                    tam: 400, funcaobotao: _irAdmPage),
            ],
          ),
        ));
  }

  _irAvisoPage() {
    Navigator.pushNamed(context, 'avisos').then((value) {
      setState(() {});
    });
  }

  _irContatoPage() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => Contato()));
  }

  _irCandendarPage() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => CalendarioPage()));
  }

  _irAdmPage() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => Admin()));
  }

  _irGedPage() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => GedPage()));
  }

  Container _botaoMenu(Image ico, String texto,
      {Function funcaobotao, int avisos, double tam = 200}) {
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
