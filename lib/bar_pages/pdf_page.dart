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


class PDFPageState extends State<PDFPage>{


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("pdf"),
      ),
      body: Note(
        'dsfdsjhfhdskjhfks'
      ),
    );
  }

}