import 'package:flutter/material.dart';
import '../../controller/comida_controlador.dart';
import '../moleculas/formulario_pedido.dart';
import 'vista_nota_venta_comida.dart';

class VistaComidaRapida extends StatefulWidget {
  const VistaComidaRapida({super.key});

  @override
  State<VistaComidaRapida> createState() => _VistaComidaRapidaState();
}

class _VistaComidaRapidaState extends State<VistaComidaRapida> {
  late ComidaControlador _controlador;

  @override
  void initState() {
    super.initState();
    _controlador = ComidaControlador();
  }

    void _generarNotaVenta(String cliente, String producto, String combo, String cantidadStr) {
    FocusScope.of(context).unfocus(); // Cerrar teclado
    
    final pedido = _controlador.procesarPedido(
      cliente: cliente,
      producto: producto,
      tipoCombo: combo,
      cantidadStr: cantidadStr,
    );

    // Navegar usando nombre y enviando el objeto como argumento
    Navigator.pushNamed(
      context,
      '/notaVentaComida',
      arguments: pedido,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comida Rápida'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Text(
              'Ingresa tu pedido',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            FormularioPedido(
              controlador: _controlador,
              onSubmit: _generarNotaVenta,
            ),
          ],
        ),
      ),
    );
  }
}
