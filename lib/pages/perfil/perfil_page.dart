import 'package:flutter/material.dart';

class PerfilPage extends StatefulWidget {
  @override
  _PerfilPageState createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Perfil"),
          centerTitle: true,
          leading: Container(),
        ),
        body: Stack(
          children: [
            Container(
              height: double.infinity,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      Colors.deepOrange,
                      Colors.yellow,
                    ],
                  )
              ),
            ),
          ],
        ),
      ),
    );
  }
}
