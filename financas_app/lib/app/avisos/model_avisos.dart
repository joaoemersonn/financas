import 'package:cloud_firestore/cloud_firestore.dart';

class AvisoModelo {
  String id;
  String texto;
  String titulo;
  Timestamp datapublicacao;
  String img;
  List<String> categoria;
  List<String> lido;

  AvisoModelo(this.titulo,
      {this.texto, this.datapublicacao, this.img, this.categoria, this.lido});

  AvisoModelo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    texto = json['texto'];
    titulo = json['titulo'];
    datapublicacao = json['datapublicacao'];
    img = json['img'];
    if (json['categoria'] != null) lido = json['categoria'].cast<String>();
    if (json['lido'] != null) lido = json['lido'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['texto'] = this.texto;
    data['titulo'] = this.titulo;
    data['datapublicacao'] = this.datapublicacao;
    data['img'] = this.img;
    data['categoria'] = this.categoria;
    data['lido'] = this.lido;
    return data;
  }
}
