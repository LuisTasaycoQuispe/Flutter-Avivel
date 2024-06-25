
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:myapp/widgets/oscuro.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'dart:ui';
import 'package:myapp/model/Produccion.dart';

Future<List<Produccion>> fetchGalponAct() async {
  final response = await http.get(
      Uri.parse('https://glorious-eureka-97qjr547vg4vf996w-8080.app.github.dev/oraclecloud/produccion/activos'));

  if (response.statusCode == 200) {
    List<dynamic> data = jsonDecode(response.body);
    List<Produccion> galpones =
        data.map((json) => Produccion.fromJson(json)).toList();
    return galpones;
  } else {
    throw Exception("Problemas con la API");
  }
}

class ProduccionListarActivos extends StatefulWidget {
  final TextEditingController searchController;

  const ProduccionListarActivos({Key? key, required this.searchController})
      : super(key: key);

  @override
  _ContainerListarActivosState createState() => _ContainerListarActivosState();
}

class _ContainerListarActivosState extends State<ProduccionListarActivos> {
  List<Produccion> galpones = [];
  List<Produccion> produccionFiltrados = [];
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
    cargarProduccion();
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
                        buscarProduccion(value);
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
      itemCount: produccionFiltrados.length,
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
                        
                          subtitle: Text(
                            "Produccion Total: ${produccionFiltrados[index].totalProduccion}\nFecha: ${produccionFiltrados[index].fecha}\nJava Rosado: ${produccionFiltrados[index].javaRosado}",
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
                                    produccionFiltrados[index]);
                              } else if (choice == 'Eliminar') {
                                _confirmarEliminacion(
                                    produccionFiltrados[index].id);
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
                            "     Unidad Bueno: ${produccionFiltrados[index].unidadRosado}",
                            style: TextStyle(
                              color: Provider.of<ModoNocturnoProvider>(context)
                                      .modoNocturno
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                          Text(
                            "     Java Quiñado: ${produccionFiltrados[index].javaQuinado}",
                            style: TextStyle(
                              color: Provider.of<ModoNocturnoProvider>(context)
                                      .modoNocturno
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                           Text(
                            "     Unidad Quiñado: ${produccionFiltrados[index].unidadQuinado}",
                            style: TextStyle(
                              color: Provider.of<ModoNocturnoProvider>(context)
                                      .modoNocturno
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                           Text(
                            "     Java Roto: ${produccionFiltrados[index].javaRoto}",
                            style: TextStyle(
                              color: Provider.of<ModoNocturnoProvider>(context)
                                      .modoNocturno
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                           Text(
                            "     Unidad Roto: ${produccionFiltrados[index].unidadRoto}",
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

  void cargarProduccion() async {
    final response = await http.get(
        Uri.parse('https://glorious-eureka-97qjr547vg4vf996w-8080.app.github.dev/oraclecloud/produccion/activos'));

    if (response.statusCode == 200) {
      setState(() {
        galpones = (jsonDecode(response.body) as List)
            .map((json) => Produccion.fromJson(json))
            .toList();
        produccionFiltrados = List.from(galpones);
      });
    } else {
      throw Exception("Problemas con la API");
    }
  }

  void buscarProduccion(String query) {
    setState(() {
      produccionFiltrados = galpones.where((galpon) {
        final loteLower = galpon.totalProduccion.toLowerCase();
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
                        eliminarProduccion(id);
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

  void eliminarProduccion(String id) async {
    final response = await http.put(Uri.parse(
        'https://glorious-eureka-97qjr547vg4vf996w-8080.app.github.dev/oraclecloud/produccion/$id/inactive'));
    if (response.statusCode == 200) {
      setState(() {
        galpones.removeWhere((galpon) => galpon.id == id);
      });
      cargarProduccion();
      print("eliminado Exitoso :D");
    } else {
      print("Error al eliminar");
    }
  }

  void editarGalpon(Produccion galpon) async {
    final response = await http.put(
      Uri.parse(
          'https://glorious-eureka-97qjr547vg4vf996w-8080.app.github.dev/oraclecloud/produccion/update/${galpon.id}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(galpon.toJson()),
    );
    if (response.statusCode == 200) {
      print('Galpón actualizado con éxito');
      cargarProduccion();
    } else {
      print('Error al actualizar el galpón: ${response.statusCode}');
    }
  }

  void _mostrarFormularioEdicion(Produccion galpon) {
    TextEditingController nombreController =
        TextEditingController(text: galpon.totalProduccion);
    TextEditingController capacidadController =
        TextEditingController(text: galpon.javaQuinado);
    TextEditingController typeController =
        TextEditingController(text: galpon.unidadRosado);

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

                    Produccion galponActualizado = Produccion(
                      id: galpon.id,
                      javaRosado: lote,
                      javaQuinado: capacidad,
                      javaRoto: type,
                      totalProduccion: ubicacionSeleccionada,
                      fecha: '', unidadRosado: '', unidadQuinado: '', unidadRoto: '', asignacionId: '', 
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




Future<List<Produccion>> fetchGalponInac() async {
  final response = await http.get(
      Uri.parse('https://glorious-eureka-97qjr547vg4vf996w-8080.app.github.dev/oraclecloud/produccion/inactivos'));

  if (response.statusCode == 200) {
    List<dynamic> data = jsonDecode(response.body);
    List<Produccion> galpones =
        data.map((json) => Produccion.fromJson(json)).toList();
    return galpones;
  } else {
    throw Exception("Problemas con la API");
  }
}

class ProduccionListarInac extends StatefulWidget {
  final TextEditingController searchController;

  const ProduccionListarInac({Key? key, required this.searchController})
      : super(key: key);

  @override
  _ProduccionListarInacState createState() => _ProduccionListarInacState();
}

class _ProduccionListarInacState extends State<ProduccionListarInac> {
  List<Produccion> galpones = [];
  List<Produccion> produccionFiltrados = [];
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
    cargarProduccionInac();
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
                        buscarProduccion(value);
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
            _buildProduccionList(),
          ],
        ),
      ),
    );
  }

  Widget _buildProduccionList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: produccionFiltrados.length,
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
                          
                         subtitle: Text(
                            "Produccion Total: ${produccionFiltrados[index].totalProduccion}\nFecha: ${produccionFiltrados[index].fecha}\nJava Rosado: ${produccionFiltrados[index].javaRosado}",
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
                            "     Unidad Bueno: ${produccionFiltrados[index].unidadRosado}",
                            style: TextStyle(
                              color: Provider.of<ModoNocturnoProvider>(context)
                                      .modoNocturno
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                          Text(
                            "     Java Quiñado: ${produccionFiltrados[index].javaQuinado}",
                            style: TextStyle(
                              color: Provider.of<ModoNocturnoProvider>(context)
                                      .modoNocturno
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                           Text(
                            "     Unidad Quiñado: ${produccionFiltrados[index].unidadQuinado}",
                            style: TextStyle(
                              color: Provider.of<ModoNocturnoProvider>(context)
                                      .modoNocturno
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                           Text(
                            "     Java Roto: ${produccionFiltrados[index].javaRoto}",
                            style: TextStyle(
                              color: Provider.of<ModoNocturnoProvider>(context)
                                      .modoNocturno
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                           Text(
                            "     Unidad Roto: ${produccionFiltrados[index].unidadRoto}",
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
                      _confirmarRestauracion(produccionFiltrados[index].id);
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

  void cargarProduccionInac() async {
    final response = await http.get(
        Uri.parse('https://glorious-eureka-97qjr547vg4vf996w-8080.app.github.dev/oraclecloud/produccion/inactivos'));

    if (response.statusCode == 200) {
      setState(() {
        galpones = (jsonDecode(response.body) as List)
            .map((json) => Produccion.fromJson(json))
            .toList();
        produccionFiltrados = List.from(galpones);
      });
    } else {
      throw Exception("Problemas con la API");
    }
  }

  void buscarProduccion(String query) {
    setState(() {
      produccionFiltrados = galpones.where((galpon) {
        final loteLower = galpon.totalProduccion.toLowerCase();
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
                        restaurarProduccion(id);
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

  void restaurarProduccion(String id) async {
    final response = await http.put(Uri.parse(
        'https://glorious-eureka-97qjr547vg4vf996w-8080.app.github.dev/oraclecloud/produccion/$id/restaurar'));
    if (response.statusCode == 200) {
      setState(() {
        galpones.removeWhere((galpon) => galpon.id == id);
      });
      print("restauracion Exitosa :D");
      cargarProduccionInac();
    } else {
      print("Error al restaurar dato");
    }
  }
}
















