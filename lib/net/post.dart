import 'http_clients.dart';

class MicPostModel extends PostRequest{
  final String key;
  final bool type;
  final String content;
  final int lang;

  MicPostModel(this.key,this.type,this.content,this.lang);

  Map<String,dynamic> toJson()=>{
    'key':key,
    'type':type,
    'content':content,
    'lang':lang
  };
  
}

class CameraPostModel extends PostRequest{
  final String key;
  final int lang;
  final int type;
  final String content;
  final String fileType;

  CameraPostModel(this.key, this.lang, this.type, this.content, this.fileType);

  Map<String,dynamic> toJson()=>{
    'key':key,
    'lang':lang,
    'type':type,
    'content':content,
    'fileType':fileType
  };


}