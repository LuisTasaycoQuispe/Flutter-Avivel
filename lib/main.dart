import 'package:myapp/pages/chat/prueba_user.dart';
import 'package:myapp/pages/google_maps.dart';
import 'package:myapp/pages/transaccional/produccion/produccion.dart';
import 'package:myapp/utils/Main_Asig_Page.dart';
import 'package:myapp/utils/Main_Home_Page.dart';
import 'package:myapp/pages/home.page.dart';
import 'package:myapp/pages/panel_page.dart';
import 'package:myapp/utils/Main_Producc_Page.dart';
import 'package:myapp/utils/Main_Sheds_Page.dart';
import 'package:myapp/utils/MenuMaps.dart';
import 'package:myapp/pages/profile_screen.dart';
import 'package:myapp/widgets/oscuro.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ModoNocturnoProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: SplashScreen(),
      routes: {
        'panel': (_) => PanelPage(),
        'produccion': (_) => MainProduccionPage(),
        'home': (_) => HomePages(),
        'sheds': (_) => MainShedsPage(),
        'person': (_) => MainHomePage(),
        'maps': (_) => GoogleMapsPage(),
        'chat': (_) => HomeChat(),
        'asignacion': (_) => MainAsignacionPage(),

        '/profile': (context) =>
            ProfileScreen(ModalRoute.of(context)!.settings.arguments as int),
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _animationController.forward();

    Future.delayed(Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => HomePages()),
      );
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 0, 2, 131),
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Opacity(
            opacity: _animation.value,
            child: Center(
              child: Text(
                'AVIVEL',
                style: TextStyle(
                  fontSize: 24,
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
