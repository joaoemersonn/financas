import 'package:financas_app/shared/Dados.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';

class RepositorySplash {
  Future<bool> iniciar() async {
    final FirebaseApp app = await Dados.instancia.init();
    final FirebaseStorage storage = FirebaseStorage(
        app: app, storageBucket: 'gs://flutter-firebase-plugins.appspot.com');
    Dados.firebasestorage = storage;
    return Dados.instancia.jaLogou();
    //else
    //return Future.value(true);
  }
}
