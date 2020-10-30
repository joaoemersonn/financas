import 'dart:async';
import 'package:financas_app/shared/Constantes.dart';
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';

import 'RepositorySplash.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  RepositorySplash repository;

  void startTime() {
    new Timer(Duration(seconds: 2), navigatePage);
  }

  void navigatePage() async {
    bool flag = await this.repository.iniciar();
    if (flag) {
      Navigator.pushReplacementNamed(context, 'home');
    } else {
      Navigator.pushReplacementNamed(context, 'login');
    }
  }

  @override
  void initState() {
    super.initState();
    this.repository = RepositorySplash();
    this.startTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _introScreen(),
    );
  }

  Stack _introScreen() {
    return Stack(
      children: <Widget>[
        SplashScreen(
          seconds: 10,
          gradientBackground: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Constantes.CorPrincipal,
              Constantes.CorPrincipalLight,
              Colors.green
            ],
          ),
          // navigateAfterSeconds: Login(),
          loaderColor: Colors.transparent,
        ),
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("images/logo.png"),
              fit: BoxFit.none,
            ),
          ),
        ),
      ],
    );
  }
}
