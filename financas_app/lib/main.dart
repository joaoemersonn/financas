import 'package:financas_app/app/avisos/avisos.dart';
import 'package:financas_app/app/calendario/cadastrar_evento.dart';
import 'package:financas_app/app/calendario/calendario_page.dart';
import 'package:financas_app/app/contato/contato_page.dart';
import 'package:financas_app/app/ged/ged_page.dart';
import 'package:financas_app/app/home/home_page.dart';
import 'package:financas_app/app/usuario/cadastrar_user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'app/avisos/cadastrarAviso_page.dart';
import 'app/spash/SplashScreem.dart';
import 'shared/Constantes.dart';
import 'app/login/login.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Map<String, WidgetBuilder> rotas = {
      'home': (_) => Home(),
      'login': (_) => Login(),
      'ged': (_) => GedPage(),
      'contato': (_) => Contato(),
      'calendario': (_) => CalendarioPage(),
      'avisos': (_) => AvisosPage(),
      'cadastrar_aviso': (_) => CadastrarAviso(),
      'cadastrar_usuario': (_) => CadastrarUserPage(),
      'cadastrar_evento': (_) => CadastrarEvento()
      //,
      //'page_aviso': (_) => Aviso()
    };
    return MaterialApp(
      title: 'SerContábil',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [GlobalMaterialLocalizations.delegate],
      supportedLocales: [const Locale('pt')],
      theme: ThemeData(
        backgroundColor: Constantes.CorPrincipal,
        primarySwatch: Constantes.CorPrincipal,
        //iconTheme: IconThemeData(color: Colors.blue)
      ),
      home: Splash(),
      routes: rotas,
    );
  }
}
