import 'package:flutter/material.dart';
import 'package:awsome_text/bar_pages/mic_page.dart';
import 'package:awsome_text/bar_pages/camera_page.dart';
import 'package:awsome_text/bar_pages/docgen_page.dart';
import 'package:awsome_text/bar_pages/pdf_page.dart';
import 'package:awsome_text/bar_pages/more_page.dart';


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
    DocGenPage(),
    MorePage()
  ];

  StatefulWidget _currentWidget = _pages[0];

  void _onTouch(int index){
    setState(() {
      _selectedIndex = index;
      _currentWidget = _pages[_selectedIndex];
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: _currentWidget,
      bottomNavigationBar: BottomNavigationBar(
        items: const<BottomNavigationBarItem>[
          BottomNavigationBarItem(
            backgroundColor: Colors.green,
              title: Text('Audio notes'),
              icon: Icon(
                Icons.mic_none,
                )
          ),
          BottomNavigationBarItem(
              backgroundColor: Colors.green,
              icon: Icon(Icons.camera_alt),
              title: Text('Foto text')
          ),
          BottomNavigationBarItem(
              backgroundColor: Colors.green,
              icon: Icon(Icons.picture_as_pdf),
              title: Text('Make pdf')
          ),
          /*BottomNavigationBarItem(
              backgroundColor: Colors.blue,
              icon: Icon(Icons.featured_play_list),
              title: Text('Doc-gen')
          ),*/
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

}