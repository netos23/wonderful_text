import 'dart:async';
import 'dart:io';
import 'package:awsome_text/net/http_clients.dart';
import 'package:awsome_text/widgets/note.dart';
import 'package:awsome_text/widgets/share_page.dart';
import 'package:clipboard_manager/clipboard_manager.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:toast/toast.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;


class CameraPage extends StatefulWidget{
  @override
  CameraPageState createState() =>CameraPageState();
}


class CameraPageState extends State<CameraPage>with WidgetsBindingObserver{

  List<CameraDescription> _cameras;
  CameraController _controller;
  Future<bool> _futureContent;

  String _path;
  final title = "Camera";

  @override
  void initState() {
    super.initState();
    _futureContent  = _prepareCamera();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.green,
      appBar: AppBar(
        title: Text(title),
        actions: <Widget>[
          IconButton(
            icon: Icon(
                Icons.camera_alt
            ),
            onPressed: _cameraPicker,
          ),
          IconButton(
            icon: Icon(
              Icons.panorama
            ),
            onPressed: _imagePicker,
          ),
          IconButton(
            icon: Icon(
              Icons.info
            ),
            onPressed: _infoRoute,
          ),
          IconButton(
            icon: Icon(
              Icons.more_vert
            ),
            onPressed: _cameraSettingsRoute,
          )
        ],
      ),
      body: FutureBuilder<bool>(
          future: _futureContent,
          builder: (context, snapshot) {
            return (snapshot.hasData)
                ? Center(
                    child: AspectRatio(
                      aspectRatio: 3/4,
                      child: CameraPreview(_controller),
                    ),
                 )
                : Center(
                     child: CircularProgressIndicator(),
                );
          }
      ),
      floatingActionButton: FutureBuilder(
          future: _futureContent,
          builder: (context,snap){
            return(snap.hasData)
                ? Container(
                  height: 80,
                  width: 80,
                  margin: const EdgeInsets.all(20),
                  child: FloatingActionButton(
                    child: Icon(
                        Icons.camera,
                        size: 65,
                    ),
                    onPressed: takeAPicture,
                  ),
                )
                :Container();
          }
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Future<bool> _prepareCamera()async{
    _cameras = await availableCameras();
    CameraPageConfiguration configuration = CameraPageConfiguration();
    await configuration.mkDir();
    _controller = CameraController(_cameras[0], photoQualities[configuration._photoQuality]);

    await _controller.initialize();

    return true;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // App state changed before we got the chance to initialize.
    if (_controller == null || !_controller.value.isInitialized) {
      return;
    }
    if (state != AppLifecycleState.resumed) {
      _controller?.dispose();
      print('disposed');
    } else if (state == AppLifecycleState.resumed) {
      if (_controller != null) {
       _futureContent =  _prepareCamera();
      }
    }
  }


  void takeAPicture() async {
    try {
      Directory tempDir = (await getExternalStorageDirectories(
          type: StorageDirectory.dcim))[0];
      //Directory tempDir = await getApplicationSupportDirectory();
      File outputFile;
      outputFile = File('${tempDir.path}/${Uuid().v1()}.jpg');
      //outputFile = File('${tempDir.path}/music/${Uuid().v1()}.aac');
      _path = outputFile.path;
      if (_controller == null && !_controller.value.isInitialized) {
        _futureContent =  _prepareCamera();
        print('camera reprepared');
      }

      await _controller.takePicture(_path);
      _pushImageToPreview(_path);
      //Toast.show('captured', context);
    }catch (e){
      print(e);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }



  void _infoRoute() {
    Navigator.push(context, MaterialPageRoute(builder: (context)=>CameraInfoPage()));
  }

  void _cameraSettingsRoute() {
    Navigator.push(context, MaterialPageRoute(builder: (context)=>SettingsPage()));
  }

  void _imagePicker()async {
    File selectedFile =  await ImagePicker.pickImage(source: ImageSource.gallery);
    if(selectedFile!=null) {
      _pushImageToPreview(selectedFile.path);
    }else{
      Toast.show('You have chosen nothing', context);
      setState(() {
        _futureContent = _prepareCamera();
      });
    }
  }

  void _pushImageToPreview(String path)async{
    await _controller?.dispose();
    Navigator.push(context, MaterialPageRoute(builder: (context)=>CameraPreviewPage(path, title)));
    setState(() {
      _futureContent = _prepareCamera();
    });
  }

  void _cameraPicker()async {
    await _controller?.dispose();

    File selectedFile =  await ImagePicker.pickImage(source: ImageSource.camera);
    if(selectedFile!=null) {
      _pushImageToPreview(selectedFile.path);
    }else{
      Toast.show('You have chosen nothing', context);
      setState(() {
        _futureContent = _prepareCamera();
      });
    }
  }
}

class CameraInfoPage extends StatelessWidget{

  final TextStyle defaultTextStyle = const TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 24,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Camera F.A.Q'),

      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Image.asset(
              'images/camera_app.png',
              scale: 0.4,
            ),
            Text(
              '1. Take a photo or choose from the gallery',
                textAlign: TextAlign.center,
                style: defaultTextStyle,
            ),
            Text(
              '2. Is the text visible in the image? Send it or select a new one.',
              textAlign: TextAlign.center,
              style: defaultTextStyle,
            ),
            Text(
              '3. Copy, save, or export the result',
              textAlign: TextAlign.center,
              style: defaultTextStyle,
            )
          ],
        ),
      ),
    );
  }

}

