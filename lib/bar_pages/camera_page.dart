import 'package:flutter/material.dart';
import 'package:awsome_text/net/mic_http_client.dart' as httpClient;
import 'package:awsome_text/net/response.dart';
import 'package:http/http.dart' as http;


class CameraPage extends StatefulWidget{
  @override
  CameraPageState createState() =>CameraPageState();
}


class CameraPageState extends State<CameraPage>{

  Widget body = Text("sendInternt");
  httpClient.MicHttpClient client = httpClient.MicHttpClient();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("camera"),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            body,
            IconButton(
              icon: Icon(Icons.play_arrow),
              onPressed: push,
            )
          ],
        ),
      ),
    );
  }

  void push(){
    setState(() {
      body = FutureBuilder<String>(

        future: client.postRequest(http.Client(), "/data/user/0/com.fbtw.awsome_text/cache/flutter_sound_tmp.aac", true),
       // future: client.get(http.Client()),
        builder: (context,snapshot){
          if (snapshot.hasError) print(snapshot.error);

          return snapshot.hasData
              ? Text(snapshot.data)
              : Center(child: CircularProgressIndicator());
        },
      );
    });
  }

}