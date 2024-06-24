
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:myapp/model/Asignacion.dart';
import 'package:myapp/widgets/oscuro.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'dart:ui';
import 'package:intl/intl.dart';
import 'package:date_field/date_field.dart';
import 'package:intl/intl_standalone.dart'
    if (dart.library.html) 'package:intl/intl_browser.dart';

Future<List<Asignacion>> fetchAsigAct() async {
  final response = await http.get(
      Uri.parse('https://glorious-eureka-97qjr547vg4vf996w-8080.app.github.dev/oraclecloud/asignaciones/activos'));

  if (response.statusCode == 200) {
    List<dynamic> data = jsonDecode(response.body);
    List<Asignacion> asignacion =
        data.map((json) => Asignacion.fromJson(json)).toList();
    return asignacion;
  } else {
    throw Exception("Problemas con la API");
  }
}

class AsignacionListarActivos extends StatefulWidget {
  final TextEditingController searchController;

  const AsignacionListarActivos({Key? key, required this.searchController})
      : super(key: key);

  @override
  _ContainerListarActivosState createState() => _ContainerListarActivosState();
}

class _ContainerListarActivosState extends State<AsignacionListarActivos> {
  List<Asignacion> asignacion = [];
  List<Asignacion> asignacionFiltrados = [];


  int? _selectedCardIndex;

  @override
  void initState() {
    super.initState();
    cargarAsignacion();
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
                        buscarAsignacion(value);
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
            _buildasignacionList(),
          ],
        ),
      ),
    );
  }

  Widget _buildasignacionList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: asignacionFiltrados.length,
      itemBuilder: (context, index) {
        String fecha = asignacionFiltrados[index].fechaInicio;
        final parsearFecha = DateTime.parse(fecha);
        final formatoFecha = DateFormat('dd-MM-yyyy').format(parsearFecha);

        print(formatoFecha);
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
                            "Persona: ${asignacionFiltrados[index].persona}\nGalpon: ${asignacionFiltrados[index].sheds}\n Fecha: $formatoFecha",
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
                                    asignacionFiltrados[index]);
                              } else if (choice == 'Eliminar') {
                                _confirmarEliminacion(
                                    asignacionFiltrados[index].id);
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
                            "     Unidad Bueno: ${asignacionFiltrados[index].id}",
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

  void cargarAsignacion() async {
    final response = await http.get(
        Uri.parse('https://glorious-eureka-97qjr547vg4vf996w-8080.app.github.dev/oraclecloud/asignaciones/activos'));

    if (response.statusCode == 200) {
      setState(() {
        asignacion = (jsonDecode(response.body) as List)
            .map((json) => Asignacion.fromJson(json))
            .toList();
        asignacionFiltrados = List.from(asignacion);
      });
    } else {
      throw Exception("Problemas con la API");
    }
  }

  void buscarAsignacion(String query) {
    setState(() {
      asignacionFiltrados = asignacion.where((asignad) {
        final loteLower = asignad.persona.toLowerCase();
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
                        eliminarAsignacion(id);
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

  void eliminarAsignacion(String id) async {
    final response = await http.put(Uri.parse(
        'https://glorious-eureka-97qjr547vg4vf996w-8080.app.github.dev/oraclecloud/asignaciones/$id/inactive'));
    if (response.statusCode == 200) {
      setState(() {
        asignacion.removeWhere((galpon) => galpon.id == id);
      });
      cargarAsignacion();
      print("eliminado Exitoso :D");
    } else {
      print("Error al eliminar");
    }
  }

  void editarGalpon(Asignacion asignacion) async {
    final response = await http.put(
      Uri.parse(
          'https://glorious-eureka-97qjr547vg4vf996w-8080.app.github.dev/oraclecloud/asignaciones/update/${asignacion.id}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(asignacion.toJson()),
    );
    if (response.statusCode == 200) {
      print('Galpón actualizado con éxito');
      cargarAsignacion();
    } else {
      print('Error al actualizar el galpón: ${response.statusCode}');
    }
  }

  void _mostrarFormularioEdicion(Asignacion asignacion) {
    TextEditingController nombreController =
        TextEditingController(text: asignacion.fechaInicio);
    TextEditingController capacidadController =
        TextEditingController(text: asignacion.persona);
    TextEditingController typeController =
        TextEditingController(text: asignacion.sheds);

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
                  
                ],
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancelar'),
                ),
                // TextButton(
                //   onPressed: () {
                //     String lote = nombreController.text;
                //     String capacidad = capacidadController.text;
                //     String type = typeController.text;

                //     Asignacion galponActualizado = Asignacion(
                //       id: galpon.id, persona: '', sheds:'', fechaInicio: '',
                     
                    
                      
                //     );

                //     editarGalpon(galponActualizado);

                //     Navigator.of(context).pop();
                //   },
                //   child: Text('Guardar'),
                // ),
              ],
            );
          },
        );
      },
    );
  }
}




Future<List<Asignacion>> fetchGalponInac() async {
  final response = await http.get(
      Uri.parse('https://glorious-eureka-97qjr547vg4vf996w-8080.app.github.dev/oraclecloud/asignaciones/inactivos'));

  if (response.statusCode == 200) {
    List<dynamic> data = jsonDecode(response.body);
    List<Asignacion> asignacion =
        data.map((json) => Asignacion.fromJson(json)).toList();
    return asignacion;
  } else {
    throw Exception("Problemas con la API");
  }
}

