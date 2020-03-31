import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:awsome_text/widgets/music_player.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class AudioNote extends StatelessWidget {
  var _width;

  Color _backgroundColor;
  Color _borderColour;
  Color _backgroundTextColor;
  MusicPlayerColorStyle _style;
  String _path;
  String _text;
  AudioNote(this._path, this._text, {
    width: 400.0,
    style: null,
    backgroundColor: Colors.greenAccent,
    borderColour: Colors.white,
    backgroundTextColor: Colors.blue
  }) {
    _width = width;
    _style = (style!=null)?style:MusicPlayerColorStyle();
    _backgroundColor = backgroundColor;
    _borderColour = borderColour;

    //printFile();
  }

  AudioNote.fromFile(fileName){
    File input = File(fileName);
    String inputBody = input.readAsStringSync();

    var path = inputBody.split('~');
    AudioNote(path[0].trim(),path[1].trim());
  }



  void printFile() async{
    Directory directory = await getExternalStorageDirectory();
    File dirFile = File('${directory.path}/audioNotes/dir.info');
    if(!dirFile.existsSync()){
      dirFile.createSync(recursive: true);
    }
    File outputFile = File('${directory.path}/audioNotes/${Uuid().v1()}.anote');
    outputFile.createSync(recursive: true);
    await outputFile.writeAsString('$_path ~$_text');


  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
     // width: _width,
      /*height: 230,*/
      child: Center(
        child: Container(
          //constraints: BoxConstraints.expand(width: _width, height: 230),
          width: _width,
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: _backgroundColor,
              border: Border.all(
                  color: _borderColour,
                  width: 2
              ),
              borderRadius: BorderRadius.all(Radius.circular(15.0))
          ),
          child: Center(
            child: Column(
              children: <Widget>[
                MusicPlayer(
                  _path,
                  buttonOffset: 3.8,
                  topPadding: 28.0,
                  bottomPadding: 10.0,
                  height: 140.0,
                  backgroundColor: _style.backgroundColor,
                  borderColor: _style.borderColour,
                  barColorsStyle: _style.barColorsStyle,
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child:Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: _backgroundTextColor,
                        border: Border.all(
                            color: _borderColour,
                            width: 2
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(15.0))
                    ),
                    child: Text(
                      _text,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ) ,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }


}

