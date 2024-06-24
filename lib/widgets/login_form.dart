import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:myapp/pages/profile_screen.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;

  Future<void> _signIn(String email, String password) async {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cargando ....')),
      );
      final response = await http.get(
        Uri.parse('https://glorious-eureka-97qjr547vg4vf996w-8080.app.github.dev/oraclecloud/persona/'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> personas = json.decode(response.body);
        var personaLogueada;

        for (var persona in personas) {
          if (persona['email'] == email && persona['password'] == password) {
            personaLogueada = persona;
            break;
          }
        }
        if (personaLogueada != null) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setInt('userId', personaLogueada['id']);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProfileScreen(personaLogueada['id']),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Credenciales incorrectas')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al obtener datos')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error de conexión')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.only(left: 25, right: 25, top: 10, bottom: 150),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(45),
            topRight: Radius.circular(45),
          ),
          color: Color.fromARGB(255, 255, 255, 255),
        ),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: "CORREO ELECTRONICO",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(22.0)),
                ),
              ),
            ),
            SizedBox(height: 28),
            Container(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: "CONTRASEÑA",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(22.0),
                            bottomLeft: Radius.circular(22.0),
                          ),
                        ),
                      ),
                      obscureText: _obscureText,
                    ),
                  ),
                  Container(
                    height: 63.7,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 104, 104, 104),
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(22.0),
                        bottomRight: Radius.circular(22.0),
                      ),
                    ),
                    child: TextButton(
                      style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all<Color>(
                          Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                      child: Icon(_obscureText
                          ? Icons.remove_red_eye
                          : Icons.remove_red_eye_outlined),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Stack(
                children: <Widget>[
                  Positioned.fill(
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: <Color>[
                            Color.fromARGB(255, 85, 5, 138),
                            Color.fromARGB(255, 123, 63, 163),
                            Color.fromARGB(255, 140, 88, 170),
                          ],
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.all(15),
                      textStyle: const TextStyle(fontSize: 23),
                    ),
                    onPressed: () {
                      _signIn(
                        _emailController.text,
                        _passwordController.text,
                      );
                    },
                    child: const Text('          Ingresar          '),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
