import 'package:myapp/widgets/oscuro.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  final int userId;

  ProfileScreen(this.userId);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? userProfile;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int? userId = prefs.getInt('userId');

      if (userId == null) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No se encontró el ID del usuario')),
        );
        return;
      }

      final response = await http.get(
        Uri.parse('https://glorious-eureka-97qjr547vg4vf996w-8080.app.github.dev/oraclecloud/persona/$userId'),
      );

      if (response.statusCode == 200) {
        setState(() {
          userProfile = json.decode(response.body);
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al obtener datos del perfil')),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error de conexión')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        backgroundColor: Provider.of<ModoNocturnoProvider>(context).modoNocturno
            ? const Color.fromARGB(221, 17, 17, 17)
            : Colors.white,
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else if (userProfile == null) {
      return Scaffold(
        backgroundColor: Provider.of<ModoNocturnoProvider>(context).modoNocturno
            ? const Color.fromARGB(221, 17, 17, 17)
            : Colors.white,
        body: Center(
          child: Text('No se encontraron datos del perfil.'),
        ),
      );
    } else {
      return Scaffold(
        backgroundColor: Provider.of<ModoNocturnoProvider>(context).modoNocturno
            ? const Color.fromARGB(221, 17, 17, 17)
            : Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(16),
                    width: double.infinity,
                    height: 140,
                    decoration: BoxDecoration(
                        color: Provider.of<ModoNocturnoProvider>(context)
                                .modoNocturno
                            ? const Color.fromARGB(221, 49, 49, 49)
                            : Color.fromARGB(221, 226, 72, 0),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(23),
                          bottomRight: Radius.circular(23),
                        )),
                    child: Row(
                      children: [
                        Container(
                          width: 65,
                          height: 65,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("assets/personaicono.png"),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 6,
                        ),
                        Container(
                          padding: EdgeInsets.only(
                            left: 20,
                            top: 20,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${userProfile!['names']}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.5,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                '${userProfile!['email']}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 20),
                        Container(
                            height: 90,
                            child: Column(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context, 'panel');
                                  },
                                  icon: Icon(
                                    Icons.filter_b_and_w_outlined,
                                    color: Color(0xFFFFFFFF),
                                  ),
                                ),
                              ],
                            )),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, 'home');
                              },
                              child: Container(
                                padding: EdgeInsets.only(
                                  right: 10,
                                  left: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: Provider.of<ModoNocturnoProvider>(
                                              context)
                                          .modoNocturno
                                      ? const Color.fromARGB(221, 49, 49, 49)
                                      : Color.fromARGB(255, 219, 219, 219),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                ),
                                width: 155,
                                height: 50,
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.logout,
                                      color: Provider.of<ModoNocturnoProvider>(
                                                  context)
                                              .modoNocturno
                                          ? Colors.white
                                          : Colors.black87,
                                    ),
                                    Text(
                                      "  Cerrar sesión ",
                                      style: TextStyle(
                                        color:
                                            Provider.of<ModoNocturnoProvider>(
                                                        context)
                                                    .modoNocturno
                                                ? Colors.white
                                                : Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: 20),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, 'panel');
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Provider.of<ModoNocturnoProvider>(
                                              context)
                                          .modoNocturno
                                      ? const Color.fromARGB(221, 49, 49, 49)
                                      : Color.fromARGB(255, 219, 219, 219),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                ),
                                padding: EdgeInsets.only(
                                  right: 20,
                                  left: 20,
                                ),
                                width: 155,
                                height: 50,
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.person,
                                      color: Provider.of<ModoNocturnoProvider>(
                                                  context)
                                              .modoNocturno
                                          ? Colors.white
                                          : Colors.black87,
                                    ),
                                    Text(
                                      "    Panel",
                                      style: TextStyle(
                                        color:
                                            Provider.of<ModoNocturnoProvider>(
                                                        context)
                                                    .modoNocturno
                                                ? Colors.white
                                                : Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 14.5),
                        Container(
                          padding: EdgeInsets.only(
                            right: 2,
                            left: 2,
                          ),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, 'panel');
                            },
                            child: Container(
                              padding: EdgeInsets.only(
                                right: 20,
                                left: 20,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    Provider.of<ModoNocturnoProvider>(context)
                                            .modoNocturno
                                        ? const Color.fromARGB(221, 49, 49, 49)
                                        : Color.fromARGB(255, 219, 219, 219),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                              ),
                              width: double.infinity,
                              height: 50,
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.key,
                                    color: Provider.of<ModoNocturnoProvider>(
                                                context)
                                            .modoNocturno
                                        ? Colors.white
                                        : Colors.black87,
                                  ),
                                  Text(
                                    "   Cambiar Contraseña",
                                    style: TextStyle(
                                      color: Provider.of<ModoNocturnoProvider>(
                                                  context)
                                              .modoNocturno
                                          ? Colors.white
                                          : Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 14.5),
                        Container(
                          padding: EdgeInsets.only(
                            right: 2,
                            left: 2,
                          ),
                          child: Container(
                            padding: EdgeInsets.only(
                              right: 20,
                              left: 20,
                            ),
                            width: double.infinity,
                            height: 40,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.person,
                                  color:
                                      Provider.of<ModoNocturnoProvider>(context)
                                              .modoNocturno
                                          ? Colors.white
                                          : Colors.black87,
                                ),
                                Text(
                                  "  Datos:  ${userProfile!['names']}",
                                  style: TextStyle(
                                    color: Provider.of<ModoNocturnoProvider>(
                                                context)
                                            .modoNocturno
                                        ? Colors.white
                                        : Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                            decoration: BoxDecoration(
                              color: Provider.of<ModoNocturnoProvider>(context)
                                      .modoNocturno
                                  ? const Color.fromARGB(221, 49, 49, 49)
                                  : Color.fromARGB(255, 219, 219, 219),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8),
                                topRight: Radius.circular(8),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(
                            right: 2,
                            left: 2,
                          ),
                          child: Container(
                            padding: EdgeInsets.only(
                              right: 20,
                              left: 20,
                              top: 20,
                              bottom: 20,
                            ),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(8),
                                  bottomRight: Radius.circular(8)),
                              color: Provider.of<ModoNocturnoProvider>(context)
                                      .modoNocturno
                                  ? Color.fromARGB(221, 73, 73, 73)
                                  : Color.fromARGB(255, 231, 231, 231),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Nombre: ${userProfile!['names']}',
                                  style: TextStyle(
                                    color: Provider.of<ModoNocturnoProvider>(
                                                context)
                                            .modoNocturno
                                        ? Colors.white
                                        : Colors.black87,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'Correo: ${userProfile!['email']}',
                                  style: TextStyle(
                                    color: Provider.of<ModoNocturnoProvider>(
                                                context)
                                            .modoNocturno
                                        ? Colors.white
                                        : Colors.black87,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'Apellidos: ${userProfile!['last_names']}',
                                  style: TextStyle(
                                    color: Provider.of<ModoNocturnoProvider>(
                                                context)
                                            .modoNocturno
                                        ? Colors.white
                                        : Colors.black87,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'Celular: ${userProfile!['cellphone_number']}',
                                  style: TextStyle(
                                    color: Provider.of<ModoNocturnoProvider>(
                                                context)
                                            .modoNocturno
                                        ? Colors.white
                                        : Colors.black87,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'Tipo Documento: ${userProfile!['document_type']}',
                                  style: TextStyle(
                                    color: Provider.of<ModoNocturnoProvider>(
                                                context)
                                            .modoNocturno
                                        ? Colors.white
                                        : Colors.black87,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'Numero Documento: ${userProfile!['document_number']}',
                                  style: TextStyle(
                                    color: Provider.of<ModoNocturnoProvider>(
                                                context)
                                            .modoNocturno
                                        ? Colors.white
                                        : Colors.black87,
                                  ),
                                ),
                                SizedBox(height: 10),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 14.5),
                        Container(
                          padding: EdgeInsets.only(
                            right: 2,
                            left: 2,
                          ),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, 'panel');
                            },
                            child: Container(
                              padding: EdgeInsets.only(
                                right: 20,
                                left: 20,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    Provider.of<ModoNocturnoProvider>(context)
                                            .modoNocturno
                                        ? const Color.fromARGB(221, 49, 49, 49)
                                        : Color.fromARGB(255, 219, 219, 219),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                              ),
                              width: double.infinity,
                              height: 50,
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.fullscreen,
                                    color: Provider.of<ModoNocturnoProvider>(
                                                context)
                                            .modoNocturno
                                        ? Colors.white
                                        : Colors.black87,
                                  ),
                                  Text(
                                    "   Pantalla Completa",
                                    style: TextStyle(
                                      color: Provider.of<ModoNocturnoProvider>(
                                                  context)
                                              .modoNocturno
                                          ? Colors.white
                                          : Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 14.5),
                        Container(
                          padding: EdgeInsets.only(
                            right: 2,
                            left: 2,
                          ),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, 'panel');
                            },
                            child: Container(
                              padding: EdgeInsets.only(
                                right: 20,
                                left: 20,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    Provider.of<ModoNocturnoProvider>(context)
                                            .modoNocturno
                                        ? const Color.fromARGB(221, 49, 49, 49)
                                        : Color.fromARGB(255, 219, 219, 219),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                              ),
                              width: double.infinity,
                              height: 50,
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.location_on_sharp,
                                    color: Provider.of<ModoNocturnoProvider>(
                                                context)
                                            .modoNocturno
                                        ? Colors.white
                                        : Colors.black87,
                                  ),
                                  Text(
                                    "   Google Maps",
                                    style: TextStyle(
                                      color: Provider.of<ModoNocturnoProvider>(
                                                  context)
                                              .modoNocturno
                                          ? Colors.white
                                          : Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25),
                      ),
                      color: Provider.of<ModoNocturnoProvider>(context)
                              .modoNocturno
                          ? Color.fromARGB(221, 73, 73, 73)
                          : Color.fromARGB(255, 231, 231, 231),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }
}
