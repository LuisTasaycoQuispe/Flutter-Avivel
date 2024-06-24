import 'package:myapp/widgets/all_containerAsignacion.dart';
import 'package:myapp/widgets/oscuro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class AsignacionPages extends StatefulWidget {
  @override
  _AsignacionPagesState createState() => _AsignacionPagesState();
}

class _AsignacionPagesState extends State<AsignacionPages> {
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Provider.of<ModoNocturnoProvider>(context).modoNocturno
              ? Color.fromARGB(255, 24, 24, 24)
              : Color.fromARGB(255, 255, 255, 255),
        ),
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.only(
                right: 0,
                left: 0,
                top: 0,
              ),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(
                      right: 20,
                      left: 20,
                      top: 15,
                    ),
                    width: double.infinity,
                    height: 115,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(25),
                        bottomRight: Radius.circular(25),
                      ),
                      gradient: LinearGradient(
                        colors: Provider.of<ModoNocturnoProvider>(context)
                                .modoNocturno
                            ? [
                                Color.fromARGB(255, 48, 48, 48),
                                Color.fromARGB(255, 48, 48, 48)
                              ]
                            : [
                                Color.fromARGB(255, 247, 140, 0),
                                Color.fromARGB(255, 201, 49, 11)
                              ],
                        begin: Alignment.topRight,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Column(
                            children: [
                              Text(
                                "Galpones Asignados",
                                style: TextStyle(
                                    fontSize: 25.0,
                                    color: Color(0xFFFFFFFF),
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Text(
                                "Control de Galpones asignados por dia",
                                style: TextStyle(
                                    fontSize: 15.0,
                                    color: Color(0xFFFFFFFF),
                                    fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 40,
                        ),
                        Container(
                          child: Image(image: AssetImage("assets/shedCas.png")),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            AsignacionListarActivos(searchController: searchController,),
          ],
        ),
      ),
    );
  }
}
