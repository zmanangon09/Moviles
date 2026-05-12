import 'package:flutter/material.dart';
import 'themes/tema_general.dart';
import 'view/paginas/vista_bienvenida.dart';
import 'view/paginas/vista_comida_rapida.dart';
import 'view/paginas/vista_nota_venta_comida.dart';
import 'model/pedido_comida_modelo.dart'; // Importa el modelo

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Comida Rapida ZAMV',
      debugShowCheckedModeBanner: false,
      theme: TemaGeneral.claro,
      // Usamos initialRoute en vez de 'home'
      initialRoute: '/',
      routes: {
        '/': (context) => const VistaBienvenida(),
        '/comida': (context) => const VistaComidaRapida(),
      },
      // onGenerateRoute maneja las rutas dinámicas para recuperar los argumentos
      onGenerateRoute: (settings) {
        if (settings.name == '/notaVentaComida') {
          // Extraemos el argumento casteándolo al tipo de nuestro modelo
          final pedido = settings.arguments as PedidoComidaModelo;
          return MaterialPageRoute(
            builder: (context) => VistaNotaVentaComida(pedido: pedido),
          );
        }
        return null;
      },
    );
  }
}