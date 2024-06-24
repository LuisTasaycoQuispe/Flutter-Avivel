import 'package:myapp/widgets/circle.dart';
import 'package:myapp/widgets/icon_container.dart';
import 'package:flutter/material.dart';
import 'package:myapp/widgets/login_form.dart';

class HomePages extends StatefulWidget {
  @override
  _HomePagesState createState() => _HomePagesState();
}

class _HomePagesState extends State<HomePages> {
  @override
  Widget build(BuildContext context) {
    //PARTE REPONSIVE
    final Size size = MediaQuery.of(context).size;

    //Estos serian como Variables
    //final double pinkSize = size.width *0.8;
    //final double pinkSize = size.width *0.8;

    //Ejemplo de como hacer el reponsive
    //top: -(size.width*08)*0.5,
    // left : -(size.width*08)*0.5,
    // size: size.width * 0.8

    //FINAL REPONSIVE

    return Scaffold(
        body: GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          height: 800,
          color: Colors.white,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Positioned(
                  //Si queremos otro circulo Compiamos el Positioned y lo pegamos abajo solo
                  //cambiamos la ubicacion y asi :)
                  top: -(size.width * 0.8) * 0.35,
                  right: -(size.width * 0.8) * 0.3,
                  //por aqui podemos colocar algo de css

                  child: Circle(
                    key: UniqueKey(),
                    size: size.width *
                        0.85, //Aqui configuraremos el tamaño del circulo en el login
                    colors: [
                      Colors.pinkAccent,
                      const Color.fromARGB(255, 212, 20, 84),
                    ],
                  )),
              Positioned(
                //Si queremos otro circulo Compiamos el Positioned y lo pegamos abajo solo
                //cambiamos la ubicacion y asi :)
                top: -(size.width * 0.8) * 0.26,
                left: -(size.width * 0.8) * 0.1,
                //por aqui podemos colocar algo de css

                child: Circle(
                  key: UniqueKey(),
                  size: size.width *
                      0.6, //Aqui configuraremos el tamaño del circulo en el login
                  colors: [
                    Color.fromARGB(255, 216, 69, 11),
                    Color.fromARGB(255, 250, 140, 107),
                  ],
                ),
              ),
              Positioned(
                top: 150,
                child: Column(
                  children: [
                    IconContainer(),
                    Text(
                      "\nHola\nBienvenido",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20), //tamaño de la letra
                    ),
                    SizedBox(
                      height: 0,
                    )
                  ],
                ),
              ),
              LoginForm(),
              Positioned(
                top: 670,
                child: Column(
                  children: [
                    Text(
                      "Solo Personal Autorizado",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 15),
                    ),
                    SizedBox(
                      height: 0,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
