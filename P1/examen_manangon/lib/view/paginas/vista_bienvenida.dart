import 'package:flutter/material.dart';
import '../atomos/boton_personalizado.dart';
import 'vista_comida_rapida.dart';

class VistaBienvenida extends StatelessWidget {
  const VistaBienvenida({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.fastfood,
                size: 100,
                color: Colors.red,
              ),
              const SizedBox(height: 24),
              const Text(
                'COMIDA RAPIDA ZAMV',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              BotonPersonalizado(
                text: 'Iniciar Pedido',
                onPressed: () {
                  // Navegamos por el nombre de la ruta definida en main
                  Navigator.pushNamed(context, '/comida');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
