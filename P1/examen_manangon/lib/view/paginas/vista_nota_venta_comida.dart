import 'package:flutter/material.dart';
import '../../model/pedido_comida_modelo.dart';
import '../moleculas/bloque_resumen.dart';
import '../atomos/boton_personalizado.dart';

class VistaNotaVentaComida extends StatelessWidget {
  final PedidoComidaModelo pedido;

  const VistaNotaVentaComida({super.key, required this.pedido});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nota de Venta'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            BloqueResumen(pedido: pedido),
            const SizedBox(height: 32),
            BotonPersonalizado(
              text: 'Nuevo Pedido',
              onPressed: () {
                // Regresar a la pantalla de bienvenida (pop until the first route)
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
            ),
          ],
        ),
      ),
    );
  }
}
