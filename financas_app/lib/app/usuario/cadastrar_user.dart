import 'dart:io';

import 'package:financas_app/app/usuario/modelo_usuario.dart';
import 'package:financas_app/shared/Constantes.dart';
import 'package:financas_app/shared/Dados.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CadastrarUserPage extends StatefulWidget {
  @override
  _CadastrarUserPageState createState() => _CadastrarUserPageState();
}

class _CadastrarUserPageState extends State<CadastrarUserPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String _categoria = "CPF";
  final nomeC = TextEditingController();
  final cpfcnpjC = TextEditingController();
  final emailC = TextEditingController();
  final senhaC = TextEditingController();
  bool _isLoading = false;
  int _radioValue1 = 0;
  String _img;
  File _arq;
  bool _temImagem = false;

  Future<Usuario> _submeter() async {
    Usuario u = Usuario();
    u.cpfcnpj = cpfcnpjC.text;
    u.nome = nomeC.text;
    u.categoria = _categoria;
    u.administrador = (_radioValue1 == 1);
    u = await Dados.instancia.cadastrarUser(u, emailC.text, senhaC.text);
    return u;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              title: Text("Cadastrar Usuário"),
            ),
            body: SingleChildScrollView(
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  GestureDetector(
                      child: Container(
                        margin: EdgeInsets.only(bottom: 30),
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                //  if (_img != null)
                                //     fit: BoxFit.fitWidth,
                                image: _img != null
                                    ? NetworkImage(_img)
                                    : AssetImage("images/person.png"))),
                      ),
                      onTap: () async {
                        final File img = await ImagePicker.pickImage(
                            source: ImageSource.gallery);
                        if (img == null) return;
                        setState(() {
                          _arq = img;
                          print(_img);
                          _temImagem = true;
                        });
                        if (_arq != null) {
                          StorageUploadTask task = FirebaseStorage.instance
                              .ref()
                              .child(DateTime.now()
                                  .microsecondsSinceEpoch
                                  .toString())
                              .putFile(_arq);
                          StorageTaskSnapshot taskSnap = await task.onComplete;
                          String url = await taskSnap.ref.getDownloadURL();
                          print("url: $url");
                          setState(() {
                            _img = url;
                          });
                        }
                      }),
                  TextFormField(
                    controller: nomeC,
                    decoration: InputDecoration(hintText: "NOME/RAZÃO SOCIAL"),
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'Insira um Nome/Razão Social';
                      }
                      return null;
                    },
                  ),
                  Padding(
                      padding: EdgeInsets.only(top: 15),
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        controller: cpfcnpjC,
                        decoration: InputDecoration(hintText: "CPF/CNPJ"),
                      )),
                  Padding(
                      padding: EdgeInsets.only(top: 15),
                      child: TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        controller: emailC,
                        decoration: InputDecoration(hintText: "E-MAIL"),
                      )),
                  Padding(
                      padding: EdgeInsets.only(top: 15),
                      child: TextFormField(
                        obscureText: true,
                        keyboardType: TextInputType.visiblePassword,
                        controller: senhaC,
                        decoration: InputDecoration(hintText: "SENHA"),
                      )),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Selecione a Categoria do Usuário:",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 55,
                    child: DropdownButton<String>(
                      value: _categoria,
                      elevation: 16,
                      style: TextStyle(color: Constantes.CorPrincipal),
                      isExpanded: true,
                      underline: Container(
                        height: 2,
                        color: Constantes.CorPrincipal,
                      ),
                      onChanged: (String newValue) {
                        setState(() {
                          _categoria = newValue;
                        });
                      },
                      items: <String>['CPF', 'CNPJ', 'MEI', 'SIMPLES']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text("Admininistrador:"),
                      new Radio(
                        value: 1,
                        groupValue: _radioValue1,
                        onChanged: (valor) {
                          setState(() {
                            _radioValue1 = valor;
                          });
                        },
                      ),
                      new Text(
                        'Sim',
                        style: new TextStyle(fontSize: 16.0),
                      ),
                      new Radio(
                        value: 0,
                        groupValue: _radioValue1,
                        onChanged: (valor) {
                          setState(() {
                            _radioValue1 = valor;
                          });
                        },
                      ),
                      new Text(
                        'Não',
                        style: new TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(10, 25, 10, 0),
                    width: double.infinity,
                    height: 55,
                    child: RaisedButton(
                      child: Text(
                        "Cadastrar Usuário",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      onPressed: () async {
                        setState(() {
                          _isLoading = true;
                        });
                        final u = await _submeter();
                        setState(() {
                          _isLoading = false;
                        });
                        if (u == null) {
                          _scaffoldKey.currentState.showSnackBar(SnackBar(
                            content: Text("Falha ao Cadastrar!"),
                            backgroundColor: Colors.redAccent,
                            duration: Duration(seconds: 5),
                          ));
                        } else {
                          _scaffoldKey.currentState.showSnackBar(SnackBar(
                            content: Text("Cadastrado com Sucesso!"),
                            backgroundColor: Colors.greenAccent,
                            duration: Duration(seconds: 2),
                          ));
                          Navigator.pop(context);
                        }
                      },
                      color: Constantes.CorPrincipal,
                    ),
                  ),
                ],
              ),
            )),
        if (_isLoading)
          Material(
            // width: double.infinity,
            //height: double.infinity,
            color: Color.fromARGB(155, 0, 0, 0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  Text(
                    "Gravando...",
                    style: TextStyle(
                        color: Colors.white, fontSize: 18, decoration: null),
                  )
                ],
              ),
            ),
          )
      ],
    );
  }
}
