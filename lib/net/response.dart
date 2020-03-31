

class ResponseModel{
  final String message;
  final String body;
  final String clientId;


  ResponseModel({this.message, this.body, this.clientId});

  factory ResponseModel.fromJson( Map<String,dynamic> json){
      return ResponseModel(
        message: json['message'],
        body: json['body'],
        clientId: json['clientId']
      );
  }

  @override
  String toString() {
    return message;
  }


}