
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:share/share.dart';

import 'package:path_provider/path_provider.dart';
import 'package:toast/toast.dart';


class SharePage extends StatefulWidget{

  SharePageState _state;

  SharePage(text, clientId){
    _state = SharePageState(text,clientId);
  }

  @override
  SharePageState createState() => _state;

}


class SharePageState extends State<SharePage> {

  String _serverUrl = "http://fbtw.ru/export/downloadFile/";
  final String _textToExport;
  final String _clientId;
  BuildContext _currentContext;


  SharePageState(this._textToExport,this._clientId);

  //Future<bool> _futureExporter;
  ReceivePort _port = ReceivePort();

  @override
  void initState() {
    super.initState();
//    _futureExporter = _initFlutterDownloader();


    IsolateNameServer.registerPortWithName(_port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];
      setState((){ });
    });

    FlutterDownloader.registerCallback(downloadCallback);
  }

  /*Future<bool> _initFlutterDownloader() async {
    WidgetsFlutterBinding.ensureInitialized();
    await FlutterDownloader.initialize();

    return true;
  }*/


  @override
  Widget build(BuildContext context) {
    _currentContext = context;
    return Scaffold(
        appBar: AppBar(
          title: Text(
              'Share'
          ),
        ),
        body: ListView(
          children: <Widget>[
            ListTile(
              title: Text(
                  "Share"
              ),
              onTap: _share,
            ),
            Divider(),
            ListTile(
              title: Text(
                  "Export to doc"
              ),
              onTap: _docExport,
            ),
            Divider(),
            ListTile(
              title: Text(
                  "Export to docx"
              ),
              onTap: _docxExport,
            ),
            Divider(),
            ListTile(
              title: Text(
                  "Export to PDF"
              ),
              onTap: _pdfExport,
            ),
            Divider(),
            ListTile(
              title: Text(
                  "Export to Google Docs"
              ),
              subtitle: Text(
                  "Requires Google authorization"
              ),
              onTap: _googleDocsExport,
            ),
            Divider(),
          ],
        ),
    );
  }


  void _docExport() {
    _simpleExport('.doc');
  }

  void _docxExport() {
    _simpleExport('.docx');
  }

  void _pdfExport() {
    _simpleExport('.pdf');
  }

  void _simpleExport(type) async {
    String downloadDir = (await getExternalStorageDirectories( type: StorageDirectory.downloads))[0].path;
    String downloadURL = _serverUrl+_clientId+type;

    final taskId = await FlutterDownloader.enqueue(
      url: downloadURL,
      savedDir: downloadDir,
      showNotification: true,
      // show download progress in status bar (for Android)
      openFileFromNotification: true, // click on notification to open downloaded file (for Android)
    );
    Toast.show("downloading the file from the server has started", context);
    final tasks = await FlutterDownloader.loadTasks();

    Navigator.pop(_currentContext);
  }

  void _googleDocsExport() {
    Toast.show('Temporarily unavailable', context);
  }

  void _share() {
    Share.share(_textToExport);
    Navigator.pop(_currentContext);
  }

  static void downloadCallback(String id, DownloadTaskStatus status, int progress) {
    final SendPort send = IsolateNameServer.lookupPortByName('downloader_send_port');
    send.send([id, status, progress]);
  }


  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }
}