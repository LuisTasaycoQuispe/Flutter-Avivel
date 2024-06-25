import 'dart:convert';
import 'package:myapp/model/Persona.dart';
import 'package:myapp/widgets/oscuro.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

//En este archivo dart podremos crear nuevo contendores

// Contenedor 1 AllContainers
//Este contenedor contiene un form para registrars
class AllContainers extends StatelessWidget {
  final names = TextEditingController();
  final last_names = TextEditingController();
  final document_type = TextEditingController();
  final document_number = TextEditingController();
  final cellphone_number = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(
          top: 20.0,
          bottom: 100,
        ),
        child: Center(
          child: _basic(context),
        ),
      ),
    );
  }

  Widget _basic(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.only(
            top: 30,
            left: 20,
            right: 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: TextFormField(
                    controller: names,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Nombres",
                      suffixIcon: Icon(Icons.person),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: TextFormField(
                    controller: last_names,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Apellidos",
                      suffixIcon: Icon(Icons.person),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        child: TextField(
                          controller: document_type,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Tipo de Documento",
                            suffixIcon: Icon(Icons.document_scanner_rounded),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        child: TextField(
                          controller: document_number,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Numero Documento",
                            suffixIcon: Icon(Icons.numbers),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: TextField(
                    controller: cellphone_number,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Celular",
                        suffixIcon: Icon(Icons.numbers)),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: TextField(
                    controller: email,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Email",
                        suffixIcon: Icon(Icons.email_rounded)),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: TextField(
                    controller: password,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Contraseña",
                        suffixIcon: Icon(Icons.password_rounded)),
                  ),
                ),
                SizedBox(height: 5),
                ElevatedButton(
                  onPressed: () {
                    savePersona(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 243, 17, 92),
                  ),
                  child: const Text(
                    "REGISTRAR",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 250, 250, 250),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(45),
          topRight: Radius.circular(45),
        ),
      ),
    );
  }

  void savePersona(BuildContext context) async {
    final user = {
      "names": names.text,
      "last_names": last_names.text,
      "document_type": document_type.text,
      "document_number": document_number.text,
      "cellphone_number": cellphone_number.text,
      "email": email.text,
      "password": password.text,
    };
    final headers = {"Content-type": "application/json; charset=UTF-8"};
    final res = await http.post(
      Uri.parse('https://orange-cod-qrww6qwwr6wh445w-8080.app.github.dev/oraclecloud/persona/create'),
      headers: headers,
      body: jsonEncode(user),
    );

    names.clear();
    last_names.clear();
    document_type.clear();
    document_number.clear();
    cellphone_number.clear();
    email.clear();
    password.clear();
  }
}

Future<List<Persona>> fetchPerson() async {
  final response = await http.get(
      Uri.parse('https://glorious-eureka-97qjr547vg4vf996w-8080.app.github.dev/oraclecloud/persona/activos'));

  if (response.statusCode == 200) {
    List<dynamic> data = jsonDecode(response.body);
    List<Persona> persona = data.map((json) => Persona.fromJson(json)).toList();
    return persona;
  } else {
    throw Exception("Problemas con la API");
  }
}

class PersonaListarActivos extends StatefulWidget {
  final TextEditingController searchController;

  const PersonaListarActivos({Key? key, required this.searchController})
      : super(key: key);

  @override
  _PersonaListarActivosState createState() => _PersonaListarActivosState();
}

class _PersonaListarActivosState extends State<PersonaListarActivos> {
  List<Persona> personas = [];
  List<Persona> personaFiltrados = [];
  int? _selectedCardIndex;

