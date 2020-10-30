import 'dart:ui';

import 'package:financas_app/shared/Constantes.dart';
import 'package:financas_app/shared/Dados.dart';
import 'package:flutter/material.dart';

class CadastrarEvento extends StatefulWidget {
  @override
  _CadastrarEventoState createState() => _CadastrarEventoState();
}

class _CadastrarEventoState extends State<CadastrarEvento> {
  DateTime _data;
  final _dateController = TextEditingController();
  final _descricaoController = TextEditingController();
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Novo Evento"),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _descricaoController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Insira uma descrição para o Evento"),
                ),
                Padding(padding: EdgeInsets.only(top: 15)),
                Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                  Container(
                    width: 150,
                    margin: EdgeInsets.only(right: 15),
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      controller: _dateController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          enabled: false,
                          hintText: "    /    /        "),
                    ),
                  ),
                  RaisedButton(
                    onPressed: () async {
                      await _showDatePicker();
                      setState(() {
                        String zero = _data.day < 10 ? "0" : "";
                        String s =
                            "$zero${_data.day}/${_data.month}/${_data.year}";
                        _dateController.text = s;
                      });
                    },
                    child: Text(
                      "Selecione Uma Data",
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Constantes.CorPrincipal,
                  ),
                ]),
                Padding(padding: EdgeInsets.only(top: 15)),
                RaisedButton(
                  padding: EdgeInsets.all(20),
                  color: Constantes.CorPrincipal,
                  onPressed: () async {
                    setState(() {
                      _isLoading = true;
                    });
                    await _submeter();
                    setState(() {
                      _isLoading = false;
                    });
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Cadastrar Evento",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                )
              ],
            ),
          ),
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
                      "Publicando...",
                      style: TextStyle(
                          color: Colors.white, fontSize: 18, decoration: null),
                    )
                  ],
                ),
              ),
            )
        ],
      ),
    );
  }

  Future<void> _showDatePicker() async {
    final data = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2030));
    _data = data;
  }

  Future<void> _submeter() async {
    await Dados.instancia.gravarEvento(_data, _descricaoController.text);
  }
}
