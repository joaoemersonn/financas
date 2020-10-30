import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financas_app/app/avisos/model_avisos.dart';
import 'package:financas_app/app/usuario/modelo_usuario.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Dados {
  List<AvisoModelo> avisos; // = List<AvisoModelo>();
  int avisosnaolidos;
  String stringFiltro = "Todos";
  Usuario userLogado;
  static final firestore = FirebaseFirestore.instance;
  static final firebaseAuth = FirebaseAuth.instance;
  static final Dados instancia = Dados.internal();

  static FirebaseStorage firebasestorage;
  factory Dados() => instancia;
  Dados.internal();

  Future<List<AvisoModelo>> getAvisos() async {
    int i = 0;
    List<AvisoModelo> list = List<AvisoModelo>();
    QuerySnapshot snaps;
    if (userLogado.administrador)
      snaps = await FirebaseFirestore.instance
          .collection("avisos")
          .orderBy("datapublicacao")
          .get();
    else
      snaps = await FirebaseFirestore.instance
          .collection("avisos")
          .where("categoria", arrayContains: userLogado.categoria)
          .orderBy("datapublicacao")
          .get();
    for (QueryDocumentSnapshot x in snaps.docs.reversed) {
      AvisoModelo a = AvisoModelo.fromJson(x.data());
      if (stringFiltro == "Todos")
        list.add(a);
      else if (stringFiltro == "Não-Lidos" &&
          (a.lido == null || !a.lido.contains(userLogado.uid)))
        list.add(a);
      else if (stringFiltro == "Lidos" &&
          a.lido != null &&
          a.lido.contains(userLogado.uid)) list.add(a);
      if (a.lido == null || !a.lido.contains(userLogado.uid)) i += 1;
    }
    avisosnaolidos = i;
    avisos = list;
    return list;
  }

  void gravarAviso(AvisoModelo a) async {
    final docid = await firestore.collection("avisos").add(a.toJson());
    a.id = docid.id;
    await firestore.collection("avisos").doc(a.id).update({"id": a.id});
  }

  Future<Usuario> cadastrarUser(
      Usuario usuario, String email, String senha) async {
    final User user = (await firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: senha,
    ))
        .user;
    if (user != null) {
      usuario.userfirebase = user;
      usuario.uid = user.uid;
      firestore.collection("usuarios").add(usuario.toJson());
      return usuario;
    } else
      return null;
  }

  Future<Usuario> login(String email, String senha) async {
    try {
      final user = (await firebaseAuth.signInWithEmailAndPassword(
              email: email, password: senha))
          .user;
      if (user != null) {
        final document = await firestore
            .collection("usuarios")
            .where("uid", isEqualTo: user.uid)
            .limit(1)
            .get();
        final mapUser = document.docs[0].data();
        if (mapUser != null) {
          Usuario usuario = Usuario.fromJson(mapUser);
          usuario.userfirebase = user;
          userLogado = usuario;
          return usuario;
        } else {
          user.delete();
          print("user AUTH excluido");
        }
      }
    } catch (error) {
      return null;
    }
    return null;
  }

  Future<bool> jaLogou() async {
    final user = Dados.firebaseAuth.currentUser;
    if (user != null) {
      final document = await firestore
          .collection("usuarios")
          .where("uid", isEqualTo: user.uid)
          .limit(1)
          .get();
      final mapUser = document.docs[0].data();
      if (mapUser != null) {
        Usuario usuario = Usuario.fromJson(mapUser);
        usuario.userfirebase = user;
        userLogado = usuario;
        await getAvisos();
        return Future.value(true);
      } else {
        user.delete();
        print("user AUTH excluido");
      }
    }
    return Future.value(false);
  }

  Future<FirebaseApp> init() async {
    final retorno = await Firebase.initializeApp();
    // instancia.getAvisos();
    return retorno;
  }

  Future<void> carregarDados() async {
    await getAvisos();
  }

  Future logout() async {
    var result = firebaseAuth.signOut();
    userLogado = null;

    return result;
  }

  Future<List<Usuario>> getUsuarios() async {
    List<Usuario> list = List<Usuario>();
    QuerySnapshot snaps =
        await FirebaseFirestore.instance.collection("usuarios").get();
    for (QueryDocumentSnapshot x in snaps.docs.reversed) {
      Usuario a = Usuario.fromJson(x.data());
      // a.userfirebase =
      list.add(a);
    }
    return list;
  }

  Future<Map<DateTime, List>> getEventos() async {
    Map<DateTime, List> events = Map<DateTime, List>();
    //events.addEntries(newEntries)

    QuerySnapshot snaps =
        await FirebaseFirestore.instance.collection("eventos").get();
    for (QueryDocumentSnapshot x in snaps.docs) {
      Map<DateTime, List<String>> eventos = {
        (x.data()['data'] as Timestamp).toDate():
            x.data()['evento'].cast<String>()
      };
      events.addAll(eventos);
    }
    return events;
  }

  Future<void> gravarEvento(DateTime data, String descricao) async {
    QuerySnapshot snaps = await FirebaseFirestore.instance
        .collection("eventos")
        .where("data", isEqualTo: data)
        .get();
    if (snaps.docs.isEmpty) {
      Map<String, dynamic> evento = {
        "data": data,
        "evento": [descricao]
      };
      await firestore.collection("eventos").add(evento);
    } else {
      final e = snaps.docs.first.data();
      List<String> list = e['evento'].cast<String>();
      list.add(descricao);
      await firestore
          .collection("eventos")
          .doc(snaps.docs.first.id)
          .update({"evento": list});
    }
  }

  deleteUser(Usuario u) async {
    print(u.uid);
    final a = await firestore
        .collection("usuarios")
        .where('uid', isEqualTo: u.uid)
        .limit(1)
        .get();
    await firestore.collection("usuarios").doc(a.docs[0].id).delete();
    print("user excluido");
    //.delete();
  }
}