  @override
  void initState() {
    super.initState();
    cargarPersonas();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(
          top: 15.0,
          left: 15,
          right: 15,
          bottom: 90,
        ),
        child: Column(
          children: [
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: Container(
                  padding:
                      EdgeInsets.only(top: 12, left: 12, right: 12, bottom: 12),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color:
                        Provider.of<ModoNocturnoProvider>(context).modoNocturno
                            ? Color.fromARGB(255, 61, 61, 61)
                            : Color.fromARGB(255, 236, 236, 236),
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  child: Column(children: [
                    TextField(
                      controller: widget.searchController,
                      onChanged: (value) {
                        buscarPersona(value);
                      },
                      decoration: InputDecoration(
                        hoverColor: Color.fromARGB(249, 255, 184, 137),
                        hintFadeDuration: Durations.long1,
                        contentPadding: EdgeInsets.all(8),
                        filled: true,
                        fillColor: const Color.fromARGB(255, 255, 255, 255),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 1.5,
                              color: Color.fromARGB(255, 255, 115, 0)),
                          borderRadius: BorderRadius.all(
                            Radius.circular(16.0),
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(16.0),
                          ),
                        ),
                        suffixIcon: Icon(
                          Icons.search_rounded,
                          size: 34.0,
                        ),
                        hintText: "Buscar",
                      ),
                    ),
                  ]),
                )),
            SizedBox(height: 20),
            _basic(),
          ],
        ),
      ),
    );
  }

  Widget _basic() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: personaFiltrados.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedCardIndex = index == _selectedCardIndex ? null : index;
            });
          },
          child: Container(
            margin: EdgeInsets.only(bottom: 18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Provider.of<ModoNocturnoProvider>(context).modoNocturno
                  ? Color.fromARGB(255, 41, 41, 41)
                  : const Color.fromARGB(255, 236, 236, 236),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  SizedBox(width: 7),
                  Container(
                    alignment: Alignment.center,
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.fromARGB(255, 216, 86, 0),
                    ),
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                  SizedBox(width: 2),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          // title: Text(
                          //   "ID: ${galponesFiltrados[index].id}",
                          //   style: TextStyle(
                          //     color: Provider.of<ModoNocturnoProvider>(context)
                          //             .modoNocturno
                          //         ? Colors.white
                          //         : Colors.black,
                          //   ),
                          // ),
                          subtitle: Text(
                            "Nombre: ${personaFiltrados[index].names}\nApellido: ${personaFiltrados[index].last_names}\nN° Documento: ${personaFiltrados[index].document_number}",
                            style: TextStyle(
                              color: Provider.of<ModoNocturnoProvider>(context)
                                      .modoNocturno
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                          trailing: PopupMenuButton<String>(
                            onSelected: (String choice) {
                              if (choice == 'Editar') {
                                _mostrarFormularioEdicion(
                                    personaFiltrados[index]);
                              } else if (choice == 'Eliminar') {
                                _confirmarEliminacion(
                                    personaFiltrados[index].id);
                              }
                            },
                            itemBuilder: (BuildContext context) {
                              return {'Eliminar', 'Editar'}
                                  .map((String choice) {
                                return PopupMenuItem<String>(
                                  value: choice,
                                  child: Text(choice),
                                );
                              }).toList();
                            },
                          ),
                        ),
                        if (_selectedCardIndex == index) ...[
                          Text(
                            "    Tipo Documento: ${personaFiltrados[index].document_type}",
                            style: TextStyle(
                              color: Provider.of<ModoNocturnoProvider>(context)
                                      .modoNocturno
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                          Text(
                            "    Celular: ${personaFiltrados[index].cellphone_number}",
                            style: TextStyle(
                              color: Provider.of<ModoNocturnoProvider>(context)
                                      .modoNocturno
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                          Text(
                            "    Correo \n    ${personaFiltrados[index].email}",
                            style: TextStyle(
                              color: Provider.of<ModoNocturnoProvider>(context)
                                      .modoNocturno
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void cargarPersonas() async {
    final response = await http.get(
        Uri.parse('https://glorious-eureka-97qjr547vg4vf996w-8080.app.github.dev/oraclecloud/persona/activos'));

    if (response.statusCode == 200) {
      setState(() {
        personas = (jsonDecode(response.body) as List)
            .map((json) => Persona.fromJson(json))
            .toList();
        personaFiltrados = List.from(personas);
      });
    } else {
      throw Exception("Problemas con la API");
    }
  }

  void buscarPersona(String query) {
    setState(() {
      personaFiltrados = personas.where((galpon) {
        final nameLower = galpon.names.toLowerCase();
        final queryLower = query.toLowerCase();
        return nameLower.contains(queryLower);
      }).toList();
    });
  }

  void eliminarPersona(String id) async {
    final response = await http.put(Uri.parse(
        'https://glorious-eureka-97qjr547vg4vf996w-8080.app.github.dev/oraclecloud/persona/$id/inactive'));
    if (response.statusCode == 200) {
      setState(() {
        personas.removeWhere((persona) => persona.id == id);
      });
      print("Eliminado exitoso person con id: $id");
    } else {
      print("Error al eliminar person con id: $id");
    }
  }

  void _confirmarEliminacion(String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Provider.of<ModoNocturnoProvider>(context).modoNocturno
                  ? Color.fromARGB(255, 49, 49, 49)
                  : const Color.fromARGB(255, 223, 223, 223),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Confirmar Eliminacion',
                  style: TextStyle(
                    color:
                        Provider.of<ModoNocturnoProvider>(context).modoNocturno
                            ? Colors.white
                            : Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  '¿Esta seguro que quiere eliminar este galpon?',
                  style: TextStyle(
                    color:
                        Provider.of<ModoNocturnoProvider>(context).modoNocturno
                            ? Colors.white
                            : Colors.black,
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(
                            Color.fromARGB(255, 255, 115, 0)),
                      ),
                      child: Text(
                        'Cancelar',
                        style: TextStyle(
                          color: Provider.of<ModoNocturnoProvider>(context)
                                  .modoNocturno
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(
                            Color.fromARGB(255, 255, 115, 0)),
                      ),
                      child: Text(
                        'Eliminar',
                        style: TextStyle(
                          color: Provider.of<ModoNocturnoProvider>(context)
                                  .modoNocturno
                              ? const Color.fromARGB(255, 255, 255, 255)
                              : Colors.black,
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        eliminarPersona(id);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void editarPersona(Persona person) async {
    final response = await http.put(
      Uri.parse(
          'https://glorious-eureka-97qjr547vg4vf996w-8080.app.github.dev/oraclecloud/persona/update/${person.id}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(person.toJson()),
    );
    if (response.statusCode == 200) {
      print('Persona actualizada con éxito');
      cargarPersonas();
    } else {
      print('Error al actualizar la persona: ${response.statusCode}');
    }
  }

  void _mostrarFormularioEdicion(Persona person) {
    TextEditingController nombreController =
        TextEditingController(text: person.names);
    TextEditingController apellidosController =
        TextEditingController(text: person.last_names);
    TextEditingController documentnumberController =
        TextEditingController(text: person.document_number);

    TextEditingController documentypeController =
        TextEditingController(text: person.document_type);

    TextEditingController celularController =
        TextEditingController(text: person.cellphone_number);

    TextEditingController emailController =
        TextEditingController(text: person.email);

    TextEditingController passwordController =
        TextEditingController(text: person.password);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, setState) {
            return AlertDialog(
              title: Text(
                "Editar Persona",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              insetPadding: EdgeInsets.all(9.0),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 20),
                    TextFormField(
                      controller: nombreController,
                      decoration: InputDecoration(
                        labelText: 'Nombres',
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                        isDense: true,
                        labelStyle: TextStyle(fontSize: 14),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: apellidosController,
                      decoration: InputDecoration(
                        labelText: 'Apellidos',
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                        isDense: true,
                        labelStyle: TextStyle(fontSize: 14),
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: documentypeController,
                            decoration: InputDecoration(
                              labelText: 'Tipo Documento',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 10),
                              isDense: true,
                              labelStyle: TextStyle(fontSize: 14),
                            ),
                          ),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: TextFormField(
                            controller: documentnumberController,
                            decoration: InputDecoration(
                              labelText: 'Número Documento',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 10),
                              isDense: true,
                              labelStyle: TextStyle(fontSize: 14),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: celularController,
                      decoration: InputDecoration(
                        labelText: 'Celular',
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                        isDense: true,
                        labelStyle: TextStyle(fontSize: 14),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                        isDense: true,
                        labelStyle: TextStyle(fontSize: 14),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        labelText: 'Contraseña',
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                        isDense: true,
                        labelStyle: TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () {
                    String nombres = nombreController.text;
                    String apellidos = apellidosController.text;
                    String tipoDocumento = documentypeController.text;
                    String numeroDocumento = documentnumberController.text;
                    String celular = celularController.text;
                    String email = emailController.text;
                    String password = passwordController.text;

                    Persona personaActualizada = Persona(
                      id: person.id,
                      names: nombres,
                      last_names: apellidos,
                      document_number: numeroDocumento,
                      document_type: tipoDocumento,
                      cellphone_number: celular,
                      email: email,
                      password: password,
                      state: 'A',
                    );

                    editarPersona(personaActualizada);

                    Navigator.of(context).pop();
                  },
                  child: Text('Guardar'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

Future<List<Persona>> fetchPersonInac() async {
  final response = await http.get(
      Uri.parse('https://glorious-eureka-97qjr547vg4vf996w-8080.app.github.dev/oraclecloud/persona/inactivos'));

  if (response.statusCode == 200) {
    List<dynamic> data = jsonDecode(response.body);
    List<Persona> persona = data.map((json) => Persona.fromJson(json)).toList();
    return persona;
  } else {
    throw Exception("Problemas con la API");
  }
}

class PersonaListarInac extends StatefulWidget {
  final TextEditingController searchController;

  const PersonaListarInac({Key? key, required this.searchController})
      : super(key: key);

  @override
  _PersonaListarInacState createState() => _PersonaListarInacState();
}

class _PersonaListarInacState extends State<PersonaListarInac> {
  List<Persona> personas = [];
  List<Persona> personaFiltrados = [];
  int? _selectedCardIndex;

  @override
  void initState() {
    super.initState();
    cargarPersonasInac();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(
          top: 15.0,
          left: 15,
          right: 15,
          bottom: 90,
        ),
        child: Column(
          children: [
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: Container(
                  padding:
                      EdgeInsets.only(top: 12, left: 12, right: 12, bottom: 12),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color:
                        Provider.of<ModoNocturnoProvider>(context).modoNocturno
                            ? Color.fromARGB(255, 61, 61, 61)
                            : Color.fromARGB(255, 236, 236, 236),
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  child: Column(children: [
                    TextField(
                      controller: widget.searchController,
                      onChanged: (value) {
                        buscarPersona(value);
                      },
                      decoration: InputDecoration(
                        hoverColor: Color.fromARGB(249, 255, 184, 137),
                        hintFadeDuration: Durations.long1,
                        contentPadding: EdgeInsets.all(8),
                        filled: true,
                        fillColor: const Color.fromARGB(255, 255, 255, 255),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 1.5,
                              color: Color.fromARGB(255, 255, 115, 0)),
                          borderRadius: BorderRadius.all(
                            Radius.circular(16.0),
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(16.0),
                          ),
                        ),
                        suffixIcon: Icon(
                          Icons.search_rounded,
                          size: 34.0,
                        ),
                        hintText: "Buscar",
                      ),
                    ),
                  ]),
                )),
            SizedBox(height: 20),
            _basic(),
          ],
        ),
      ),
    );
  }

  Widget _basic() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: personaFiltrados.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedCardIndex = index == _selectedCardIndex ? null : index;
            });
          },
          child: Container(
            margin: EdgeInsets.only(bottom: 18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Provider.of<ModoNocturnoProvider>(context).modoNocturno
                  ? Color.fromARGB(255, 41, 41, 41)
                  : const Color.fromARGB(255, 236, 236, 236),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  SizedBox(width: 7),
                  Container(
                    alignment: Alignment.center,
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.fromARGB(255, 216, 86, 0),
                    ),
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                  SizedBox(width: 2),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          // title: Text(
                          //   "ID: ${galponesFiltrados[index].id}",
                          //   style: TextStyle(
                          //     color: Provider.of<ModoNocturnoProvider>(context)
                          //             .modoNocturno
                          //         ? Colors.white
                          //         : Colors.black,
                          //   ),
                          // ),
                          subtitle: Text(
                            "Nombre: ${personaFiltrados[index].names}\nApellido: ${personaFiltrados[index].last_names}\nN° Documento: ${personaFiltrados[index].document_number}",
                            style: TextStyle(
                              color: Provider.of<ModoNocturnoProvider>(context)
                                      .modoNocturno
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                        if (_selectedCardIndex == index) ...[
                          Text(
                            "    Tipo Documento: ${personaFiltrados[index].document_type}",
                            style: TextStyle(
                              color: Provider.of<ModoNocturnoProvider>(context)
                                      .modoNocturno
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                          Text(
                            "    Celular: ${personaFiltrados[index].cellphone_number}",
                            style: TextStyle(
                              color: Provider.of<ModoNocturnoProvider>(context)
                                      .modoNocturno
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                          Text(
                            "    Correo \n    ${personaFiltrados[index].email}",
                            style: TextStyle(
                              color: Provider.of<ModoNocturnoProvider>(context)
                                      .modoNocturno
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      _confirmarRestauracion(personaFiltrados[index].id);
                    },
                    child: Icon(Icons.restart_alt_outlined),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void cargarPersonasInac() async {
    final response = await http.get(
        Uri.parse('https://glorious-eureka-97qjr547vg4vf996w-8080.app.github.dev/oraclecloud/persona/inactivos'));

    if (response.statusCode == 200) {
      setState(() {
        personas = (jsonDecode(response.body) as List)
            .map((json) => Persona.fromJson(json))
            .toList();
        personaFiltrados = List.from(personas);
      });
    } else {
      throw Exception("Problemas con la API");
    }
  }

  void buscarPersona(String query) {
    setState(() {
      personaFiltrados = personas.where((galpon) {
        final nameLower = galpon.names.toLowerCase();
        final queryLower = query.toLowerCase();
        return nameLower.contains(queryLower);
      }).toList();
    });
  }

  void restaurarPersona(String id) async {
    final response = await http.put(Uri.parse(
        'https://glorious-eureka-97qjr547vg4vf996w-8080.app.github.dev/oraclecloud/persona/$id/restaurar'));
    if (response.statusCode == 200) {
      setState(() {
        personas.removeWhere((persona) => persona.id == id);
      });
      print("resturacion exitosa persona con id: $id ");
      cargarPersonasInac();
    } else {
      print("Error al resturar persona conn el id: $id ");
    }
  }

  void _confirmarRestauracion(String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Provider.of<ModoNocturnoProvider>(context).modoNocturno
                  ? Color.fromARGB(255, 49, 49, 49)
                  : const Color.fromARGB(255, 223, 223, 223),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Confirmar Restauración',
                  style: TextStyle(
                    color:
                        Provider.of<ModoNocturnoProvider>(context).modoNocturno
                            ? Colors.white
                            : Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  '¿Esta seguro que quiere restaurar esta persona?',
                  style: TextStyle(
                    color:
                        Provider.of<ModoNocturnoProvider>(context).modoNocturno
                            ? Colors.white
                            : Colors.black,
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(
                            Color.fromARGB(255, 255, 115, 0)),
                      ),
                      child: Text(
                        'Cancelar',
                        style: TextStyle(
                          color: Provider.of<ModoNocturnoProvider>(context)
                                  .modoNocturno
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(
                            Color.fromARGB(255, 255, 115, 0)),
                      ),
                      child: Text(
                        'Restaurar',
                        style: TextStyle(
                          color: Provider.of<ModoNocturnoProvider>(context)
                                  .modoNocturno
                              ? const Color.fromARGB(255, 255, 255, 255)
                              : Colors.black,
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        restaurarPersona(id);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class Container2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.only(top: 20.0),
      shrinkWrap: true,
      children: [
        Center(
          child: _basic(context),
        ),
      ],
    );
  }

  Widget _basic(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 700.0,
      child: Align(
        alignment: Alignment.topCenter,
        child: Text("hola Mundo"),
      ),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 250, 250, 250),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(45),
          topRight: Radius.circular(45),
        ),
      ),
    );
  }
}


//Podemos agregar mas contenedores si asi lo queremos
//en el persona_active.dart en la linea 53 estamos llamando al contenedor creado

//Nuestro dos contenedores son AllContiners y Container2 