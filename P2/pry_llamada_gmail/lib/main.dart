import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// importacion de todas las vistas de la aplicacion
import 'views/home_view.dart';
import 'views/llamada_view.dart';
import 'views/correo_view.dart';
import 'views/info_view.dart';

// punto de entrada principal de la aplicacion
void main() {
  runApp(const MiApp());
}

// widget raiz de la aplicacion, es stateless porque solo configura el tema y rutas
class MiApp extends StatelessWidget {
  const MiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // titulo de la aplicacion en el gestor de tareas del dispositivo
      title: 'Comunicaciones App',

      // oculta el banner de debug en la esquina superior derecha
      debugShowCheckedModeBanner: false,

      // tema global de la aplicacion con paleta de azul marino
      theme: ThemeData(
        // color semilla en azul marino para el sistema de colores de material 3
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1565C0),
          brightness: Brightness.dark,
        ),

        // tipografia global usando la fuente Lora de google fonts
        textTheme: GoogleFonts.loraTextTheme(
          ThemeData.dark().textTheme,
        ),

        // activa material design 3
        useMaterial3: true,

        // color de fondo de los scaffolds en azul marino oscuro
        scaffoldBackgroundColor: const Color(0xFF0D1B2A),
      ),

      // ruta inicial de la aplicacion
      initialRoute: '/inicio',

      // mapa de rutas nombradas para la navegacion con pushNamed
      routes: {
        // pantalla de inicio con el BottomNavigationBar
        '/inicio': (context) => const HomeView(),

        // pantalla de llamadas telefonicas
        '/llamadas': (context) => const LlamadaView(),

        // pantalla de correo electronico
        '/correo': (context) => const CorreoView(),

        // pantalla de informacion de la aplicacion
        '/info': (context) => const InfoView(),
      },
    );
  }
}
