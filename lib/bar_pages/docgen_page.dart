import 'package:awsome_text/widgets/music_player.dart';
import 'package:awsome_text/widgets/progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';


class DocGenPage extends StatefulWidget{
  @override
  DocGenPageState createState() =>DocGenPageState();
}


class DocGenPageState extends State<DocGenPage>{

  double _progress=45;
  ProgressBar bar;


  @override
  void initState() {
    bar = ProgressBar(
      progress: _progress,
      boarderColour: Colors.white,
      width: 400.0,
      height: 25.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("docgen"),
      ),
      body: Column(
        children: <Widget>[
          MusicPlayer("",
            topPadding: 30.0,
            height: 150.0,
            width: 440.0,
            barColorsStyle: ProgressBarColorsStyle(
              backgroundColour: Colors.white
            ),
          )

        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){
        setState(() {
          _progress++;
          bar.updateProgress(_progress);
        });
      }),
    );
  }

}