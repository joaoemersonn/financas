import 'package:flutter/material.dart';

class GedPage extends StatefulWidget {
  @override
  _GedPageState createState() => _GedPageState();
}

class _GedPageState extends State<GedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("GED"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
      ),
      body: Column(
        children: [],
      ),
    );
  }
}
