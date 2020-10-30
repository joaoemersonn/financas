import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financas_app/app/avisos/model_avisos.dart';
import 'package:financas_app/app/avisos/page_aviso.dart';
import 'package:financas_app/shared/Constantes.dart';
import 'package:financas_app/shared/Dados.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CadastrarAviso extends StatefulWidget {
  @override
  _CadastrarAvisoState createState() => _CadastrarAvisoState();
}

class _CadastrarAvisoState extends State<CadastrarAviso> {
  File _arq;
  bool _temImagem = false;
  bool _mei = false;
  bool _simples = false;
  bool _cpf = false;
  bool _cnpj = false;
  bool _isloading = false;
  String _img;
  final List<String> _categoria = List();
  final titulo = TextEditingController();
  final texto = TextEditingController();

  AvisoModelo _submeter() {
    if (_cnpj) _categoria.add("CNPJ");
    if (_cpf) _categoria.add("CPF");
    if (_mei) _categoria.add("MEI");
    if (_simples) _categoria.add("SIMPLES");
    AvisoModelo a = AvisoModelo(titulo.text.toUpperCase(),
        texto: texto.text,
        img: _img,
        categoria: _categoria,
        datapublicacao: Timestamp.now());
    return a;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
            appBar: AppBar(
              title: Text("Cadastar Aviso"),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                setState(() {
                  _isloading = true;
                });
                if (_arq != null) {
                  StorageUploadTask task = FirebaseStorage.instance
                      .ref()
                      .child(DateTime.now().microsecondsSinceEpoch.toString())
                      .putFile(_arq);
                  StorageTaskSnapshot taskSnap = await task.onComplete;
                  String url = await taskSnap.ref.getDownloadURL();
                  print("url: $url");
                  _img = url;
                }
                setState(() {
                  _isloading = false;
                });
                AvisoModelo aviso = _submeter();
                Dados.instancia.gravarAviso(aviso);
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Aviso(aviso)));
              },
              child: Icon(Icons.save),
            ),
            body: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(padding: EdgeInsets.only(top: 20)),
                  TextField(
                      controller: titulo,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Insira Um Titulo Para Aviso")),
                  Padding(padding: EdgeInsets.only(top: 30)),
                  // Text("Insira a Descrição do Aviso:",
                  //     style: TextStyle(fontSize: 16)),
                  Container(
                    //width: 300,
                    height: 250,
                    child: TextField(
                      textAlign: TextAlign.justify,
                      textAlignVertical: TextAlignVertical.top,
                      decoration: InputDecoration(
                        labelText: "Descrição:",
                        labelStyle:
                            TextStyle(fontSize: 22, color: Colors.black),
                        hintText: "Insira uma Descrição Para o Aviso",
                        border: OutlineInputBorder(),
                      ),
                      controller: texto,
                      maxLines: null,
                      minLines: null,
                      expands: true,
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 10)),
                  Text("Categoria dos Clientes a Receber o Aviso:",
                      style: TextStyle(fontSize: 17)),
                  Row(
                    children: [
                      Container(
                        width: 160,
                        height: 45,
                        child: CheckboxListTile(
                          title: Text("CNPJ"),
                          value: _cnpj,
                          onChanged: (newValue) {
                            setState(() {
                              _cnpj = newValue;
                            });
                          },
                          activeColor: Constantes.CorPrincipal,
                          controlAffinity: ListTileControlAffinity
                              .leading, //  <-- leading Checkbox
                        ),
                      ),
                      Container(
                        width: 160,
                        height: 45,
                        child: CheckboxListTile(
                          title: Text("SIMPLES"),
                          value: _simples,
                          onChanged: (newValue) {
                            setState(() {
                              _simples = newValue;
                            });
                          },
                          activeColor: Constantes.CorPrincipal,
                          controlAffinity: ListTileControlAffinity
                              .leading, //  <-- leading Checkbox
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        width: 160,
                        height: 45,
                        child: CheckboxListTile(
                          title: Text("MEI"),
                          value: _mei,
                          onChanged: (newValue) {
                            setState(() {
                              _mei = newValue;
                            });
                          },
                          activeColor: Constantes.CorPrincipal,
                          controlAffinity: ListTileControlAffinity
                              .leading, //  <-- leading Checkbox
                        ),
                      ),
                      Container(
                        width: 160,
                        height: 45,
                        child: CheckboxListTile(
                          title: Text("CPF"),
                          value: _cpf,
                          onChanged: (newValue) {
                            setState(() {
                              _cpf = newValue;
                            });
                          },
                          activeColor: Constantes.CorPrincipal,
                          controlAffinity: ListTileControlAffinity
                              .leading, //  <-- leading Checkbox
                        ),
                      ),
                    ],
                  ),

                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 30, 0, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RaisedButton(
                            color: Constantes.CorPrincipal,
                            textColor: Colors.white,
                            child: Text("Carregar Imagem"),
                            onPressed: () async {
                              final File img = await ImagePicker.pickImage(
                                  source: ImageSource.gallery);
                              if (img == null) return;
                              setState(() {
                                _arq = img;
                                print(_img);
                                _temImagem = true;
                              });
                            }),
                        _temImagem
                            ? Icon(
                                Icons.image,
                                size: 30,
                                color: Colors.grey,
                              )
                            : Container()
                      ],
                    ),
                  )
                ],
              ),
            )),
        if (_isloading)
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
                    "Publicando...",
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
