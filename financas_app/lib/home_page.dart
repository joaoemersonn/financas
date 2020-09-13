import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _textoTela = "Inicio";
  int _index = 0;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Financeiro',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Financeiro'),
          backgroundColor: Colors.green,
        ),
        // #docregion centered-text
        body: Center(
          child: Text(_textoTela),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _index,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text("Inicio"),
              backgroundColor: Colors.green,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.insert_chart),
              title: Text("Resumo"),
              backgroundColor: Colors.green,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.import_export),
              title: Text("Lançamentos"),
              backgroundColor: Colors.green,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people),
              title: Text("Clientes"),
              backgroundColor: Colors.green,
            ),
          ],
          onTap: (index) {
            setState(() {
              _index = index;
              switch (_index) {
                case 0:
                  _textoTela = "Inicio";
                  break;
                case 1:
                  _textoTela = "Resumo";
                  break;
                case 2:
                  _textoTela = "Lançamentos";
                  break;
                case 3:
                  _textoTela = "Clientes";
                  break;
                default:
              }
            });
          },
        ),
      ),
    );
  }
}
