
import 'dart:async';
import 'dart:io';


import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';

import 'package:awsome_text/widgets/audio_recorder.dart';
import 'package:awsome_text/widgets/decoration.dart';

class MicPage extends StatefulWidget{
  @override
  MicPageState createState() =>MicPageState();
}


class MicPageState extends State<MicPage> {
  String _path;
  FlutterSound _recorderEngine;

  AudioRecorder _audioRecorder;
  int _currentAudioState = 0;

  MicPageState() {
    Future<Directory> tempDir = getTemporaryDirectory();
    File outputFile;
    tempDir.then((value) =>
    {
      outputFile = File('${value.path}/flutter_sound_tmp.aac'),
      _path = outputFile.path
    });

    _recorderEngine = new FlutterSound();

    _audioRecorder = AudioRecorder(_recorderEngine, _path);

    _audioRecorder.setOnRecorderStateChange((int state) {
      setState(() {
        _currentAudioState = state;
      });
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
