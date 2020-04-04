import 'package:flutter/material.dart';
import 'dart:math' as math;

class MicRecordingDecoration extends StatefulWidget{

  MicRecordingDecorationState _state;

  MicRecordingDecoration({
     /*bottomOffsetY : 140.0,
     bottomOffsetX : 40.0,

     topOffsetY : 100.0,
     topOffsetX : 150.0,*/
     bottomOffsetY : 100.0,
     bottomOffsetX : 150.0,

     topOffsetY : 140.0,
     topOffsetX : 40.0,
    width:400.0,
    height: 300.0,
  }){
    _state = MicRecordingDecorationState(bottomOffsetY,bottomOffsetY,topOffsetY,topOffsetX,width,height);
  }

  @override
  MicRecordingDecorationState createState() => _state;



}

class MicRecordingDecorationState extends State<MicRecordingDecoration> with SingleTickerProviderStateMixin{

   AnimationController _controller;

   double _width;
   double _height;

   double _bottomOffsetY;
   double _bottomOffsetX;

   double _topOffsetY;
   double _topOffsetX;


   MicRecordingDecorationState(this._bottomOffsetY, this._bottomOffsetX,
       this._topOffsetY, this._topOffsetX,this._width,this._height);

   @override
  void initState() {
    super.initState();

    _controller =  AnimationController(
      duration: const Duration(seconds: 10),
        vsync: this,
    )..repeat();
  }


  @override
  Widget build(BuildContext context) {
      return SizedBox(
        width: _width,
        height: _height,
        child: Center(
          child: Stack(
            children:  <Widget>[
              Image.asset(
                'images/au_engine_back.png',
              ),
              Positioned(
                top: _bottomOffsetY,
                left: _bottomOffsetX,
                child: AnimatedBuilder(
                  animation:  _controller,
                  child: Image.asset(
                    'images/au_gear2.png',
                    scale: 2,
                  ),
                  builder: (BuildContext context, Widget child) {
                    return Transform.rotate(
                      angle: _controller.value * 2.0 * math.pi,
                      child: child,
                    );

                  },
                ),
              ) ,
              Positioned(
                top: _topOffsetY,
                left: _topOffsetX,
                child: AnimatedBuilder(
                  animation: _controller,
                  child: Image.asset(
                    'images/au_gear1.png',
                    scale: 2,
                  ),
                  builder: (BuildContext context, Widget child) {
                    return Transform.rotate(
                      angle: _controller.value * 2.0 * math.pi,
                      child: child,
                    );

                  },
                ),
              ) ,
            ],

          ) ,
        ),
      );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


}

class PdfPageDecoration extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
            Image.asset(
              'images/pdf_app.png',
              scale: 0.4,
            ),
            SizedBox(
              height: 40,
            ),
            Text(
              'Add the first image or take a photo to create a PDF',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30
              ),
            )
        ],
      ),
    );
  }

}