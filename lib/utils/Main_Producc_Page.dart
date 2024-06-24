
import 'package:myapp/pages/galpones/sheds_register.dart';
import 'package:myapp/pages/panel_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:myapp/pages/transaccional/produccion/produccion.dart';
import 'package:myapp/pages/transaccional/produccion/produccionInac.dart';

class MainProduccionPage extends StatefulWidget {
  @override
  _MainProduccionPageState createState() => _MainProduccionPageState();
}

class _MainProduccionPageState extends State<MainProduccionPage> {
  int _pageIndex = 0;
  final List<Widget> _tabList = [
    ProduccionPages(),
    ShedsRegisterPages(),
    ProduccionInacPages(),
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
          if (!_isKeyboardVisible && _pageIndex != 3)
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: ClipRRect(
                  borderRadius: BorderRadius.all(
                    Radius.circular(30),
                  ),
                  child: BottomNavigationBar(
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
                        label: "Galpones",
                        backgroundColor: const Color.fromARGB(255, 24, 24, 24),
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.add_circle_outline_outlined),
                        label: "Registrar",
                        backgroundColor: const Color.fromARGB(255, 24, 24, 24),
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.person_remove_alt_1_sharp),
                        label: "Inactivos",
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
