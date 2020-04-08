import 'dart:convert';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_uploader/flutter_uploader.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:awsome_text/widgets/decoration.dart';
import 'package:path_provider/path_provider.dart';
import 'package:toast/toast.dart';



class PDFPage extends StatefulWidget{
  @override
  PDFPageState createState() =>PDFPageState();
}


class PDFPageState extends State<PDFPage> {

  List<File> _pdfContent = <File>[];

  String _title = "PDF creator";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[300],
      appBar: AppBar(
        title: Text(_title),
        actions: <Widget>[

          IconButton(
              icon: Icon(Icons.add_a_photo),
              onPressed: _addPhoto
          ),
          IconButton(
              icon: Icon(Icons.add_photo_alternate),
              onPressed: _addPicture
          ),
          (_pdfContent.isNotEmpty)
              ? IconButton(
              icon: Icon(Icons.restore_from_trash),
              onPressed: _removeAll
          )
              : Container(),
          (_pdfContent.isNotEmpty)
              ? IconButton(
              icon: Icon(Icons.remove_circle_outline),
              onPressed: _removeLast
          )
              : Container(),
          IconButton(
              icon: Icon(Icons.info),
              onPressed: _showInfo
          ),
          /*IconButton(
              icon: Icon(Icons.more_vert),
              onPressed: _settingsRoute
          ),*/
        ],
      ),
      body: _pdfContent.isEmpty
          ? PdfPageDecoration()
          : ListView.builder(
          padding: EdgeInsets.all(5),
          itemCount: _pdfContent.length,
          itemBuilder: (context,i){

            return Image.file(_pdfContent[i]);
          }
          ),

      floatingActionButton: _pdfContent.isEmpty
                            ? null
                            : Container(
                              width: 80,
                              height: 80,
                              child: FloatingActionButton(
                                child: Icon(
                                  Icons.done_outline,
                                  size: 40,
                                ),
                                mini: false,
                                onPressed: _push,
                              ),
                              ),
    );
  }


  void _addPhoto()  {
    _pushImage(ImageSource.camera);
  }

  void _addPicture(){
     _pushImage(ImageSource.gallery);
  }

  void _pushImage(sourse)async{
    File selectedFile =  await ImagePicker.pickImage(source: sourse);
    if(selectedFile!=null) {
      setState(() {
        _pdfContent.add(selectedFile);
      });
    }
  }

  void _showInfo() {
    Navigator.push(context, MaterialPageRoute(builder: (context)=>PDFInfoPage()));
  }

  void _push() {
    Navigator.push(context, MaterialPageRoute(builder: (context)=>UploadPage(_pdfContent,_title)));
  }

  /*void _settingsRoute() {
  }*/

  void _removeAll() {
    setState(() {
      _pdfContent.clear();
    });
  }

  void _removeLast() {
    setState(() {
      _pdfContent.removeLast();
    });
  }
}

class PDFInfoPage extends StatelessWidget{

  final TextStyle defaultTextStyle = const TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 24,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF creator F.A.Q'),

      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Image.asset(
              'images/pdf_app.png',
              scale: 0.4,
            ),
            Text(
              '1. Add a photo or choose from the gallery',
              textAlign: TextAlign.center,
              style: defaultTextStyle,
            ),
            Text(
              '2. Add as many pages as you want.',
              textAlign: TextAlign.center,
              style: defaultTextStyle,
            ),
            Text(
              '3. Package your document in pdf, doc, or docx',
              textAlign: TextAlign.center,
              style: defaultTextStyle,
            )
          ],
        ),
      ),
    );
  }



}
class UploadPage extends StatefulWidget{
  UploadPageState _state;
  
  UploadPage(pdfContent,title){
    _state = UploadPageState(pdfContent,title);
  }

  @override
  UploadPageState createState() => _state;
  
  
}
class UploadPageState extends State<UploadPage>{

  final List<File> _pdfContent;
  final String _title;
  FlutterUploader uploader;
  ReceivePort _port = ReceivePort();

  String _serverUrl = 'http://fbtw.ru/export/getPdf/';

  UploadPageState(this._pdfContent,this._title);


  @override
  void initState() {
    super.initState();

    uploader = FlutterUploader();
    _uploadFiles();

    IsolateNameServer.registerPortWithName(_port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];
      setState((){ });
    });

    FlutterDownloader.registerCallback(downloadCallback);
    
  }

  static void downloadCallback(String id, DownloadTaskStatus status, int progress) {
    final SendPort send = IsolateNameServer.lookupPortByName('downloader_send_port');
    send.send([id, status, progress]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          _title
        ),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Center(
                child: MicRecordingDecoration(
                  topOffsetX: 200.0,
                  topOffsetY: 210.0,
                  bottomOffsetY: 110.0,
                  bottomOffsetX: 300.0,
                  width: 400.0,
                  height: 450.0,
            ),
        )
            ,
            SizedBox(
              height: 5,
            ),
            Text(
              'Creating your PDF...',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold
              ),
            )

          ],
        ),
      ),
    );
  }



  void _uploadFiles() async{
    final taskId = await uploader.enqueue(
        url: 'http://fbtw.ru/export/uploadMultipleFiles',
        files: _convertToItems(),
        method: UploadMethod.POST,
        headers: {
          'Content-Type':'multipart/form-data; boundary=<calculated when request is sent>',
          'Content-Length':'<calculated when request is sent>',
          "token": "Sdsjdf343-dksfjhJHD34-djfhdHHHDK2",
          "apiKey": "dsfdsf",},
        showNotification: false,

        tag: "Pdf creating..."
    );
    var res =  uploader.result.listen((event) {
      uploader.cancel(taskId: taskId);
      List<dynamic> responseParsed = jsonDecode(event.response);
      if(responseParsed.isNotEmpty){
        Map<String,dynamic> mapClientId = responseParsed[0];
        _downloadResult(mapClientId['clientId']);
      }else{
          _ReturnError();
      }
    },
    /*cancelOnError: true,
      onError: (){
        _ReturnError();
      }*/
    );
    var progress = uploader.progress.listen((event) {
      if(event.status==UploadTaskStatus.complete){
        res.cancel();
      }
    });


   // var clientId = _getResult();

  }
  
  void _ReturnError(){
    Toast.show('Failed to create a document', context);
    Navigator.pop(context);
  }



  void _downloadResult(clientId) async{
    String downloadDir = (await getExternalStorageDirectories( type: StorageDirectory.downloads))[0].path;
    String downloadURL = _serverUrl+clientId;

    final taskId = await FlutterDownloader.enqueue(
    url: downloadURL,
    savedDir: downloadDir,
    showNotification: true,
    // show download progress in status bar (for Android)
    openFileFromNotification: true, // click on notification to open downloaded file (for Android)
    );
    Toast.show("downloading the file from the server has started", context);
    final tasks = await FlutterDownloader.loadTasks();

    Navigator.pop(context);
    
  }

  List<FileItem> _convertToItems(){
    int indicator = 0;
    List<FileItem> result = <FileItem>[];
    for(var element in _pdfContent){
      var path = element.path;
      var beginIndex = path.lastIndexOf('/')+1;
      var endIndex = path.lastIndexOf('.');
      path = element.renameSync(path.substring(0,beginIndex) + '${indicator++}'+ path.substring(endIndex)).path;
      result.add(FileItem(
          filename: (path.substring(beginIndex)),
          savedDir: element.parent.path,
          fieldname: 'files'
      ));
    }
    return result;
  }

  @override
  void dispose() {
    uploader.dispose();
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }
}
