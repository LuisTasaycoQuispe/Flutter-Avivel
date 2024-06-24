import 'package:myapp/widgets/all_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PersonRegisterPages extends StatefulWidget {
  const PersonRegisterPages({Key? key}) : super(key: key);

  @override
  _PersonRegisterPages createState() => _PersonRegisterPages();
}

class _PersonRegisterPages extends State<PersonRegisterPages> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/fondos1.png"),
            alignment: Alignment.topCenter,
            fit: BoxFit.fitWidth,
          ),
        ),
        child: ListView(
          children: [
            SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Registrar',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 236, 235, 235),
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text('Control Integral de Usuarios',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: const Color.fromARGB(255, 236, 235, 235),
                  )),
            ),

            //AQUIE ESTAMOS LLAMANDO AL CONTENEDOR

            // Container2(),
            AllContainers(),
          ],
        ),
      ),
    );
  }
}
