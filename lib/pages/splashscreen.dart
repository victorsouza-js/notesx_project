import 'package:flutter/material.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/login');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.notes, size: 100, color: Colors.black),
            Padding(padding: EdgeInsets.all(5)),
            //SizedBox(height: 5),//
            Text(
              'NotesX',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Padding(padding: EdgeInsets.all(15)),
            //SizedBox(height: 15),//
            const Text(
              'Sua plataforma de anotações',
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            Padding(padding: EdgeInsets.all(20)),
            //SizedBox(height: 20),//
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
