import 'dart:io';

import 'package:flutter/material.dart';
import 'package:awsome_text/bar_pages/mic_page.dart';
import 'package:awsome_text/bar_pages/camera_page.dart';
import 'package:awsome_text/bar_pages/pdf_page.dart';
import 'package:awsome_text/bar_pages/more_page.dart';
import 'package:flutter/services.dart';

import 'package:path_provider/path_provider.dart';

class HomePage extends StatefulWidget{

  @override
  HomePageState createState()=> HomePageState();
}

class HomePageState extends State<HomePage>{

  int _selectedIndex = 0;

  static List<StatefulWidget> _pages = <StatefulWidget>[
    MicPage(),
    CameraPage(),
    PDFPage(),
    MorePage()
  ];

  StatefulWidget _currentWidget = _pages[0];

  void _onTouch(int index){
    setState(() {
      _selectedIndex = index;
      _currentWidget = _pages[_selectedIndex];
    });
  }

  Future<bool> _isFirstLaunch;
  bool _isStateChenge;
  File _initConfig;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    _isFirstLaunch = _getLaunch();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _isFirstLaunch,
      builder: (context,snapshot){
        return snapshot.hasData
            ? _isStateChenge
              ? _buildFirstLaunchPage()
              : _buildHomePage()
            : Center(
              child: CircularProgressIndicator(),
        );
      },
    );
  }

  Future<bool> _getLaunch()async{
    Directory configPath = await getExternalStorageDirectory();
    _initConfig = new File(configPath.path+'/config/init.config');


    if(_initConfig.existsSync()){
      _isStateChenge = false;
      return true;
    }else{
      _initConfig.createSync(recursive: true);
      _isStateChenge = true;
      return false;
    }
  }


  Widget _buildHomePage(){
    return Scaffold(
      body: _currentWidget,
      bottomNavigationBar: BottomNavigationBar(
        items: const<BottomNavigationBarItem>[
          BottomNavigationBarItem(
              backgroundColor: Colors.green,
              title: Text('Voice notes'),
              icon: Icon(
                Icons.mic_none,
              )
          ),
          BottomNavigationBarItem(
              backgroundColor: Colors.green,
              icon: Icon(Icons.camera_alt),
              title: Text('Camera')
          ),
          BottomNavigationBarItem(
              backgroundColor: Colors.green,
              icon: Icon(Icons.picture_as_pdf),
              title: Text('PDF creator')
          ),
          BottomNavigationBarItem(
              backgroundColor: Colors.green,
              icon: Icon(Icons.more_horiz),
              title: Text('More')
          ),
        ],

        selectedItemColor: Colors.black,
        currentIndex: _selectedIndex,
        onTap: _onTouch,
      ),

    );
  }


  final PageController _controller = PageController(

  );


  Widget _buildFirstLaunchPage() {
    return PageView(
      controller: _controller,
      children: <Widget>[
        Scaffold(
          //backgroundColor: Colors.white,
          backgroundColor: Colors.green,
          body: Center(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 100,
                ),
                //Image.asset('images/logo.png'),
                Image.asset('images/logo_alt.png'),
                Text(
                  'Welcome to the Wonderful text app',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      //color: Colors.white,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 35
                  ),
                )
              ],
            ),
          ),
        ),Scaffold(
          backgroundColor: Colors.blue,
          body: Center(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 100,
                ),
                Image.asset('images/camera_app.png'),
                Text(
                  'Recognize text from any source in different languages: audio, photos, and images.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 35
                  ),
                )
              ],
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.green,
          body: Center(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 100,
                ),
                Image.asset('images/audio_app.png'),
                Text(
                  'Create convenient voice notes',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 35
                  ),
                )
              ],
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.red,
          body: Center(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 100,
                ),
                Image.asset('images/pdf_app.png'),
                Text(
                  'Create PDF documents from images. Export the recognized text to any format or open it in Google docs',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 25
                  ),
                )
              ],
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.green,
          body: Center(
            child: Column(
              children: <Widget>[
              SizedBox(
                  height: 50.0,
                ),
                Image.asset(
                    'images/sync.png',
                    scale: 0.8,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Start using the app',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 35
                  ),
                ),
                SizedBox(
                height: 50,
                ),
                Container(
                  width: 250,
                  height: 50,

                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.all(Radius.circular(25))
                  ),
                  child:FlatButton(

                    onPressed: _startApp,
                    //color: Colors.blue,
                    child: Text(
                      'START',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 30
                      ),
                    ),
                  ) ,
                )

              ],
            ),
          ),
        )

      ],
    );
  }


  void _startApp() {
    setState(() {
      _isStateChenge = false;
    });
  }
}

