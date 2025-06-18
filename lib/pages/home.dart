import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NotesX extends StatefulWidget {
  const NotesX({super.key});

  @override
  State<NotesX> createState() => _NotesXState();
}

class _NotesXState extends State<NotesX> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    drawer: Drawer(
      
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.black,
            ),
            child: Icon(
              Icons.notes,
              size: 100,
              color: Colors.white,
              ),
            ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              Navigator.pushNamed(context, '/login');
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],

      ),
      
    ),
      appBar: AppBar(

      ),

    );
  }
}