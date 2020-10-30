import 'package:financas_app/app/usuario/modelo_usuario.dart';
import 'package:financas_app/shared/Constantes.dart';
import 'package:financas_app/shared/Dados.dart';
import 'package:flutter/material.dart';

class GerUsuarios extends StatefulWidget {
  @override
  _GerUsuariosState createState() => _GerUsuariosState();
}

class _GerUsuariosState extends State<GerUsuarios> {
  bool _carregando = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Gerenciar Usuários"),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
                child: Container(
              margin: EdgeInsets.fromLTRB(0, 15, 0, 15),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(18),
              ),
              child: FutureBuilder(
                  future: Dados.instancia.getUsuarios(),
                  builder: (context, snap) {
                    if (!snap.hasData || _carregando) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snap.data.length <= 0)
                      return Center(
                        child: Text("Não há nenhum Usuário!"),
                      );
                    else
                      return ListView.builder(
                          padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                          itemCount: snap.data.length,
                          itemBuilder: (context, index) {
                            return _usuarioBuilder(snap.data[index]);
                          });
                  }),
            )),
            RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.0),
                  side: BorderSide(color: Colors.grey)),
              padding: EdgeInsets.all(10),
              color: Constantes.CorPrincipal,
              onPressed: () {
                Navigator.pushNamed(context, 'cadastrar_usuario');
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Cadastrar Usuário",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  Padding(padding: EdgeInsets.only(left: 20)),
                  Image.asset(
                    "images/addUser.png",
                    height: 50,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _usuarioBuilder(Usuario u) {
    return Container(
      height: 80,
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: BorderSide(color: Colors.grey)),
        child: Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                Column(
                  children: [
                    Text(
                      "${u.nome}",
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      "Categoria: ${u.categoria}",
                      style: TextStyle(fontSize: 10),
                    ),
                  ],
                ),
                Expanded(child: Container()),
                // IconButton(
                //   onPressed: null,
                //   icon: Icon(Icons.edit),
                // ),
                IconButton(
                  onPressed: () => _delete(u),
                  icon: Icon(Icons.delete),
                )
              ],
            )),
      ),
    );
  }

  _delete(Usuario u) async {
    await Dados.instancia.deleteUser(u);
    setState(() {
      Dados.instancia.getUsuarios();
    });
  }
}