class AsignacionListarInac extends StatefulWidget {
  final TextEditingController searchController;

  const AsignacionListarInac({Key? key, required this.searchController})
      : super(key: key);

  @override
  _AsignacionListarInacState createState() => _AsignacionListarInacState();
}

class _AsignacionListarInacState extends State<AsignacionListarInac> {
  List<Asignacion> asignacion = [];
  List<Asignacion> asignacionFiltrados = [];
  String ubicacionSeleccionada = '1';


  int? _selectedCardIndex;

  @override
  void initState() {
    super.initState();
    cargarAsignacionInac();
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
                        buscarAsignacion(value);
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
            _buildAsignacionList(),
          ],
        ),
      ),
    );
  }

  Widget _buildAsignacionList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: asignacionFiltrados.length,
      itemBuilder: (context, index) {
        String fecha = asignacionFiltrados[index].fechaInicio;
        final parsearFecha = DateTime.parse(fecha);
        final formatoFecha = DateFormat('dd-MM-yyyy').format(parsearFecha);

        print(formatoFecha);
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
                            "Persona: ${asignacionFiltrados[index].persona}\nGalpon: ${asignacionFiltrados[index].sheds}\n Fecha: $formatoFecha",
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
                            "     Unidad Bueno: ${asignacionFiltrados[index].id}",
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
                      _confirmarRestauracion(asignacionFiltrados[index].id);
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

  void cargarAsignacionInac() async {
    final response = await http.get(
        Uri.parse('https://glorious-eureka-97qjr547vg4vf996w-8080.app.github.dev/oraclecloud/asignaciones/inactivos'));

    if (response.statusCode == 200) {
      setState(() {
        asignacion = (jsonDecode(response.body) as List)
            .map((json) => Asignacion.fromJson(json))
            .toList();
        asignacionFiltrados = List.from(asignacion);
      });
    } else {
      throw Exception("Problemas con la API");
    }
  }

  void buscarAsignacion(String query) {
    setState(() {
      asignacionFiltrados = asignacion.where((asignacion) {
        final loteLower = asignacion.fechaInicio.toLowerCase();
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
                        restaurarAsignacion(id);
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

  void restaurarAsignacion(String id) async {
    final response = await http.put(Uri.parse(
        'https://glorious-eureka-97qjr547vg4vf996w-8080.app.github.dev/oraclecloud/asignaciones/$id/restaurar'));
    if (response.statusCode == 200) {
      setState(() {
        asignacion.removeWhere((galpon) => galpon.id == id);
      });
      print("restauracion Exitosa :D");
      cargarAsignacionInac();
    } else {
      print("Error al restaurar dato");
    }
  }
}




class Container3 extends StatefulWidget {
  @override
  _Container3State createState() => _Container3State();
}

class _Container3State extends State<Container3> {
  String? _selectedItem;
  TextEditingController sheds = TextEditingController();
  TextEditingController fecha = TextEditingController();
  TextEditingController _controller = TextEditingController();
  String? _selectedUbicacion;
  String? _selectedTipo;
  final _formKey = GlobalKey<FormState>();
  List<Map<String, dynamic>> personas = [];
  String? _selectedPersona;

  _Container3State() {
    _selectedUbicacion = null;
    _selectedTipo = null;
  }

  @override
  void initState() {
    super.initState();
    _controller.text = DateFormat('dd-MM-yyyy').format(DateTime.now());
    fetchPersonas();
  }

  @override
  void dispose() {
    sheds.dispose();
    fecha.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> fetchPersonas() async {
    final res = await http.get(
      Uri.parse('https://glorious-eureka-97qjr547vg4vf996w-8080.app.github.dev/oraclecloud/persona'),
    );

    if (res.statusCode == 200) {
      setState(() {
        personas = List<Map<String, dynamic>>.from(json.decode(res.body));
      });
    } else {
      throw Exception('Failed to load personas');
    }
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
              _buildPersonaDropdown(),
              SizedBox(height: 30),
              _buildShedsField(),
              SizedBox(height: 30),
              _buildFechaField(),
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

  Widget _buildPersonaDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedPersona,
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
        hintText: 'Persona',
      ),
      items: personas.map((persona) {
        return DropdownMenuItem<String>(
          value: persona['id'].toString(),
          child: Text(persona['names']),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedPersona = value;
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor seleccione una persona';
        }
        return null;
      },
    );
  }

  Widget _buildShedsField() {
    return TextFormField(
      controller: sheds,
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
        hintText: 'Galpon',
        suffixIcon: Icon(Icons.home),
      ),
    );
  }

  Widget _buildFechaField() {
    return TextFormField(
      controller: fecha,
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
        hintText: 'Fecha',
        suffixIcon: Icon(Icons.home),
      ),
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
                      await saveAsignacion();
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

  Future<void> saveAsignacion() async {
    final asignacion = {
      "fechaInicio": fecha.text,
      "sheds": {
        "id": sheds.text,
      },
      "persona": {
        "id": _selectedPersona,
      },
    };

    final headers = {"Content-type": "application/json; charset=UTF-8"};
    final res = await http.post(
      Uri.parse('https://glorious-eureka-97qjr547vg4vf996w-8080.app.github.dev/oraclecloud/asignaciones/create'),
      headers: headers,
      body: jsonEncode(asignacion),
    );

    sheds.clear();
    setState(() {
      _selectedTipo = null;
      _selectedUbicacion = null;
      _selectedPersona = null;
    });
  }
}