class CameraPreviewPage extends StatelessWidget{

  String _path;
  final title;

  BuildContext currentContext;


  CameraPreviewPage(this._path, this.title);

  @override
  Widget build(BuildContext context) {
    currentContext = context;
    return Scaffold(
      backgroundColor: Colors.green,
      appBar: AppBar(
        title: Text(title),
      ),
      body: Stack(
        children: <Widget>[
          Container(
             constraints: BoxConstraints.expand(),
             child: Image.file(
                File(_path),
              )
          ),
          Container(
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(15.0))
              ),
              child:Text(
                  'Is the text visible in the image? Send it or select a new one.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                    fontSize: 24
                  ),
              ) ,
          ),
        ],
      )/*Center(
        child: Column(
          children: <Widget>[


          ],
        )
      )*/,
      floatingActionButton: Align(
        alignment: Alignment.bottomCenter,
        child: Row(
          children: <Widget>[
            SizedBox(
              width: 50,
            ),
            Container(
              height: 80,
              width: 80,
              margin: const EdgeInsets.all(25),
              child: FloatingActionButton(
                child: Icon(
                    Icons.refresh,

                ),
                backgroundColor: Colors.red,
                heroTag: 'return',
                onPressed: _return,
              ),
            ),
            Container(
              height: 80,
              width: 80,
              margin: const EdgeInsets.all(25),
              child: FloatingActionButton(
                child: Icon(
                    Icons.done_outline
                ),
                backgroundColor: Colors.blue,
                heroTag: 'push',
                onPressed: _push,
              )
            ),

          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }


  void _return() {
    Navigator.pop(currentContext);
  }

  void _push() {
    Navigator.push(currentContext, MaterialPageRoute(builder: (context)=>CameraResultPage(_path,title)));
  }
}

class SettingsPage extends StatefulWidget{
  @override
  SettingsPageState createState() => SettingsPageState();

}

final List<ResolutionPreset> photoQualities = ResolutionPreset.values;

class SettingsPageState extends State<SettingsPage>{

  final List<String> langs = <String>['english','russian','auto'];
  final List<String> types = <String>['name','lines','blocks'];
  final TextStyle _fontStyle = const TextStyle(
    fontSize: 15.0,
  );

  CameraPageConfiguration _configuration;
  Future<bool> _futureContent;

  int _lang;
  int _type;
  int _photoQuality;

  @override
  void initState() {
    super.initState();
    _configuration = CameraPageConfiguration();
    _futureContent = _getConfig();
  }

  Future<bool> _getConfig()async{
    await _configuration.mkDir();

    _lang = _configuration._language;
    _type = _configuration._type;
    _photoQuality = _configuration._photoQuality;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: FutureBuilder(
          future: _futureContent,
          builder: (context,snap){
            return (snap.hasData)
                ? ListView(
                    children: <Widget>[
                      ListTile(
                          title: Text(
                            'Language',
                            style: _fontStyle,
                          ),
                          trailing: DropdownButton<String>(
                              value: langs[_lang],
                              items: langs.map<DropdownMenuItem<String>>((
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
                          'Photo quality',
                          style: _fontStyle,
                        ),
                        trailing: DropdownButton<ResolutionPreset>(
                            value: photoQualities[_photoQuality],
                            items: photoQualities.map<DropdownMenuItem<ResolutionPreset>>((
                                ResolutionPreset v) {
                              return DropdownMenuItem<ResolutionPreset>(
                                value: v,
                                child: Text(v.toString()),
                              );
                            }).toList(),
                            onChanged: _updateQuality)
                      ),
                      Divider(),
                      ListTile(
                          title: Text(
                            'Recognition type',
                            style: _fontStyle,
                          ),
                          trailing: DropdownButton<String>(
                            value: types[_type],
                            items: types.map<DropdownMenuItem<String>>((String v) {
                              return DropdownMenuItem<String>(
                                value: v,
                                child: Text(v),
                              );
                            }).toList(),
                            onChanged: _updateType,
                          )
                      ),
                    ],
                  )
                : Center(
                    child: CircularProgressIndicator(),
                  );
          }
      ),

    );
  }


  void _updateLang(String value){
    setState(() {
        _lang = langs.indexOf(value);
    });

    _configuration.language = _lang;
    _configuration.safe();

  }

  void _updateQuality(ResolutionPreset value){
    setState(() {
        _photoQuality = photoQualities.indexOf(value);
    });

    _configuration.photoQuality = _photoQuality;
    _configuration.safe();
  }

  void _updateType(String value){
    setState(() {
      _type = types.indexOf(value);
    });

    _configuration.type = _type;
    _configuration.safe();
  }

  @override
  void dispose() {
    _configuration.safe();
    super.dispose();
  }


}

class CameraPageConfiguration{
  int _language;
  int _photoQuality;
  int _type;

  CameraPageConfiguration();

  CameraPageConfiguration.load(){
    mkDir();
  }

  Future<bool> mkDir()async{

    Directory directory = await getExternalStorageDirectory();
    File configFile = File('${directory.path}/config/camera.config');
    if(!( configFile.existsSync())){
      configFile.createSync(recursive: true);
      this._language = 2;
      this._photoQuality = 2;
      this._type = 1;
      safe();

    }else{
      var data =  configFile.readAsStringSync().split(' ');
      this._language = int.parse(data[0]);
      this._photoQuality = int.parse(data[1]);
      this._type = int.parse(data[2]);

    }

    return true;
  }

  void safe()async{
    Directory directory = await getExternalStorageDirectory();
    File configFile = File('${directory.path}/config/camera.config');
    configFile.writeAsString('$_language $_photoQuality $_type');
    print('settings saved');
  }

  int get type => _type;

  set type(int value) {
    _type = value;
  }

  int get photoQuality => _photoQuality;

  set photoQuality(int value) {
    _photoQuality = value;
  }

  int get language => _language;

  set language(int value) {
    _language = value;
  }


}

class CameraResultPage extends StatelessWidget{

  Future<String> _futureContent;
  String _title;
  Note _currentNote;

  BuildContext _currentContext;
  CameraHttpClient client;

  CameraResultPage(String path, String title){
    this._title = title;

    client = CameraHttpClient();
    //_futureContent = client.postRequest(http.Client(), path);
    _futureContent = client.postRequest(http.Client(), path);

  }



  @override
  Widget build(BuildContext context) {
    _currentContext = context;
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
        actions: <Widget>[
          FutureBuilder<String>(
            future: _futureContent,
              builder: (context,snap){
                return snap.hasData
                    ? IconButton(
                        icon: Icon(
                          Icons.save
                        ),
                        onPressed: _save,
                      )
                    : Container();
              }
          ),
          FutureBuilder<String>(
            future: _futureContent,
              builder: (context,snap){
                return snap.hasData
                    ? IconButton(
                        icon: Icon(
                          Icons.share
                        ),
                        onPressed: _share,
                      )
                    : Container();
              }
          ),

        ],
      ),
      body: Center(
        child: FutureBuilder<String>(
            future: _futureContent,
            builder: (context,snap){
              return snap.hasData
                  ? Center(
                    child: ListView(
                      padding: EdgeInsets.all(15),
                      children: <Widget>[
                        SizedBox(
                          height: 50,
                        ),
                        _buildNote(snap),
                        FloatingActionButton(
                          child: Icon(
                              Icons.content_copy
                          ),
                          onPressed: ()async{
                            await ClipboardManager.copyToClipBoard(snap.data);
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
                          'Your note is loading',
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
            }
        ),
      ),
    );
  }

  Note _buildNote(AsyncSnapshot<String> snap) {
   _currentNote =  Note(snap.data);
   return _currentNote;
  }


  void _save()async {
    if(_currentNote!=null){
      _currentNote.print();
      Toast.show('saved',_currentContext);
    }
  }

  void _share() async{
    String res = await _futureContent;
    Navigator.push(_currentContext, MaterialPageRoute(builder: (context)=>SharePage(res,client.clientId)));
  }
}