import 'dart:io';

import 'package:awsome_text/widgets/audio_note.dart';
import 'package:awsome_text/widgets/note.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

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
        title: Text("More"),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            leading: Icon(
              Icons.record_voice_over
            ),
            title: Text(
              'Saved voice notes'
            ),
            onTap: _goToAudioGallery,
          ) ,
          ListTile(
            leading: Icon(
              Icons.photo_library
            ),
            title: Text(
              'Saved text forom photo'
            ),
            onTap: _goToPhotoGallery,
          ),
        ],
      ),
    );
  }


  void _goToAudioGallery() async{
    Directory exStorage = await getExternalStorageDirectory();
    File audioStorage = File('${exStorage.path}/audioNotes/dir.info');
    List<AudioNote> notes = <AudioNote>[];
    if(audioStorage.existsSync()){
      var files = audioStorage.parent.listSync();
      for(var file in files){
        if(file.path.endsWith('.anote')){
          notes.add(AudioNote.fromFile(file.path));
        }
      }
    }
    Navigator.push(context, MaterialPageRoute(builder: (context)=>Gallery(notes,"Voice notes gallery")));


  }

  void _goToPhotoGallery() async{
    Directory exStorage = await getExternalStorageDirectory();
    File audioStorage = File('${exStorage.path}/notes/dir.info');
    List<Note> notes = <Note>[];
    if(audioStorage.existsSync()){
      var files = audioStorage.parent.listSync();
      for(var file in files){
        if(file.path.endsWith('.note')){
          notes.add(Note.fromFile(file.path));
        }
      }
    }
    Navigator.push(context, MaterialPageRoute(builder: (context)=>Gallery(notes,'Notes gallery')));

  }


}

class Gallery extends StatefulWidget{

  GalleryState _state;

  Gallery(content,title){
    _state = GalleryState(content, title);
  }


  @override
  GalleryState createState() => _state;

}

class GalleryState extends State<Gallery>{
  List<Widget> _content;
  String _title;


  GalleryState(this._content, this._title);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _title
        ),
      ),

      body: _content.isEmpty
          ? Center(
            child:  Text(
              "You haven't saved anything yet"
            ),
          )
          : ListView.builder(
            padding: EdgeInsets.all(5),
            itemCount: _content.length,
            itemBuilder: (context,i){
              return _content[i];
            }
          ),
    );
  }

}
