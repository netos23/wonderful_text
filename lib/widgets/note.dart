import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class Note extends StatelessWidget{

  double _width;
  Color _background;
  Color _textColor;
  double _textSize;

  String _text;
  String _path;

  Note(this._text,{
    width: 400.0,
    background: Colors.green,
    textColor: Colors.white,
    textSize: 24.0,
  }){
    this._width = width;
    this._background = background;
    this._textColor = textColor;
    this._textSize = textSize;
  }


  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Center(
        child: Container(
          width: _width,
          padding: const EdgeInsets.all(10),
          margin:  const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(25)),
            color: _background,
          ),
          child: Text(
            _text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _textColor,
              fontSize: _textSize,
              fontWeight: FontWeight.bold
            ),
          ),
        ),
      ),
    );
  }

}