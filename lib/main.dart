import 'package:club_do_livro/pages/login/login_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  runApp(MaterialApp(
    home: LoginPage(),

  ));
  await Firebase.initializeApp();
}