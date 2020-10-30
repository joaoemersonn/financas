import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Contato extends StatelessWidget {
  launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Não Foi Possivel Abrir Link! $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Contato"),
        ),
        body: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Image.asset("images/ser2.jpg")),
              Text("Escolha uma das opções para entrar em Contato conosco:"),
              Padding(padding: EdgeInsets.only(top: 25)),
              GestureDetector(
                onTap: () =>
                    launchURL("https://www.instagram.com/sercontabilst/"),
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Image.asset(
                        "images/insta.png",
                        width: 53,
                      ),
                      Padding(padding: EdgeInsets.only(left: 6)),
                      Text(
                        "@sercontabilst",
                        style: TextStyle(fontSize: 18),
                      )
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => launchURL(
                    "https://api.whatsapp.com/send/?phone=%2B5587981677347&text=ol%C3%A1"),
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Image.asset(
                        "images/zap.png",
                        width: 50,
                      ),
                      Padding(padding: EdgeInsets.only(left: 10)),
                      Text(
                        "(87) 98167-7347",
                        style: TextStyle(fontSize: 18),
                      )
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => launchURL("https://m.facebook.com/sercontabilst/"),
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Image.asset(
                        "images/face.png",
                        width: 50,
                      ),
                      Padding(padding: EdgeInsets.only(left: 10)),
                      Text(
                        "SerContabil",
                        style: TextStyle(fontSize: 18),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
