import 'package:myapp/pages/profile_screen.dart';
import 'package:myapp/widgets/oscuro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import 'package:rive/rive.dart';

class PanelPage extends StatefulWidget {
  @override
  _PanelPageState createState() => _PanelPageState();
}

class _PanelPageState extends State<PanelPage> {
  bool isPressed = false;
  bool isPressedGalpon = false;
  bool isPressedProduccion = false;
  bool isPressedAsignacion = false;

  Future<void> _navigateToProfile(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('userId');

    if (userId != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfileScreen(userId),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se encontró el ID del usuario')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Provider.of<ModoNocturnoProvider>(context).modoNocturno
          ? Color.fromARGB(255, 26, 26, 26)
          : Color.fromARGB(255, 255, 255, 255),
      body: Stack(
        children: [
          Positioned.fill(
            top: 450,
            child: Container(),
          ),
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 240,
                  padding: EdgeInsets.only(
                    top: 38,
                    left: 18,
                    right: 18,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "PANEL",
                        style: TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 18,
                      ),
                      Text(
                        "Control de Almacenes y Gestion de Usuarios",
                        style: TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontSize: 15.0,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Container(
                        width: double.infinity,
                        height: 75,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 255, 255, 255),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(16),
                            bottomRight: Radius.circular(16),
                            topRight: Radius.circular(16),
                            topLeft: Radius.circular(16),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromARGB(166, 22, 22, 22)
                                  .withOpacity(0.4),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              child: TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, "maps");
                                },
                                child: Icon(Icons.location_on),
                                style: ButtonStyle(
                                  iconColor: MaterialStatePropertyAll(
                                    Color.fromRGBO(255, 255, 255, 1),
                                  ),
                                ),
                              ),
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 9, 73, 146),
                                shape: BoxShape.circle,
                              ),
                            ),
                            Container(
                              width: 50,
                              height: 50,
                              child: TextButton(
                                onPressed: () {
                                  SystemChrome.setEnabledSystemUIMode(
                                      SystemUiMode.immersive,);
                                },
                                child: Icon(Icons.fullscreen_sharp),
                                style: ButtonStyle(
                                  iconColor: MaterialStatePropertyAll(
                                    Color.fromRGBO(255, 255, 255, 1),
                                  ),
                                ),
                              ),
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 218, 141, 0),
                                shape: BoxShape.circle,
                              ),
                            ),
                            Container(
                              width: 50,
                              height: 50,
                              child: TextButton(
                                onPressed: () {
                                  Provider.of<ModoNocturnoProvider>(context,
                                          listen: false)
                                      .toggleModoNocturno();
                                },
                                child: Icon(Icons.nightlight_round),
                                style: ButtonStyle(
                                  iconColor: MaterialStateProperty.all(
                                    Color.fromRGBO(255, 255, 255, 1),
                                  ),
                                ),
                              ),
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 9, 73, 146),
                                shape: BoxShape.circle,
                              ),
                            ),
                            Container(
                              width: 50,
                              height: 50,
                              child: TextButton(
                                onPressed: () {
                                  _navigateToProfile(context);
                                },
                                child: Icon(Icons.settings),
                                style: ButtonStyle(
                                  iconColor: MaterialStatePropertyAll(
                                    Color.fromRGBO(255, 255, 255, 1),
                                  ),
                                ),
                              ),
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 255, 174, 0),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: Provider.of<ModoNocturnoProvider>(context)
                                .modoNocturno
                            ? [
                                Color.fromARGB(255, 49, 49, 49),
                                Color.fromARGB(255, 36, 36, 36)
                              ]
                            : [
                                const Color.fromARGB(255, 255, 136, 0),
                                Color.fromARGB(255, 177, 12, 0)
                              ],
                        stops: [0.1, 0.8],
                        begin: FractionalOffset.topCenter,
                        end: FractionalOffset.bottomCenter),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Provider.of<ModoNocturnoProvider>(context)
                                .modoNocturno
                            ? const Color.fromARGB(255, 22, 22, 22)
                                .withOpacity(0.1)
                            : Color.fromARGB(255, 22, 22, 22).withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: 20,
                    right: 20,
                  ),
                  child: Container(
                    padding: EdgeInsets.only(
                      left: 8,
                      right: 8,
                    ),
                    width: double.infinity,
                    height: 422.5,
                    decoration: BoxDecoration(
                      color: Provider.of<ModoNocturnoProvider>(context)
                              .modoNocturno
                          ? Color.fromARGB(255, 48, 48, 48)
                          : Color.fromARGB(255, 216, 216, 216),
                      borderRadius: BorderRadius.circular(23),
                      boxShadow: [
                        BoxShadow(
                          color: Provider.of<ModoNocturnoProvider>(context)
                                  .modoNocturno
                              ? const Color.fromARGB(255, 22, 22, 22)
                                  .withOpacity(0.1)
                              : Color.fromARGB(255, 22, 22, 22)
                                  .withOpacity(0.4),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Text("Control De Usuarios y Almacenes",
                            style: TextStyle(
                              fontSize: 18.0,
                              color: Provider.of<ModoNocturnoProvider>(context)
                                      .modoNocturno
                                  ? Color.fromARGB(255, 255, 255, 255)
                                  : Color.fromARGB(255, 37, 37, 37),
                              fontWeight: FontWeight.bold,
                            )),
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              GestureDetector(
                                onTapDown: (_) {
                                  setState(() {
                                    isPressedGalpon = true;
                                  });
                                },
                                onTapUp: (_) {
                                  setState(() {
                                    isPressedGalpon = false;
                                  });
                                  Navigator.pushNamed(context, 'sheds');
                                },
                                onTapCancel: () {
                                  setState(() {
                                    isPressedGalpon = false;
                                  });
                                },
                                child: Container(
                                  width: 140,
                                  height: 140,
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 3, 107, 121),
                                    borderRadius: BorderRadius.circular(20),
                                    image: DecorationImage(
                                      image:
                                          AssetImage("assets/galponPanel.png"),
                                      alignment: Alignment.topCenter,
                                      fit: BoxFit.scaleDown,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color.fromARGB(
                                                255, 22, 22, 22)
                                            .withOpacity(0.5),
                                        spreadRadius: 2,
                                        blurRadius: 7,
                                        offset: Offset(0, 1),
                                      ),
                                    ],
                                  ),
                                  child: Container(
                                    child: Center(
                                      child: Text(
                                        "Galpones",
                                        style: TextStyle(
                                          fontSize: 22.5,
                                          fontWeight: FontWeight.bold,
                                          color: Color.fromARGB(
                                              255, 255, 255, 255),
                                        ),
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: isPressedGalpon
                                          ? Color.fromARGB(175, 0, 41, 51)
                                          : Color.fromARGB(143, 1, 63, 82),
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTapDown: (_) {
                                  setState(() {
                                    isPressedProduccion = true;
                                  });
                                },
                                onTapUp: (_) {
                                  setState(() {
                                    isPressedProduccion = false;
                                  });
                                  Navigator.pushNamed(context, 'produccion');
                                },
                                onTapCancel: () {
                                  setState(() {
                                    isPressedProduccion = false;
                                  });
                                },
                                child: Container(
                                  width: 140,
                                  height: 140,
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 3, 107, 121),
                                    borderRadius: BorderRadius.circular(20),
                                    image: DecorationImage(
                                      image:
                                          AssetImage("assets/panelPerson.png"),
                                      alignment: Alignment.topCenter,
                                      fit: BoxFit.fitWidth,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color.fromARGB(
                                                255, 22, 22, 22)
                                            .withOpacity(0.5),
                                        spreadRadius: 2,
                                        blurRadius: 7,
                                        offset: Offset(0, 1),
                                      ),
                                    ],
                                  ),
                                  child: Container(
                                    child: Center(
                                      child: Text(
                                        "Produccion",
                                        style: TextStyle(
                                          fontSize: 22.5,
                                          fontWeight: FontWeight.bold,
                                          color: Color.fromARGB(
                                              255, 255, 255, 255),
                                        ),
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: isPressedProduccion
                                          ? Color.fromARGB(176, 0, 20, 51)
                                          : Color.fromARGB(143, 1, 43, 82),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              GestureDetector(
                                onTapDown: (_) {
                                  setState(() {
                                    isPressed = true;
                                  });
                                },
                                onTapUp: (_) {
                                  setState(() {
                                    isPressed = false;
                                  });
                                  Navigator.pushNamed(context, 'person');
                                },
                                onTapCancel: () {
                                  setState(() {
                                    isPressed = false;
                                  });
                                },
                                child: Container(
                                  width: 140,
                                  height: 140,
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 3, 107, 121),
                                    borderRadius: BorderRadius.circular(20),
                                    image: DecorationImage(
                                      image:
                                          AssetImage("assets/panelPerson.png"),
                                      alignment: Alignment.topCenter,
                                      fit: BoxFit.fitWidth,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color.fromARGB(
                                                255, 22, 22, 22)
                                            .withOpacity(0.5),
                                        spreadRadius: 2,
                                        blurRadius: 7,
                                        offset: Offset(0, 1),
                                      ),
                                    ],
                                  ),
                                  child: Container(
                                    child: Center(
                                      child: Text(
                                        "Personas",
                                        style: TextStyle(
                                          fontSize: 22.5,
                                          fontWeight: FontWeight.bold,
                                          color: Color.fromARGB(
                                              255, 255, 255, 255),
                                        ),
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: isPressed
                                          ? Color.fromARGB(176, 0, 20, 51)
                                          : Color.fromARGB(143, 1, 43, 82),
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTapDown: (_) {
                                  setState(() {
                                    isPressedAsignacion = true;
                                  });
                                },
                                onTapUp: (_) {
                                  setState(() {
                                    isPressedAsignacion = false;
                                  });
                                  Navigator.pushNamed(context, 'asignacion');
                                },
                                onTapCancel: () {
                                  setState(() {
                                    isPressedAsignacion = false;
                                  });
                                },
                                child: Container(
                                  width: 140,
                                  height: 140,
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 3, 107, 121),
                                    borderRadius: BorderRadius.circular(20),
                                    image: DecorationImage(
                                      image:
                                          AssetImage("assets/galponPanel.png"),
                                      alignment: Alignment.topCenter,
                                      fit: BoxFit.scaleDown,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color.fromARGB(
                                                255, 22, 22, 22)
                                            .withOpacity(0.5),
                                        spreadRadius: 2,
                                        blurRadius: 7,
                                        offset: Offset(0, 1),
                                      ),
                                    ],
                                  ),
                                  child: Container(
                                    child: Center(
                                      child: Text(
                                        "Asignacion",
                                        style: TextStyle(
                                          fontSize: 22.5,
                                          fontWeight: FontWeight.bold,
                                          color: Color.fromARGB(
                                              255, 255, 255, 255),
                                        ),
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: isPressedAsignacion
                                          ? Color.fromARGB(176, 0, 20, 51)
                                          : Color.fromARGB(143, 1, 43, 82),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
