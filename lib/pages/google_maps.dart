import 'dart:async';
import 'package:myapp/widgets/oscuro.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class GoogleMapsPage extends StatefulWidget {
  static String id = 'maps_page';

  @override
  _GoogleMapsPageState createState() => _GoogleMapsPageState();
}

class _GoogleMapsPageState extends State<GoogleMapsPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Completer<GoogleMapController> _controller = Completer();
  int _selectedIndex = 0;

  static final CameraPosition _initialCameraPosition = CameraPosition(
    target: LatLng(-12.963980020218667, -76.33502591351863),
    zoom: 14.4746,
  );

  static final CameraPosition _position = CameraPosition(
    bearing: 192.8334901395799,
    target: LatLng(-13.081537779146661, -76.38779321036725),
    tilt: 59.440717697143555,
    zoom: 19.151926040649414,
  );

  static final CameraPosition _santaAnitaPosition = CameraPosition(
    bearing: 192.8334901395799,
    target: LatLng(-12.938491621063042, -76.38422613983063),
    tilt: 59.440717697143555,
    zoom: 15,
  );

  MapType _currentMapType = MapType.normal;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 0) {
        _goToInitialPosition();
      } else if (index == 1) {
        _goToTheLake();
      } else if (index == 2) {
        _goToQuilmana();
      } else if (index == 3) {
        Navigator.pop(context);
      }
    });
  }

  Future<void> _goToInitialPosition() async {
    final GoogleMapController controller = await _controller.future;
    await controller
        .animateCamera(CameraUpdate.newCameraPosition(_initialCameraPosition));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Provider.of<ModoNocturnoProvider>(context).modoNocturno
          ? Color.fromARGB(255, 48, 48, 48)
          : Color.fromARGB(255, 194, 65, 6),
      key: _scaffoldKey,
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(20),
            width: double.infinity,
            height: 180,
            decoration: BoxDecoration(),
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Text(
                      "Google Maps  ",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                    ),
                    Icon(
                      Icons.location_on,
                      color: Colors.white,
                      size: 30,
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: double.infinity,
                  height: 70,
                  decoration: BoxDecoration(
                    color:
                        Provider.of<ModoNocturnoProvider>(context).modoNocturno
                            ? Color.fromARGB(255, 71, 71, 71)
                            : Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildMapTypeButton(Icons.map, MapType.normal),
                      _buildMapTypeButton(
                          Icons.satellite_alt, MapType.satellite),
                      _buildMapTypeButton(Icons.terrain, MapType.terrain),
                      _buildMapTypeButton(
                          Icons.threed_rotation_outlined, MapType.hybrid),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
              child: GoogleMap(
                mapType: _currentMapType,
                initialCameraPosition: _initialCameraPosition,
                onMapCreated: (GoogleMapController controller) {
                  if (!_controller.isCompleted) {
                    _controller.complete(controller);
                  }
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 80.0),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            backgroundColor: Color.fromARGB(255, 41, 41, 41),
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            backgroundColor: Color.fromARGB(255, 41, 41, 41),
            icon: Icon(Icons.school_rounded),
            label: 'Valle Grande',
          ),
          BottomNavigationBarItem(
            backgroundColor: Color.fromARGB(255, 41, 41, 41),
            icon: Icon(Icons.location_city_rounded),
            label: 'Quilmana',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.close),
            label: 'Cerrar',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        unselectedItemColor: Colors.white,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildMapTypeButton(IconData icon, MapType mapType) {
    return Container(
      width: 50,
      height: 50,
      child: TextButton(
        onPressed: () {
          setState(() {
            _currentMapType = mapType;
          });
        },
        child: Icon(icon, color: Colors.white),
      ),
      decoration: BoxDecoration(
        color: Provider.of<ModoNocturnoProvider>(context).modoNocturno
            ? Color.fromARGB(255, 212, 103, 0)
            : Color.fromARGB(255, 9, 73, 146),
        shape: BoxShape.circle,
      ),
    );
  }

  void _onMapTypeButtonPressed() {
    setState(() {
      _currentMapType =
          _currentMapType == MapType.normal ? MapType.hybrid : MapType.normal;
    });
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(_position));
  }

  Future<void> _goToQuilmana() async {
    final GoogleMapController controller = await _controller.future;
    await controller
        .animateCamera(CameraUpdate.newCameraPosition(_santaAnitaPosition));
  }
}
