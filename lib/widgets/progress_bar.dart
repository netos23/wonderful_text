import 'package:flutter/material.dart';


class ProgressBar extends StatefulWidget{

  ProgressBarState _progressBarState;


  ProgressBar({
    width: 100.0,
    height: 20.0,
    duration: const Duration(milliseconds: 300),
    progress: 0.0,
    boarderColour: Colors.black,
    forgeGroundColour:  Colors.green,
    backgroundColour: Colors.white,
    ProgressBarColorsStyle style:  null,
  }){
    _progressBarState = ProgressBarState(duration, width, height, progress,
        boarderColour, forgeGroundColour, backgroundColour);
  }



  void updateProgress(double progress){
    _progressBarState.getWidthByProgress(progress);
  }

  @override
  ProgressBarState createState()=>_progressBarState;
}

class ProgressBarState extends State<ProgressBar> {

  Duration _duration;

  double _width;
  double _height;
  double _progress;
  Color _boarderColour;
  Color _forgeGroundColour;
  Color _backgroundColor;

  double _currentWidth;



  ProgressBarState(this._duration, this._width, this._height, this._progress,
      this._boarderColour, this._forgeGroundColour, this._backgroundColor, {ProgressBarColorsStyle style:null}) {
    _progress = (_progress != 0 && _progress < 0) ? 0 : _progress;
    _progress = (_progress > 100) ? 100 : _progress;

    _currentWidth = _width * _progress / 100;


    if(style!=null){
      this._forgeGroundColour = style.forgeGroundColour;
      this._boarderColour = style.boarderColour;
      this._backgroundColor = style.backgroundColour;
    }
  }



  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _width,
      height: _height,
      child: Container(
        width: _width,
        height: _height,
        decoration: BoxDecoration(
            color: _backgroundColor,
            border: Border.all(
                color: _boarderColour,
                width: 2
            ),
            borderRadius: BorderRadius.all(Radius.circular(15.0))
        ),
        child: Align(

          alignment: Alignment.centerLeft,
          child: AnimatedContainer(
            constraints: BoxConstraints(maxWidth: _currentWidth),
            //width: _currentWidth,
            height: _height,
            duration: _duration,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(

                border: Border.all(
                    style: BorderStyle.none
                ),
                color: _forgeGroundColour,
                borderRadius: BorderRadius.all(Radius.circular(15.0))
            ),


          ),
        ),

      ),
    );
  }


  void getWidthByProgress(double progress) {
    setState(() {
      _progress = progress;
      _progress = (_progress >= 0) ? _progress : 0;
      _progress = (_progress <= 100) ? _progress : 100;

      _currentWidth = _width * _progress / 100;
    });
  }

}

class ProgressBarColorsStyle {
   Color _boarderColour;
   Color _forgeGroundColour;
   Color _backgroundColour;

 ProgressBarColorsStyle({
    boarderColour: Colors.black,
    forgeGroundColour: Colors.green,
    backgroundColour: Colors.red,
  }){
     ProgressBarColorsStyle.builder(boarderColour,forgeGroundColour,backgroundColour);
  }

  ProgressBarColorsStyle.builder(this._boarderColour, this._forgeGroundColour,
      this._backgroundColour);

  Color get backgroundColour => _backgroundColour;

  Color get forgeGroundColour => _forgeGroundColour;

  Color get boarderColour => _boarderColour;


}