import 'dart:convert';
import 'dart:ui';
import 'package:myapp/model/Galpones.dart';
import 'package:myapp/widgets/oscuro.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
// CONTENDOR PRUEBA PARA LISTAR GALPONES INACTIVOS
Future<List<Galpones>> fetchGalpon() async {
  final response = await http.get(
      Uri.parse('https://orange-cod-qrww6qwwr6wh445w-8080.app.github.dev/oraclecloud/galpones/inactivos'));

  if (response.statusCode == 200) {
    List<dynamic> data = jsonDecode(response.body);
    List<Galpones> galpones =
        data.map((json) => Galpones.fromJson(json)).toList();
    return galpones;
  } else {
    throw Exception("Problemas con la API");
  }
}

class ContainerListarInactivos extends StatefulWidget {
  final TextEditingController searchController;

  const ContainerListarInactivos({Key? key, required this.searchController})
      : super(key: key);

  @override
  _ContainerListarInactivosState createState() =>
      _ContainerListarInactivosState();
}

class _ContainerListarInactivosState extends State<ContainerListarInactivos> {
  List<Galpones> galpones = [];
  List<Galpones> galponesFiltrados = [];

  @override
  void initState() {
    super.initState();
    cargarGalpones();
  }

  int? _selectedCardIndex;

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
                        buscarGalpones(value);
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
            _buildGalponesList(),
          ],
        ),
      ),
    );
  }

  Widget _buildGalponesList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: galponesFiltrados.length,
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
                  SizedBox(width: 12),
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
                  SizedBox(width: 8),
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
                            "Lote: ${galponesFiltrados[index].lote}\nCapacidad: ${galponesFiltrados[index].capacity}\nTipo de Galpon: ${galponesFiltrados[index].type}",
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
                            "     Fecha: ${galponesFiltrados[index].fecha}",
                            style: TextStyle(
                              color: Provider.of<ModoNocturnoProvider>(context)
                                      .modoNocturno
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                          Text(
                            "     Ubicacion: ${galponesFiltrados[index].ubicacionId}",
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
                      _confirmarRestauracion(galponesFiltrados[index].id);
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

  void cargarGalpones() async {
    final response = await http.get(Uri.parse(
        'https://glorious-eureka-97qjr547vg4vf996w-8080.app.github.dev/oraclecloud/galpones/inactivos'));

    if (response.statusCode == 200) {
      setState(() {
        galpones = (jsonDecode(response.body) as List)
            .map((json) => Galpones.fromJson(json))
            .toList();
        galponesFiltrados = List.from(galpones);
      });
    } else {
      throw Exception("Problemas con la API");
    }
  }

  void buscarGalpones(String query) {
    setState(() {
      galponesFiltrados = galpones.where((galpon) {
        final loteLower = galpon.lote.toLowerCase();
        final queryLower = query.toLowerCase();
        return loteLower.contains(queryLower);
      }).toList();
    });
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
                  '¿Esta seguro que quiere restaurar este galpon?',
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
                        restaurarGalpon(id);
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

  void restaurarGalpon(String id) async {
    final response = await http.put(Uri.parse(
        'https://glorious-eureka-97qjr547vg4vf996w-8080.app.github.dev/oraclecloud/galpones/$id/restaurar'));
    if (response.statusCode == 200) {
      setState(() {
        galpones.removeWhere((galpon) => galpon.id == id);
      });
      print("restauracion Exitosa :D");
      cargarGalpones();
    } else {
      print("Error al restaurar dato");
    }
  }
}

Future<List<Galpones>> fetchGalponAct() async {
  final response = await http.get(
      Uri.parse('https://glorious-eureka-97qjr547vg4vf996w-8080.app.github.dev/oraclecloud/galpones/activos'));

  if (response.statusCode == 200) {
    List<dynamic> data = jsonDecode(response.body);
    List<Galpones> galpones =
        data.map((json) => Galpones.fromJson(json)).toList();
    return galpones;
  } else {
    throw Exception("Problemas con la API");
  }
}

class ContainerListarActivos extends StatefulWidget {
  final TextEditingController searchController;

  const ContainerListarActivos({Key? key, required this.searchController})
      : super(key: key);

  @override
  _ContainerListarActivosState createState() => _ContainerListarActivosState();
}

class _ContainerListarActivosState extends State<ContainerListarActivos> {
  List<Galpones> galpones = [];
  List<Galpones> galponesFiltrados = [];
  String ubicacionSeleccionada = '1';
  List<Map<String, dynamic>> ubicacionesDisponibles = [
    {'zone': 'Santa Anita', 'id': '1'},
    {'zone': 'Buena Aventura', 'id': '2'},
    {'zone': 'MalaBrigo', 'id': '3'},
  ];

  int? _selectedCardIndex;

  @override
  void initState() {
    super.initState();
    cargarGalpones();
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
                        buscarGalpones(value);
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
            _buildGalponesList(),
          ],
        ),
      ),
    );
  }

  Widget _buildGalponesList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: galponesFiltrados.length,
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
                  SizedBox(width: 12),
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
                  SizedBox(width: 8),
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
                            "Lote: ${galponesFiltrados[index].lote}\nCapacidad: ${galponesFiltrados[index].capacity}\nTipo de Galpon: ${galponesFiltrados[index].type}",
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
                                    galponesFiltrados[index]);
                              } else if (choice == 'Eliminar') {
                                _confirmarEliminacion(
                                    galponesFiltrados[index].id);
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
                            "     Fecha: ${galponesFiltrados[index].fecha}",
                            style: TextStyle(
                              color: Provider.of<ModoNocturnoProvider>(context)
                                      .modoNocturno
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                          Text(
                            "     Ubicacion: ${galponesFiltrados[index].ubicacionId}",
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

  void cargarGalpones() async {
    final response = await http.get(
        Uri.parse('https://glorious-eureka-97qjr547vg4vf996w-8080.app.github.dev/oraclecloud/galpones/activos'));

    if (response.statusCode == 200) {
      setState(() {
        galpones = (jsonDecode(response.body) as List)
            .map((json) => Galpones.fromJson(json))
            .toList();
        galponesFiltrados = List.from(galpones);
      });
    } else {
      throw Exception("Problemas con la API");
    }
  }

  void buscarGalpones(String query) {
    setState(() {
      galponesFiltrados = galpones.where((galpon) {
        final loteLower = galpon.lote.toLowerCase();
        final queryLower = query.toLowerCase();
        return loteLower.contains(queryLower);
      }).toList();
    });
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
                        eliminarGalpon(id);
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

  void eliminarGalpon(String id) async {
    final response = await http.put(Uri.parse(
        'https://glorious-eureka-97qjr547vg4vf996w-8080.app.github.dev/oraclecloud/galpones/$id/inactive'));
    if (response.statusCode == 200) {
      setState(() {
        galpones.removeWhere((galpon) => galpon.id == id);
      });
      cargarGalpones();
      print("eliminado Exitoso :D");
    } else {
      print("Error al eliminar");
    }
  }

  void editarGalpon(Galpones galpon) async {
    final response = await http.put(
      Uri.parse(
          'https://glorious-eureka-97qjr547vg4vf996w-8080.app.github.dev/oraclecloud/galpones/update/${galpon.id}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(galpon.toJson()),
    );
    if (response.statusCode == 200) {
      print('Galpón actualizado con éxito');
      cargarGalpones();
    } else {
      print('Error al actualizar el galpón: ${response.statusCode}');
    }
  }

  void _mostrarFormularioEdicion(Galpones galpon) {
    TextEditingController nombreController =
        TextEditingController(text: galpon.lote);
    TextEditingController capacidadController =
        TextEditingController(text: galpon.capacity);
    TextEditingController typeController =
        TextEditingController(text: galpon.type);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, setState) {
            return AlertDialog(
              insetPadding: EdgeInsets.all(9.0),
              title: Text('Editar Galpón'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(
                    height: 22,
                  ),
                  TextField(
                    controller: nombreController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Lote Galpon',
                    ),
                  ),
                  SizedBox(
                    height: 22,
                  ),
                  TextField(
                    controller: capacidadController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Capacidad',
                    ),
                  ),
                  SizedBox(
                    height: 22,
                  ),
                  TextField(
                    controller: typeController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Tipo Galpon',
                    ),
                  ),
                  SizedBox(
                    height: 22,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: DropdownButtonFormField<String>(
                      value: ubicacionSeleccionada,
                      onChanged: (String? newValue) {
                        setState(() {
                          ubicacionSeleccionada = newValue!;
                        });
                      },
                      items: ubicacionesDisponibles
                          .map<DropdownMenuItem<String>>((ubicacion) {
                        return DropdownMenuItem<String>(
                          value: ubicacion['id'],
                          child: Text(ubicacion['zone']),
                        );
                      }).toList(),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 16.0),
                        border: InputBorder.none, 
                      ),
                    ),
                  ),
                ],
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
                    String lote = nombreController.text;
                    String capacidad = capacidadController.text;
                    String type = typeController.text;

                    Galpones galponActualizado = Galpones(
                      id: galpon.id,
                      lote: lote,
                      capacity: capacidad,
                      type: type,
                      ubicacionId: ubicacionSeleccionada,
                      fecha: '',
                    );

                    editarGalpon(galponActualizado);

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

// CONTENEDOR PARA REGISTRAR GALPON

class Container3 extends StatefulWidget {
  @override
  _Container3State createState() => _Container3State();
}

class _Container3State extends State<Container3> {
  String? _selectedItem;
  TextEditingController capacity = TextEditingController();
  TextEditingController lote = TextEditingController();
  TextEditingController _controller = TextEditingController();
  String? _selectedUbicacion;
  String? _selectedTipo;
  final _formKey = GlobalKey<FormState>();

  _Container3State() {
    _selectedUbicacion = null;
    _selectedTipo = null;
  }

  @override
  void initState() {
    super.initState();
    _controller.text = DateFormat('dd-MM-yyyy').format(
      DateTime.now(),
    );
  }

  @override
  void dispose() {
    // Limpia los controladores
    capacity.dispose();
    lote.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(top: 10.0),
        child: Center(
          child: _buildContainer(context),
        ),
      ),
    );
  }

  Widget _buildContainer(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(bottom: 120),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 40),
              _buildCapacityField(),
              SizedBox(height: 30),
              _buildLoteField(),
              SizedBox(height: 30),
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  filled: true,
                  fillColor:
                      Provider.of<ModoNocturnoProvider>(context).modoNocturno
                          ? Color.fromARGB(255, 168, 168, 168)
                          : Colors.white,
                  contentPadding: EdgeInsets.only(
                    top: 6,
                    bottom: 6,
                    left: 20,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    borderSide: BorderSide(
                      width: 1,
                    ),
                  ),
                  suffixIcon: Icon(Icons.date_range_sharp),
                ),
                readOnly: true,
                onTap: () {},
              ),
              SizedBox(height: 30),
              _buildTipoDropdown(),
              SizedBox(height: 30),
              _buildUbicacionDropdown(),
              SizedBox(height: 30),
              _buildRegisterButton(),
            ],
          ),
        ),
      ),
      decoration: BoxDecoration(
        color: Provider.of<ModoNocturnoProvider>(context).modoNocturno
            ? Color.fromARGB(255, 61, 61, 61)
            : Color.fromARGB(255, 221, 221, 221),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(45),
          topRight: Radius.circular(45),
        ),
      ),
    );
  }

  Widget _buildCapacityField() {
    return TextFormField(
      controller: capacity,
      decoration: InputDecoration(
        filled: true,
        fillColor: Provider.of<ModoNocturnoProvider>(context).modoNocturno
            ? Color.fromARGB(255, 168, 168, 168)
            : Colors.white,
        contentPadding: EdgeInsets.only(
          top: 6,
          bottom: 6,
          left: 20,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          borderSide: BorderSide(
            width: 1,
          ),
        ),
        hintText: 'Capacidad',
        suffixIcon: Icon(Icons.reduce_capacity_outlined),
      ),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Capacidad es requerida';
        }
        if (!RegExp(r'^\d{5}$').hasMatch(value)) {
          return 'Capacidad debe ser un número de 5 dígitos';
        }
        return null;
      },
    );
  }

  Widget _buildLoteField() {
    return TextFormField(
      controller: lote,
      decoration: InputDecoration(
        filled: true,
        fillColor: Provider.of<ModoNocturnoProvider>(context).modoNocturno
            ? Color.fromARGB(255, 168, 168, 168)
            : Colors.white,
        contentPadding: EdgeInsets.only(
          top: 6,
          bottom: 6,
          left: 20,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          borderSide: BorderSide(
            width: 1,
          ),
        ),
        hintText: 'Lote',
        suffixIcon: Icon(Icons.home),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Lote es requerido';
        }
        if (!RegExp(r'^\d{3} [A-Z]$').hasMatch(value)) {
          return 'Lote debe seguir el formato 123 A';
        }
        return null;
      },
    );
  }

  Widget _buildTipoDropdown() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        filled: true,
        fillColor: Provider.of<ModoNocturnoProvider>(context).modoNocturno
            ? Color.fromARGB(255, 168, 168, 168)
            : Colors.white,
        contentPadding: EdgeInsets.only(
          top: 6,
          bottom: 6,
          left: 20,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          borderSide: BorderSide(
            width: 1,
          ),
        ),
        hintText: 'Tipo de Galpon',
      ),
      value: _selectedTipo,
      items: [
        DropdownMenuItem<String>(
          value: 'Manual',
          child: Text('Manual'),
        ),
        DropdownMenuItem<String>(
          value: 'Automatico',
          child: Text('Automatico'),
        ),
      ],
      onChanged: (String? value) {
        setState(() {
          _selectedTipo = value;
        });
      },
      validator: (value) {
        if (value == null) {
          return 'Tipo es requerido';
        }
        return null;
      },
    );
  }

  Widget _buildUbicacionDropdown() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        filled: true,
        fillColor: Provider.of<ModoNocturnoProvider>(context).modoNocturno
            ? Color.fromARGB(255, 168, 168, 168)
            : Colors.white,
        contentPadding: EdgeInsets.only(
          top: 6,
          bottom: 6,
          left: 20,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          borderSide: BorderSide(
            width: 1,
          ),
        ),
        hintText: 'Ubicacion',
      ),
      value: _selectedUbicacion,
      items: [
        DropdownMenuItem<String>(
          value: '1',
          child: Text('Santa Anita'),
        ),
        DropdownMenuItem<String>(
          value: '2',
          child: Text('Buena Aventura'),
        ),
        DropdownMenuItem<String>(
          value: '3',
          child: Text('MalaBrigo'),
        ),
      ],
      onChanged: (String? value) {
        setState(() {
          _selectedUbicacion = value;
        });
      },
      validator: (value) {
        if (value == null) {
          return 'Ubicación es requerida';
        }
        return null;
      },
    );
  }

  Widget _buildRegisterButton() {
    return TextButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: Text("¿Desea registrar este Galpon?"),
                actions: [
                  TextButton(
                    onPressed: () async {
                      await saveGalpon();
                      Navigator.of(context).pop();
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: Text("Registro Exitoso"),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Text('Registrar'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Cancelar'),
                  ),
                ],
              );
            },
          );
        }
      },
      child: Text(
        "Registrar",
        style: TextStyle(
          fontSize: 18.0,
        ),
      ),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(
          Provider.of<ModoNocturnoProvider>(context).modoNocturno
              ? Color.fromARGB(255, 255, 145, 0)
              : const Color.fromARGB(255, 134, 3, 47),
        ),
        foregroundColor: MaterialStateProperty.all(Colors.white),
        padding: MaterialStateProperty.all(
          EdgeInsets.only(top: 15, bottom: 15, left: 35, right: 35),
        ),
      ),
    );
  }

  Future<void> saveGalpon() async {
    final ubicacionId = _selectedUbicacion;
    final tipo = _selectedTipo;

    if (ubicacionId != null && tipo != null) {
      final galpones = {
        "capacity": capacity.text,
        "lote": lote.text,
        "type": tipo,
        "ubicacion": {
          "id": ubicacionId,
        },
      };

      final headers = {"Content-type": "application/json; charset=UTF-8"};
      final res = await http.post(
        Uri.parse('https://glorious-eureka-97qjr547vg4vf996w-8080.app.github.dev/oraclecloud/galpones/create'),
        headers: headers,
        body: jsonEncode(galpones),
      );

      capacity.clear();
      lote.clear();
      setState(() {
        _selectedTipo = null;
        _selectedUbicacion = null;
      });
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text("Por favor seleccione una ubicación y un tipo."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
}

class Container4 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.only(top: 30.0),
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
