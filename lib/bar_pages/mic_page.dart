
import 'dart:async';
import 'dart:io';
import 'package:awsome_text/net/http_clients.dart';
import 'package:awsome_text/widgets/share_page.dart';
import 'package:http/http.dart' as http;


import 'package:awsome_text/widgets/audio_note.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';

import 'package:awsome_text/widgets/audio_recorder.dart';
import 'package:awsome_text/widgets/decoration.dart';
import 'package:awsome_text/widgets/music_player.dart';
import 'package:uuid/uuid.dart';

import 'package:clipboard_manager/clipboard_manager.dart';
import 'package:toast/toast.dart';

class MicPage extends StatefulWidget{
  @override
  MicPageState createState() =>MicPageState('Voice notes');
}


class MicPageState extends State<MicPage> {
  String _path;
  FlutterSound _recorderEngine;

  AudioRecorder _audioRecorder;
  int _currentAudioState = 0;

  String _title;
  Future<bool> _futureContent;

  MicPageState(this._title);

  @override
  void initState() {
    super.initState();
    _futureContent = _mkDir();

  }

  Future<bool> _mkDir() async{
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


    return true;
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
                  flex: 9,
                  child:  MicRecordingDecoration(
                    width: 500.0,
                    height: 450.0,
                    bottomOffsetY: 150.0,
                    topOffsetX: 80.0,
                  ),
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
      floatingActionButton: FutureBuilder<bool>(
          future: _futureContent,
          builder: (context,snap){
            return snap.hasData
                ? _audioRecorder
                : Align(
                    alignment: Alignment.bottomCenter,
                    child: CircularProgressIndicator(),
              );
          }
      ),
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

  MusicPlayer _player;

  MicUploadPageState(this._path,this._title);


  @override
  void initState() {
    super.initState();
    _player = MusicPlayer(_path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

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
                  '1. Check whether the audio was recorded correctly',
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
              child: _player,
            ),
            Expanded(
              flex: 1,
              child: Container(
                margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Text(
                  '2. Send or overwrite?',
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

  @override
  void dispose() {
    super.dispose();
    _player.stop();
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

  MicHttpClient _client;

  AudioNote _currentNote;

  bool _inited;

  MicResultPageState(this._path, this._title);
  Future<String> _futureContent;

  @override
  void initState() {
    super.initState();
    _inited = false;
    _client = MicHttpClient();
    _futureContent =  _client.postRequest(
        http.Client(), _path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          //leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: (){}),
          title: Text(_title),
          actions: <Widget>[
            FutureBuilder(
              future: _futureContent,
              builder: (context,snap){
                return (snap.hasData)
                    ? IconButton(
                        icon: Icon(
                            Icons.save
                        ),
                      onPressed: _save,
                      )
                    : Container();
              },
            ),
            FutureBuilder(
              future: _futureContent,
              builder: (context,snap){
                return (snap.hasData)
                    ? IconButton(
                          icon: Icon(
                              Icons.share
                          ),
                          onPressed: _share,
                        )
                    : Container();
              }
            )

          ],
        ),
        body: Center(
          child: FutureBuilder<String>(
            future:_futureContent,
            builder: (context, snapshot) {
              if (snapshot.hasError) print(snapshot.error);

              return snapshot.hasData
                  ? Center(
                      child: ListView(
                        children: <Widget>[
                          SizedBox(
                            height: 100,
                          ),
                          _buildAudioNote(_path, snapshot.data),
                          FloatingActionButton(
                              child: Icon(
                                Icons.content_copy
                              ),
                              onPressed: ()async{
                                await ClipboardManager.copyToClipBoard(snapshot.data);
                                Toast.show("Copied to the clipboard", context);
                              },
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
                        'Your voice note is loading',
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


  AudioNote _buildAudioNote(String path,String text){
    _currentNote = AudioNote(path, text);
    _inited = true;
    return _currentNote;
  }

  void _save() {
    if(_currentNote!=null) {
      _currentNote.printFile();
      Toast.show("Saved", context);
    }
  }

  void _share()async {
    String res = await _futureContent;
    Navigator.push(context, MaterialPageRoute(builder: (context)=> SharePage(res,_client.clientId)));
  }
}

class SettingsState extends State<Settings> {
  final List<String> _langs = <String>['english','russian','auto'];
  final List<String> _modes = <String>['1 minute','3 minutes','5 minutes',
  '7 minute','9 minute'];
  final TextStyle _fontStyle = const TextStyle(
    //fontWeight: FontWeight.bold,
    fontSize: 20,
  );

  MicPageConfiguration _configuration;
  bool _isPunct;
  int  _lang;
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
                        trailing: DropdownButton<String>(
                            value: _langs[_lang],
                            items: _langs.map<DropdownMenuItem<String>>((
                                String v) {
                              return DropdownMenuItem<String>(
                                value: v,
                                child: Text(v),
                              );
                            }).toList(),
                            onChanged: _updateLang)


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
                        trailing: DropdownButton<String>(
                          value: _modes[_duration],
                          items: _modes.map<DropdownMenuItem<String>>((String v) {
                            return DropdownMenuItem<String>(
                              value: v,
                              child: Text(v),
                            );
                          }).toList(),
                          onChanged: _updateDuration,
                        )
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

  void _updateLang(String value){
    setState(() {
      _lang = _langs.indexOf(value);
    });
    _configuration._language = _lang;
    _configuration.safe();
  }
  void _updateDuration(String value){
    setState(() {
      _duration = _modes.indexOf(value);
    });
    _configuration._maximumDuration = _duration;
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
  int _language;
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
    File configFile = File('${directory.path}/config/audio.config');
    if(!( configFile.existsSync())){
      configFile.createSync(recursive: true);
      this._language = 0;
      this._maximumDuration = 2;
      this._isPunctuation = true;
      safe();

    }else{
      var data =  configFile.readAsStringSync().split(' ');
      this._language = int.parse(data[0]);
      this._maximumDuration = int.parse(data[1]);
      this._isPunctuation = data[2]=='true';

    }

    return true;
  }

  void safe()async{
    Directory directory = await getExternalStorageDirectory();
    File configFile = File('${directory.path}/config/audio.config');
    configFile.writeAsString('$_language $_maximumDuration $_isPunctuation');
    print('settings saved');
  }


  int get language => _language;

  set language(int value) {
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