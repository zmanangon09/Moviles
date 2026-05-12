import 'package:flutter/material.dart';
import '../../model/pedido_comida_modelo.dart';

class BloqueResumen extends StatelessWidget {
  final PedidoComidaModelo pedido;

  const BloqueResumen({super.key, required this.pedido});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Nota de Venta',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            _FilaResumen(etiqueta: 'Cliente:', valor: pedido.cliente),
            _FilaResumen(etiqueta: 'Producto:', valor: pedido.producto),
            _FilaResumen(etiqueta: 'Combo:', valor: pedido.tipoCombo),
            _FilaResumen(etiqueta: 'Cantidad:', valor: pedido.cantidad.toString()),
            const Divider(),
            _FilaResumen(etiqueta: 'Subtotal:', valor: '\$${pedido.subtotal.toStringAsFixed(2)}'),
            _FilaResumen(etiqueta: 'IVA (15%):', valor: '\$${pedido.iva.toStringAsFixed(2)}'),
            const Divider(),
            _FilaResumen(
              etiqueta: 'Total a Pagar:',
              valor: '\$${pedido.total.toStringAsFixed(2)}',
              esTotal: true,
            ),
          ],
        ),
      ),
    );
  }
}

class _FilaResumen extends StatelessWidget {
  final String etiqueta;
  final String valor;
  final bool esTotal;

  const _FilaResumen({
    required this.etiqueta,
    required this.valor,
    this.esTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            etiqueta,
            style: TextStyle(
              fontSize: esTotal ? 18 : 16,
              fontWeight: esTotal ? FontWeight.bold : FontWeight.w500,
            ),
          ),
          Text(
            valor,
            style: TextStyle(
              fontSize: esTotal ? 18 : 16,
              fontWeight: esTotal ? FontWeight.bold : FontWeight.normal,
              color: esTotal ? Theme.of(context).primaryColor : null,
            ),
          ),
        ],
      ),
    );
  }
}
