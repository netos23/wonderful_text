import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';


class MusicPlayer extends StatefulWidget{
  final FlutterSound _player;
  String _path;
  MusicPlayer(this._player, this._path);

  @override
  MusicPlayerState createState() => MusicPlayerState(_player,_path);



}


class MusicPlayerState extends State<MusicPlayer>{
  final FlutterSound _player;
  String _path;
  MusicPlayerState(this._player, this._path);

  @override
  Widget build(BuildContext context) {
      return Container(

        child: Column(
            children: <Widget>[

            ],
        ),
      );
  }



}


enum Music{
  defoult,
  playing,
  pause
}