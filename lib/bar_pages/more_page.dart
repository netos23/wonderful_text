import 'package:flutter/material.dart';
import 'package:awsome_text/widgets/decoration.dart';

class MorePage extends StatefulWidget{
  @override
  MorePageState createState() =>MorePageState();
}


class MorePageState extends State<MorePage>{



  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("more"),
      ),
      body: MicRecordingDecoration(),
    );
  }

}