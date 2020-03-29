import 'dart:async';

import 'package:flutter/material.dart';
import 'package:awsome_text/bar_pages/mic_page.dart';
import 'package:flutter_sound/flutter_sound.dart';

int _state = 0;
DateTime  _currentTime;
Function _stateChange;
class AudioRecorder extends StatefulWidget{
  AudioRecorderState _recorderState;



  AudioRecorder(_recorder, _path,Function onRecordEnd){
    _recorderState = AudioRecorderState(_recorder, _path,onRecordEnd);
  }

  @override
  AudioRecorderState createState() => _recorderState;

  int getState()=>_state;

  DateTime getDateTime()=>_currentTime;

  // ignore: invalid_use_of_protected_member
  void setState(int state)=>_recorderState.setState(() {
    _state = state;
    _stateChange(_state);
  });

  void setOnRecorderStateChange(Function function ) => _stateChange = function;


}



class AudioRecorderState extends State<AudioRecorder> {
  final List<int> _modes = <int>[1,3,5,7,9];
  //todo: отрефакторить глобальные переменные
  FlutterSound _recorder;
  String _path;

  StreamSubscription<double> _radius;
  StreamSubscription<RecordStatus> _recorderSubscribtion;

  // bool _isPlaying = false;
  //Text _timeLine = Text("");
  double _shapeRadius = 10;
  double _defoultShapeRadious = 15;
  double _maxShapeRadious = 25;
  Function _onRecordEnd;

  AudioRecorderState(this._recorder, this._path,this._onRecordEnd);


  @override
  Widget build(BuildContext context) {

    return AnimatedContainer(
      padding: EdgeInsets.all(_shapeRadius),
      margin: EdgeInsets.all(10),
      width: 100,
      height: 100,
      duration: Duration(milliseconds: 100),

      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.lightGreenAccent,
      ),

      child: FloatingActionButton(
          onPressed: (_state == 0) ? _startRecord : _postRecordingProcess,
          foregroundColor: Colors.green,
          child: Center(
            child: Icon(
              (_state == 0) ? Icons.mic : (_state == -1)
                  ? Icons.done_outline
                  : Icons.stop,
              color: (_state == 1) ? Colors.red : Colors.white,
              size: (_state == 0) ? 40 : 40,
            ),
          )

      ),
    );
  }


  void _startRecord() async {
    if (_recorder.audioState == t_AUDIO_STATE.IS_STOPPED) {
      MicPageConfiguration configuration = new MicPageConfiguration();
      await configuration.mkDir();
      _state = 1;
      _stateChange(_state);
      String s  = await _recorder.startRecorder(
          uri: _path, codec: t_CODEC.CODEC_AAC);
      _recorder.setDbPeakLevelUpdate(0.1);

      _radius = _recorder.onRecorderDbPeakChanged.listen((event) {
        //изменение радиуса
        setState(() {
          _shapeRadius = (event > 0)
              ? _defoultShapeRadious * event / 35
              : _defoultShapeRadious;
          _shapeRadius = (_shapeRadius >_maxShapeRadious)
              ? _maxShapeRadious
              : _shapeRadius;
        });
      });
      _recorderSubscribtion = _recorder.onRecorderStateChanged.listen((event) {
        //получение времени
        if (event != null) {
          _currentTime = new DateTime.fromMillisecondsSinceEpoch(
              event.currentPosition.toInt());
         /* this.setState(() {
            //this._isPlaying = true;
            this._timeLine = Text(date.minute.toString() + " : " +
                date.second.toString() + "/ 5 : 00");
          });*/

          if (_currentTime.minute >= _modes[configuration.maximumDuration]) {
            _stopRecord();
          }
        }
      });
    }
  }
  void _postRecordingProcess(){
    _stopRecord();
    _onRecordEnd();
  }

  void _stopRecord() async {
    if (_recorder.audioState == t_AUDIO_STATE.IS_RECORDING) {
      _state = -1;
      _stateChange(_state);
      await _recorder.stopRecorder();

      if (_recorderSubscribtion != null) {
        _recorderSubscribtion.cancel();
        _recorderSubscribtion = null;
      }

      if (_radius != null) {
        _radius.cancel();
        _radius = null;
      }
      setState(() {
        _shapeRadius = 0;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _stopRecord();
  }


}


