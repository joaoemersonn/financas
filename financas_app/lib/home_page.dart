import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home Screen',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Inicio'),
        ),
        // #docregion centered-text
        body: Center(
            // #docregion text
            child: ButtonBar(
          children: [
            Text("oi"),
            Text("ola"),
          ],
        )
            // #enddocregion text
            ),
        // #enddocregion centered-text
      ),
    );
  }
}
