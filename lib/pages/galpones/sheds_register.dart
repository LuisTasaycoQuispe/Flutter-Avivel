import 'package:myapp/widgets/all_containerSheds.dart';
import 'package:myapp/widgets/oscuro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class ShedsRegisterPages extends StatefulWidget {
  const ShedsRegisterPages({Key? key}) : super(key: key);

  @override
  _ShedsRegisterPages createState() => _ShedsRegisterPages();
}

class _ShedsRegisterPages extends State<ShedsRegisterPages> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Provider.of<ModoNocturnoProvider>(context).modoNocturno
              ? Color.fromARGB(255, 17, 17, 17)
              : Colors.white,
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
                                const Color.fromARGB(221, 49, 49, 49),
                                const Color.fromARGB(221, 49, 49, 49)
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
                                "Registrar Galpon",
                                style: TextStyle(
                                    fontSize: 25.0,
                                    color: Color(0xFFFFFFFF),
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Text(
                                "Seccion de Registrar galpon",
                                style: TextStyle(
                                    fontSize: 15.0,
                                    color: Color(0xFFFFFFFF),
                                    fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container3(),
          ],
        ),
      ),
    );
  }
}
