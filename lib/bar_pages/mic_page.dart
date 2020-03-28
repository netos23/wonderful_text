
import 'dart:async';
import 'dart:io';


import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';

import 'package:awsome_text/widgets/audio_recorder.dart';
import 'package:awsome_text/widgets/decoration.dart';
import 'package:awsome_text/widgets/music_player.dart';
import 'package:uuid/uuid.dart';

class MicPage extends StatefulWidget{
  @override
  MicPageState createState() =>MicPageState();
}


class MicPageState extends State<MicPage> {
  String _path;
  FlutterSound _recorderEngine;

  AudioRecorder _audioRecorder;
  int _currentAudioState = 0;



  @override
  void initState() {
    super.initState();
    _mkDir();

  }

  void _mkDir() async{
    Directory tempDir = (await getExternalStorageDirectories( type: StorageDirectory.downloads))[0];
    File outputFile;
    outputFile = File('${tempDir.path}/${Uuid().v1()}.aac');

      _path = outputFile.path;

    _recorderEngine = new FlutterSound();



    _audioRecorder = AudioRecorder(_recorderEngine, _path,_uploadRoute);

    _audioRecorder.setOnRecorderStateChange((int state) {
      setState(() {
        _currentAudioState = state;
      });
    });



  }

  void _uploadRoute(){
    Navigator.push(context, MaterialPageRoute(builder: (context)=>MicUploadPage(_path)));
    setState(() {
      _audioRecorder.setState(0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text(
            "Voice notes"
        ),
      ),
      body: AnimatedCrossFade(
          firstChild: Container(
            margin: EdgeInsets.all(10),
            height: 800,
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 5,
                  child: Image.asset(
                    'images/audio_app.png',
                    scale: 0.5,
                  ),
                )
                ,
                Expanded(
                  flex: 3,
                  child: Text(
                    "Tap on the microphone and start dictating your voice note, follow the instructions below",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                    ),
                  )
                  ,
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    height: 100,
                  ),
                )
              ],
            ),
          ),
          secondChild: Container(
            height: 800,
            margin: EdgeInsets.fromLTRB(0, 10, 10, 50),
            child: Column(

              children: <Widget>[
                Expanded(
                  flex: 8,
                child:  MicRecordingDecoration(),
            ),

                Expanded(
                  flex: 3,
                  child:Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Icon(
                          Icons.fiber_manual_record,
                          color: Colors.red,
                          size: 75,
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          'RECORDING',
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 40
                          ),
                        ),
                      )
                    ],
                  ) ,
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    height: 200,
                  ),
                )
              ],
            ),
          ),
          crossFadeState: (_currentAudioState == 0) ? CrossFadeState
              .showFirst : CrossFadeState.showSecond,
          duration: const Duration(seconds: 3)
      ),
      floatingActionButton: _audioRecorder,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

}

class MicUploadPage extends StatefulWidget{

  MicUploadPageState _micUploadPageState;

  MicUploadPage(String path){
    _micUploadPageState = new MicUploadPageState(path);
  }

  @override
  MicUploadPageState createState() => _micUploadPageState;



}

class MicUploadPageState extends State<MicUploadPage> {

  var _path;

  MicUploadPageState(this._path);



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: _return,
          iconSize: 30,
        ),
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: Column(
          //crossAxisAlignment: CrossAxisAlignment.center,
         // mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                margin: const EdgeInsets.fromLTRB(20, 40, 20, 0),
                child: Text(
                  '1. Проверьте корректно ли записалось аудио',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),
              ),
            Expanded(
              flex: 2,
              child: MusicPlayer(_path),
            ),
            Expanded(
              flex: 1,
              child: Container(
                margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Text(
                  '2. Отправить или презаписать?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child:SizedBox(
                height: 20,
              ) ,
            )
          ],
        ),
      ),
      floatingActionButton: Align(
        alignment: Alignment.bottomCenter,
        child: Row(

          children: <Widget>[
            SizedBox(
              width: 80,
            ),
            SizedBox(
              width: 130,
              height: 130,
              child: FloatingActionButton(
                child: Icon(
                    Icons.refresh,
                    size: 100,
                ),
                heroTag: 'rerecord',
                backgroundColor: Colors.red,
                onPressed: _return,
              ),
            ),
            SizedBox(
              width: 15,
            ),

            SizedBox(
              width: 130,
              height: 130,

              child: FloatingActionButton(
                child: Icon(
                    Icons.done_outline,
                    size: 100,

                ),
                heroTag: 'done',
              ),
            ),


          ],
        ),
      ),
      //floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: SizedBox(
        height: 50,
      ),
    );
  }

  void _return(){
    Navigator.pop(context);
  }
}

