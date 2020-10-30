import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

import 'model_avisos.dart';

class Aviso extends StatelessWidget {
  final AvisoModelo aviso;
  Aviso(this.aviso);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  aviso.titulo,
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
              ),
              if (aviso.img != null)
                Center(
                  child: Padding(
                      padding: EdgeInsets.only(top: 40),
                      child: FadeInImage.memoryNetwork(
                        placeholder: kTransparentImage,
                        image: aviso.img,
                        //height: 400,
                        fit: BoxFit.cover,
                      ) //Image.network(aviso.img),
                      ),
                ),
              if (aviso.texto != null)
                Padding(
                  padding: EdgeInsets.only(top: 40),
                  child: Text(
                    aviso.texto,
                    textAlign: TextAlign.justify,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
