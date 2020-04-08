import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:awsome_text/widgets/progress_bar.dart';


class MusicPlayer extends StatefulWidget{

  MusicPlayerState _state;

  MusicPlayer(
      String path, { backgroundColor:Colors.blue,
        borderColor:Colors.white,
        fontSize:24,
        width: 400.0,
        height: 120.0,
        topPadding:40.0,
        centerPadding:0.0,
        bottomPadding:34.0,
        barColorsStyle:null,
        buttonOffset:3.35
  }){
    _state = MusicPlayerState(path, backgroundColor, borderColor,
        fontSize, width, height, topPadding, centerPadding,
        bottomPadding, barColorsStyle, buttonOffset);
  }

  @override
  MusicPlayerState createState() => _state;

  void stop() => _state.stop();

}


class MusicPlayerState extends State<MusicPlayer> {
  FlutterSound _player;
  String _path;

  Color _backgroundColor;
  Color _borderColour;

  int _fontSize;

  double _width;
  double _height;

  double _topPadding;
  double _centerPadding;
  double _bottomPadding;

  ProgressBarColorsStyle _barColorsStyle;

  String _fullTime = '00:00';
  String _currentTime = '0:0';
  double _currentTimeValue = 0.0;


  ProgressBar _progressBar;

  StreamSubscription<PlayStatus> _mediaInfo;

  double _buttonsOffset;


  MusicPlayerState(this._path, this._backgroundColor, this._borderColour,
      this._fontSize, this._width, this._height, this._topPadding,
      this._centerPadding, this._bottomPadding, this._barColorsStyle, this._buttonsOffset);

  @override
  void initState() {
    super.initState();
    _progressBar = ProgressBar(
      width: 295.0,
      style: _barColorsStyle,
      progress: 0.0,
    );
    _player = FlutterSound();
    _getInfo();

  }

  void _getInfo() async {
    await _player.startPlayer(
        _path
    );
    _player.onPlayerStateChanged.listen((event) {
      if (_player.audioState == t_AUDIO_STATE.IS_PLAYING) {
        DateTime date = new DateTime.fromMillisecondsSinceEpoch(
            event.duration.toInt());
        setState(() {
          _fullTime = '${date.minute}:${date.second}';
        });
      }
    });
    _player.stopPlayer();
  }


  @override
  Widget build(BuildContext context) {

    return SizedBox(
        width: _width,
        height: _height,

        child: Center(
          child: Container(
            margin: const EdgeInsets.all(20),
            decoration: BoxDecoration(
                color: _backgroundColor,
                border: Border.all(
                    color: _borderColour,
                    width: 2
                ),
                borderRadius: BorderRadius.all(Radius.circular(40.0))
            ),
            child: Column(

              children: <Widget>[
                SizedBox(
                  height: _topPadding,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          flex: 2,
                          child: Align(
                            alignment: Alignment.center,
                            //margin: EdgeInsets.fromLTRB(5, 0, 2, 0),
                            child: Text(
                                _currentTime
                            ),
                          )

                      ),
                      Expanded(
                        flex: 8,
                        child: _progressBar,
                      ),
                      Expanded(
                          flex: 2,
                          child: Align(
                            alignment: Alignment.center,
                            //margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                            child: Text(
                                _fullTime
                            ),
                          )
                      )
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: SizedBox(
                    height: _centerPadding,
                  ),
                ),
                Center(
                  //alignment: Alignment.center,
                  child: Row(
                    children: <Widget>[
                      SizedBox(
                        width: _width / _buttonsOffset,
                      ),

                      IconButton(
                        icon: Icon(
                            (_player.audioState == t_AUDIO_STATE.IS_PLAYING)
                                ? Icons.pause
                                : Icons.play_arrow
                        ),
                        onPressed: _play,
                      ),

                      IconButton(
                        icon: Icon(Icons.stop),
                        onPressed: stop,
                      )
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: SizedBox(
                    height: _bottomPadding,
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }

  void _play() async {
    switch (_player.audioState) {
      case t_AUDIO_STATE.IS_STOPPED:
        await _player.startPlayer(
            _path
        );
         _mediaInfo = _player.onPlayerStateChanged.listen((event) {
           if(event!=null) {
             DateTime date = new DateTime.fromMillisecondsSinceEpoch(
                 event.currentPosition.toInt());
             setState(() {
               _currentTime = '${date.minute}:${date.second}';
               _progressBar.updateProgress(
                   100 * event.currentPosition / event.duration);
               _currentTimeValue = event.currentPosition;
             });
           }
        });
        break;
      case t_AUDIO_STATE.IS_PLAYING:
        _player.pausePlayer();
        break;
      case t_AUDIO_STATE.IS_PAUSED:
        _player.resumePlayer();
        break;

    }
  }

  void stop() async{
    if(_player.audioState!=t_AUDIO_STATE.IS_STOPPED){
      await _player.stopPlayer();
      setState(() {
        _progressBar.updateProgress(0.0);
        _currentTime='0:0';
      });
      if(_mediaInfo!=null){
        _mediaInfo.cancel();
        _mediaInfo=null;
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    stop();
  }


}

class MusicPlayerColorStyle{

  Color _backgroundColor;
  Color _borderColour;
  ProgressBarColorsStyle _barColorsStyle;

  MusicPlayerColorStyle({
    backgroundColor: Colors.blue,
    borderColor: Colors.white,
    barStyle: null
  }){
    this._backgroundColor = backgroundColor;
    this._borderColour = borderColor;
    this._barColorsStyle = (barStyle!=null)?barStyle:ProgressBarColorsStyle();

  }

  ProgressBarColorsStyle get barColorsStyle => _barColorsStyle;

  Color get borderColour => _borderColour;

  Color get backgroundColor => _backgroundColor;


}

/*
enum Music{
  defoult,
  playing,
  pause
}*/
