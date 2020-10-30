import 'package:firebase_auth/firebase_auth.dart';

class Usuario {
  String nome;
  String cpfcnpj;
  String categoria;
  String uid;
  String foto;
  User userfirebase;
  bool administrador;

  Usuario(
      {this.nome,
      this.cpfcnpj,
      this.categoria,
      this.uid,
      this.foto,
      this.administrador});

  Usuario.fromJson(Map<String, dynamic> json) {
    nome = json['nome'];
    cpfcnpj = json['cpfcnpj'];
    categoria = json['categoria'];
    uid = json['uid'];
    foto = json['foto'];
    administrador = json['administrador'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nome'] = this.nome;
    data['cpfcnpj'] = this.cpfcnpj;
    data['categoria'] = this.categoria;
    data['uid'] = this.uid;
    data['foto'] = this.foto;
    data['administrador'] = this.administrador;
    return data;
  }
}
