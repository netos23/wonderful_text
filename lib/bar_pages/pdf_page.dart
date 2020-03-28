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

  String _path;
  FlutterSound _recorder;

  PDFPageState() {
    Future<Directory> tempDir =  getTemporaryDirectory();
    File outputFile;
    tempDir.then((value) => {
    outputFile =  File('${value.path}/flutter_sound_tmp.aac'),
        _path = outputFile.path
    });

    _recorder = new FlutterSound();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("pdf"),
      ),
      floatingActionButton: AudioRecorder(_recorder, _path,(){}),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

}