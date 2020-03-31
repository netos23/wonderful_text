

class ResponseModel{
  final String message;
  final String body;

  ResponseModel({this.message,this.body});

  factory ResponseModel.fromJson( Map<String,dynamic> json){
      return ResponseModel(
        message: json['message'],
        body: json['body']
      );
  }

  @override
  String toString() {
    return message;
  }


}