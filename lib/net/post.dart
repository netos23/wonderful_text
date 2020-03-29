

class MicPostModel {
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