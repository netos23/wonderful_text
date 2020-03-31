import 'package:awsome_text/widgets/note.dart';
import 'package:flutter/material.dart';

import 'dart:async';
import 'dart:io';



import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:awsome_text/widgets/audio_recorder.dart';


class PDFPage extends StatefulWidget{
  @override
  PDFPageState createState() =>PDFPageState();
}


class PDFPageState extends State<PDFPage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[300],
      appBar: AppBar(
        title: Text("Creating a pdf"),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.add_a_photo),
              onPressed: _addPhoto
          ),
          IconButton(
              icon: Icon(Icons.add_photo_alternate),
              onPressed: _addPicture
          ),
          IconButton(
              icon: Icon(Icons.info),
              onPressed: _showInfo
          ),
          IconButton(
              icon: Icon(Icons.more_vert),
              onPressed: _settingsRoute
          ),
        ],
      ),
      body: Note(
          'dsfdsjhfhdskjhfks',
        background: Colors.blue[700],
      ),


    );
  }


  void _addPhoto() {
  }

  void _addPicture() {
  }

  void _showInfo() {
    Navigator.push(context, MaterialPageRoute(builder: (context)=>PDFInfoPage()));
  }

  void _settingsRoute() {
  }
}

class PDFInfoPage extends StatelessWidget{

  final TextStyle defaultTextStyle = const TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 24,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF creator F.A.Q'),

      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Image.asset(
              'images/pdf_app.png',
              scale: 0.4,
            ),
            Text(
              '1. Add a photo or choose from the gallery',
              textAlign: TextAlign.center,
              style: defaultTextStyle,
            ),
            Text(
              '2. Add as many pages as you want.',
              textAlign: TextAlign.center,
              style: defaultTextStyle,
            ),
            Text(
              '3. Package your document in pdf, doc, or docx',
              textAlign: TextAlign.center,
              style: defaultTextStyle,
            )
          ],
        ),
      ),
    );
  }

}
