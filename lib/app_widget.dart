import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notesx_project/pages/home.dart';
import 'package:notesx_project/pages/splashscreen.dart';
import 'package:notesx_project/pages/login.dart';
import 'package:notesx_project/pages/cadastro.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/splash',
      routes: {
        '/': (context) =>  NotesX(),
        '/splash': (context) => Splashscreen(),
        '/login': (context) => Login(),
        '/cadastro': (context) => Cadastro(),
      },
      );
      
  }
}
