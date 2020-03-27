

class MicResponseModel{
  final String message;
  final String body;

  MicResponseModel({this.message,this.body});

  factory MicResponseModel.fromJson( Map<String,dynamic> json){
      return MicResponseModel(
        message: json['message'],
        body: json['body']
      );
  }

  @override
  String toString() {
    return message;
  }


}