import '../model/pedido_comida_modelo.dart';

class ComidaControlador {
  String? validarCliente(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'El nombre del cliente no puede estar vacío';
    }
    return null;
  }

  String? validarCantidad(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'La cantidad no puede estar vacía';
    }
    final int? cantidad = int.tryParse(value);
    if (cantidad == null) {
      return 'Debe ingresar un número válido';
    }
    if (cantidad <= 0) {
      return 'La cantidad debe ser mayor a cero';
    }
    return null;
  }

  PedidoComidaModelo procesarPedido({
    required String cliente,
    required String producto,
    required String tipoCombo,
    required String cantidadStr,
  }) {
    final int cantidad = int.parse(cantidadStr);
    
    // Instanciar el modelo (este realizará los cálculos internamente)
    return PedidoComidaModelo(
      cliente: cliente,
      producto: producto,
      tipoCombo: tipoCombo,
      cantidad: cantidad,
    );
  }
}
