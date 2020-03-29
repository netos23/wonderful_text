
import 'package:http/http.dart' as http;
import 'response.dart';
import 'post.dart';

import 'dart:io';
import 'dart:convert';
import 'package:awsome_text/bar_pages/mic_page.dart';

class MicHttpClient{




  MicPostModel _configureRequest(String path, bool type,int lang){
      String filename = path.substring(path.lastIndexOf("/")+1);
      return MicPostModel(
        "dfsfk-3242424-sadsd-33443-sssdsdf",
         type,
        _serializeFile(path),
        lang
      );
  }

  String _serializeFile(String path){
    File audio = File(path);

    var bytes = audio.readAsBytesSync();

    Base64Encoder base64encoder = Base64Encoder();


    return base64encoder.convert(bytes);
  }

  Future<String> postRequest(http.Client client,String path) async {
    MicPageConfiguration configuration = MicPageConfiguration();
    await configuration.mkDir();

    final requestBody = jsonEncode(_configureRequest(path, configuration.isPunctuation,configuration.language));

    final response = await client.post("http://192.168.0.24:8080",
        //encoding:Encoding.getByName("utf-8"),
        headers: {
          'Content-type':'application/json'
        },
        body: requestBody
        );

    MicResponseModel responseModel = _parseResponse(response.body);


    if(responseModel.message=="ok"){
      String encodedText = responseModel.body;
      var textBytes = base64.decode(encodedText);
     /* String result="";
      StringBuffer buffer = new StringBuffer();
      buffer.
      for(var byte in textBytes){

      }*/
      return utf8.decode(textBytes);
    }else{
      return responseModel.message;
    }


  }

  Future<MicResponseModel> testConnection(http.Client client) async{
    final response = await client.get("http://192.168.0.111:8080/get");

    return _parseResponse(response.body);
  }

  MicResponseModel _parseResponse(String responseBody){
    final parsed = jsonDecode(responseBody);

    return MicResponseModel.fromJson(parsed);
  }


}