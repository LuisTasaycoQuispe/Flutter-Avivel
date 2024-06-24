import 'package:myapp/pages/panel_page.dart';
import 'package:myapp/pages/google_maps.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class MainMapPage extends StatefulWidget {
  @override
  _MainMapsPageState createState() => _MainMapsPageState();
}

class _MainMapsPageState extends State<MainMapPage> {
  int _pageIndex = 0;
  final List<Widget> _tabList = [
    GoogleMapsPage(),
    PanelPage(),
  ];

  bool _isKeyboardVisible = false;

  @override
  void initState() {
    super.initState();
    KeyboardVisibilityController().onChange.listen((bool visible) {
      setState(() {
        _isKeyboardVisible = visible;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          _tabList.elementAt(_pageIndex),
          if (!_isKeyboardVisible && _pageIndex != 1)
            Padding(
              padding: const EdgeInsets.all(0),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: ClipRRect(
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                  child: BottomNavigationBar(
                    backgroundColor: Color.fromARGB(255, 177, 177, 177),
                    selectedItemColor: Color.fromARGB(255, 255, 132, 32),
                    unselectedItemColor:
                        const Color.fromARGB(255, 207, 207, 207),
                    showSelectedLabels: true,
                    showUnselectedLabels: false,
                    currentIndex: _pageIndex,
                    onTap: (int index) {
                      setState(() {
                        _pageIndex = index;
                      });
                    },
                    items: [
                      BottomNavigationBarItem(
                        icon: Icon(Icons.padding_outlined),
                        label: "Personas",
                        backgroundColor: const Color.fromARGB(255, 24, 24, 24),
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.close),
                        label: "Cerrar",
                        backgroundColor: const Color.fromARGB(255, 24, 24, 24),
                      )
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
