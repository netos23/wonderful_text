
import 'dart:async';
import 'dart:io';
import 'package:awsome_text/net/mic_http_client.dart';
import 'package:http/http.dart' as http;


import 'package:awsome_text/widgets/audio_note.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';

import 'package:awsome_text/widgets/audio_recorder.dart';
import 'package:awsome_text/widgets/decoration.dart';
import 'package:awsome_text/widgets/music_player.dart';
import 'package:uuid/uuid.dart';

class MicPage extends StatefulWidget{
  @override
  MicPageState createState() =>MicPageState("Voice notes");
}


class MicPageState extends State<MicPage> {
  String _path;
  FlutterSound _recorderEngine;

  AudioRecorder _audioRecorder;
  int _currentAudioState = 0;

  String _title;


  MicPageState(this._title);

  @override
  void initState() {
    super.initState();
    _mkDir();

  }

  void _mkDir() async{
    Directory tempDir = (await getExternalStorageDirectories( type: StorageDirectory.music))[0];
    //Directory tempDir = await getApplicationSupportDirectory();
    File outputFile;
    outputFile = File('${tempDir.path}/${Uuid().v1()}.aac');
    //outputFile = File('${tempDir.path}/music/${Uuid().v1()}.aac');

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
    Navigator.push(context, MaterialPageRoute(builder: (context)=>MicUploadPage(_path,_title)));
    setState(() {
      _audioRecorder.setState(0);
    });
  }

  void _settingsRoute(){
    Navigator.push(context, MaterialPageRoute(builder: (context)=>Settings()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text(
            _title
        ),
        actions: <Widget>[
          (_currentAudioState==0)
              ? IconButton(
                icon: Icon(
                  Icons.more_vert
                ),
                onPressed: _settingsRoute,
              )
              :Container()
        ],

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

  MicUploadPage(String path,title){
    _micUploadPageState = new MicUploadPageState(path,title);
  }

  @override
  MicUploadPageState createState() => _micUploadPageState;



}

class MicUploadPageState extends State<MicUploadPage> {

  var _path;
  var _title;

  MicUploadPageState(this._path,this._title);



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        /*leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: _return,
          iconSize: 30,
        ),*/
        title: Text(
            _title
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
                onPressed: _push,
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

  void _push(){
    Navigator.push(context, MaterialPageRoute(builder: (context)=>MicResultPage(_path,_title)));
  }
}

class MicResultPage extends StatefulWidget{
  MicResultPageState _state;

  MicResultPage(path,title){
    _state = MicResultPageState(path,title);
  }

  @override
  MicResultPageState createState()=> _state;
}

class MicResultPageState extends State<MicResultPage> {

  String _path;
  String _title;

  MicHttpClient client;


  MicResultPageState(this._path, this._title);



  @override
  void initState() {
    super.initState();
    client = MicHttpClient();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          //leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: (){}),
          title: Text(_title),
        ),
        body: Center(
          child: FutureBuilder<String>(
            future: client.postRequest(http.Client(), _path, true),
            builder: (context, snapshot) {
              if (snapshot.hasError) print(snapshot.error);

              return snapshot.hasData
                  ? Center(
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 100,
                          ),
                          AudioNote(_path, snapshot.data),
                          FloatingActionButton(

                          )
                        ],
                      ),
                   )
                  : Column(
                    children: <Widget>[
                      SizedBox(
                        height: 200,
                      ),

                      Text(
                        'Your audio note is loading',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 40
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),

                      CircularProgressIndicator()
                ],
              );
            },
          ),
        )
    );
  }

}

class SettingsState extends State<Settings> {

  final TextStyle _fontStyle = const TextStyle(
    //fontWeight: FontWeight.bold,
    fontSize: 20,
  );

  MicPageConfiguration _configuration;
  bool _isPunct;
  String  _lang;
  int _duration;
  bool _inited;

  @override
  void initState() {
    super.initState();
    _inited = true;
    _configuration = MicPageConfiguration();
    _getConfig();
  }

  Future<bool> _getConfig()async{
    if(_inited) {
      await _configuration.mkDir();
      _isPunct = _configuration.isPunctuation;
      _lang = _configuration.language;
      _duration = _configuration.maximumDuration;
      _inited = false;
      print(_lang);
      return true;
    }else{
      return _inited;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Settings'),
        ),
        body: FutureBuilder(
            future: _getConfig(),
            builder: (context, snap) {
              return snap.hasData
                  ? ListView(
                    children: <Widget>[
                    ListTile(
                      title: Text(
                        'Language',
                        style: _fontStyle,
                      ),
                      trailing:Text(
                          _lang,
                        ),


                    ),
                    Divider(),
                    ListTile(
                      title: Text(
                        'Automatic punctuation',
                        style: _fontStyle,
                      ),
                      trailing: Checkbox(
                        value: _isPunct,
                        onChanged: _updateCheckBox,
                      ),
                    ),
                    Divider(),
                    ListTile(
                      title: Text(
                        'Maximum duration',
                        style: _fontStyle,
                      ),

                    ),

                ],
              )
                  : CircularProgressIndicator();
            })
    );
  }


  void _updateCheckBox(value) {
    setState(() {
      _isPunct = value;
    });
    _configuration.isPunctuation = value;
    _configuration.safe();
  }

  @override
  void dispose() {
    super.dispose();
    _configuration.safe();
    _inited = true;
  }


}

class Settings extends StatefulWidget{

  @override
  SettingsState createState() =>SettingsState();


}

class MicPageConfiguration{
  String _language;
  int _maximumDuration;
  bool _isPunctuation;

  MicPageConfiguration();
  /*MicPageConfiguration(this._language, this._maximumDuration,
      this._isPunctuation);*/

  MicPageConfiguration.load(){
    mkDir();
  }

  Future<bool> mkDir()async{

    Directory directory = await getExternalStorageDirectory();
    File configFile = File('${directory.path}/config/audio.txt');
    if(!( configFile.existsSync())){
      configFile.createSync(recursive: true);
      this._language = 'english';
      this._maximumDuration = Duration(minutes: 5).inMilliseconds;
      this._isPunctuation = true;
      safe();

    }else{
      var data =  configFile.readAsStringSync().split(' ');
      this._language = data[0];
      this._maximumDuration = int.parse(data[1]);
      this._isPunctuation = data[2]=='true';

    }

    return true;
  }

  void safe()async{
    Directory directory = await getExternalStorageDirectory();
    File configFile = File('${directory.path}/config/audio.txt');
    configFile.writeAsString('${_language} ${_maximumDuration} ${_isPunctuation}');
    print('settings saved');
  }


  String get language => _language;

  set language(String value) {
    _language = value;
  }

  int get maximumDuration => _maximumDuration;

  set maximumDuration(int value) {
    _maximumDuration = value;
  }

  bool get isPunctuation => _isPunctuation;

  set isPunctuation(bool value) {
    _isPunctuation = value;
  }





}