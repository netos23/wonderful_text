
import 'package:awsome_text/bar_pages/camera_page.dart';
import 'package:http/http.dart' as http;
//import 'common.dart';
import 'response.dart';
import 'post.dart';

import 'dart:io';
import 'dart:convert';
import 'package:awsome_text/bar_pages/mic_page.dart';

class MicHttpClient extends FbtwHttpClient{

String _clientId;


  MicPostModel _configureRequest( path,  type, lang){
      return MicPostModel(
        "dfsfk-3242424-sadsd-33443-sssdsdf",
         type,
        _serializeFile(path),
        lang
      );
  }



  Future<String> postRequest(http.Client client,String path) async {
    MicPageConfiguration configuration = MicPageConfiguration();
    await configuration.mkDir();

    final requestBody = jsonEncode(_configureRequest(path, configuration.isPunctuation,configuration.language));

    final response = await client.post("http://192.168.0.24:8090/mic",
        //encoding:Encoding.getByName("utf-8"),
        headers: {
          'Content-type':'application/json'
        },
        body: requestBody
        );

    ResponseModel responseModel = _parseResponse(response.body);
    print(responseModel.clientId);
    if(responseModel.message=="ok"){
      try {
        _clientId = responseModel.clientId;
        String encodedText = responseModel.body;

        var textBytes = base64.decode(encodedText);

        return utf8.decode(textBytes);
      }catch(E){
        print(E);
        return 'error';
      }
    }else{
      return responseModel.message;
    }


  }

String get clientId => _clientId;


}

class CameraHttpClient extends FbtwHttpClient{

  String _clientId;

  @override
  CameraPostModel _configureRequest(path, type, lang) {
    int index = path.toString().lastIndexOf('.')+1;
    return CameraPostModel(
        "dfsfk-3242424-sadsd-33443-sssdsdf",
        lang,
        type,
        _serializeFile(path),
        path.toString().substring(index)
    );
  }

  @override
  Future<String> postRequest(http.Client client,  String path) async {
    CameraPageConfiguration configuration = CameraPageConfiguration();
    await configuration.mkDir();

    final request = _configureRequest(path, configuration.type, configuration.language);
    final parsedRequest = json.encode(request);

    final response = await client.post("http://192.168.0.24:8080/camera",
        headers: {
          'Content-type':'application/json'
        },
        body: parsedRequest,
    );
    ResponseModel responseModel = _parseResponse(response.body);
    print(responseModel.clientId);
    if(responseModel.message=="ok"){
      _clientId = responseModel.clientId;
      try {
        String encodedText = responseModel.body;

        var textBytes = base64.decode(encodedText);

        return utf8.decode(textBytes);
      }catch(E){
        print(E);
        return 'error';
      }
    }else{
      return responseModel.message;
    }

  }

  String get clientId => _clientId;


}



abstract class FbtwHttpClient{
  PostRequest _configureRequest( path,  type, lang);

  String _serializeFile(String path){
    File audio = File(path);

    var bytes = audio.readAsBytesSync();

    Base64Encoder base64encoder = Base64Encoder();


    return base64encoder.convert(bytes);
  }

  Future<String> postRequest(http.Client client,String path);

  Future<ResponseModel> testConnection(http.Client client) async{
    final response = await client.get("http://192.168.0.111:8080/get");

    return _parseResponse(response.body);
  }

  ResponseModel _parseResponse(String responseBody){
    final parsed = jsonDecode(responseBody);

    return ResponseModel.fromJson(parsed);
  }

}

abstract class PostRequest{
  Map<String,dynamic> toJson();
}

