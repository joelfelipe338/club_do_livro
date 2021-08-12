import 'package:club_do_livro/pages/login/login_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      unselectedWidgetColor: Colors.white, // <-- your color
    ),
    home: LoginPage(),
  ));

}
