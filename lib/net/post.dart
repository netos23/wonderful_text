

class MicPostModel {
  final String key;
  final bool type;
  final String content;

  MicPostModel(this.key,this.type,this.content);

  Map<String,dynamic> toJson()=>{
    'key':key,
    'type':type,
    'content':content,
  };
  
}