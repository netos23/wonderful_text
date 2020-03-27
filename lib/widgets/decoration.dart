import 'package:flutter/material.dart';
import 'dart:math' as math;

class MicRecordingDecoration extends StatefulWidget{


  @override
  MicRecordingDecorationState createState() => MicRecordingDecorationState();

}

class MicRecordingDecorationState extends State<MicRecordingDecoration> with SingleTickerProviderStateMixin{

   AnimationController _controller;

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
      return Stack(
        children:  <Widget>[
          Image.asset(
            'images/au_engine_back.png',
          ),
           Positioned(
            top: 140,
            left: 40,
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
            top: 100,
            left: 150,
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

      );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


}