import 'package:financas_app/shared/Constantes.dart';
import 'package:financas_app/shared/Dados.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'model_avisos.dart';
import 'page_aviso.dart';

class AvisosPage extends StatefulWidget {
  final List<AvisoModelo> avisos = Dados.instancia.avisos;
  AvisosPage();

  @override
  _AvisosPageState createState() => _AvisosPageState();
}

class _AvisosPageState extends State<AvisosPage> {
  bool _carregando = false;
  String stringFiltro = 'Todos';
  //List<AvisoModelo> avisos;
  void _irAviso(AvisoModelo aviso) async {
    if (aviso.lido == null ||
        !aviso.lido.contains(Dados.instancia.userLogado.uid)) {
      if (aviso.lido == null) aviso.lido = List<String>();
      setState(() {
        aviso.lido.add(Dados.instancia.userLogado.uid);
        Dados.instancia.avisosnaolidos -= 1;
      });
      Dados.firestore
          .collection("avisos")
          .doc(aviso.id)
          .update({"lido": aviso.lido});
      print(aviso.lido);
    }
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => Aviso(aviso)));
  }

  Widget _avisoBuilder(AvisoModelo aviso) {
    return GestureDetector(
        onTap: () {
          _irAviso(aviso);
        },
        child: Container(
          width: 300,
          height: 150,
          child: Card(
              color: (aviso.lido != null &&
                      aviso.lido.contains(Dados.instancia.userLogado.uid))
                  ? Colors.grey[300]
                  : Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  side: BorderSide(color: Colors.grey)),
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                        child: Text(
                      aviso.titulo,
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    )),
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 5),
                      child: Container(
                        height: 60,
                        child: Text(
                          aviso.texto != null
                              ? aviso.texto.characters.length > 100
                                  ? (aviso.texto.substring(0, 102) +
                                      // ignore: todo
                                      "[...]") // \n    [CLIQUE PARA EXIBIR TODO O CONTEÚDO]")
                                  : aviso.texto
                              : "[CLIQUE PARA VER IMAGEM]",
                          style: TextStyle(fontSize: 15),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      //margin: EdgeInsets.fromLTRB(180, 35, 0, 0),
                      child: Text(
                        "Data Publicação: ${aviso.datapublicacao.toDate().day}/${aviso.datapublicacao.toDate().month}/${aviso.datapublicacao.toDate().year}",
                        textDirection: TextDirection.rtl,
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    )
                  ],
                ),
              )),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Avisos"),
        actions: [
          IconButton(
            icon: Icon(Icons.sync),
            onPressed: () async {
              setState(() {
                _carregando = true;
              });
              await Future.delayed(const Duration(seconds: 1));
              setState(() {
                Dados.instancia.getAvisos();
                _carregando = false;
              });
            },
          )
        ],
      ),
      // body: ListView.builder(
      //     padding: EdgeInsets.all(10),
      //     itemCount: Dados.instancia.avisos.length,
      //     itemBuilder: (context, index) {
      //       return _avisoBuilder(Dados.instancia.avisos[index]);
      //     }),
      body: Column(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: DropdownButton<String>(
              value: Dados.instancia.stringFiltro,
              icon: FaIcon(
                FontAwesomeIcons.filter,
                size: 18,
              ),
              iconSize: 24,
              elevation: 16,
              style: TextStyle(color: Constantes.CorPrincipal),
              underline: Container(
                height: 2,
                color: Constantes.CorPrincipal,
              ),
              onChanged: (String newValue) {
                setState(() {
                  Dados.instancia.stringFiltro = newValue;
                  Dados.instancia.getAvisos();
                });
              },
              items: <String>['Todos', 'Não-Lidos', 'Lidos']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: FutureBuilder(
                future: Dados.instancia.getAvisos(),
                builder: (context, snap) {
                  if (!snap.hasData || _carregando) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (Dados.instancia.avisos.length <= 0)
                    return Center(
                      child: Text("Não há nenhum Aviso!"),
                    );
                  else
                    return ListView.builder(
                        padding: EdgeInsets.all(10),
                        itemCount: Dados.instancia.avisos.length,
                        itemBuilder: (context, index) {
                          return _avisoBuilder(Dados.instancia.avisos[index]);
                        });
                }),
          )
        ],
      ),
    );
  }
}
