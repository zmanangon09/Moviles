class PedidoComidaModelo {
  String cliente;
  String producto;
  String tipoCombo;
  int cantidad;

  double subtotal = 0.0;
  double iva = 0.0;
  double total = 0.0;

  PedidoComidaModelo({
    required this.cliente,
    required this.producto,
    required this.tipoCombo,
    required this.cantidad,
  }) {
    _calcularValores();
  }

  void _calcularValores() {
    double precioBase = 0.0;
    
    // Precio base del producto
    switch (producto) {
      case 'Hamburguesa':
        precioBase = 4.00;
        break;
      case 'Salchipapa':
        precioBase = 2.00;
        break;
      case 'Hot Dog':
        precioBase = 1.50;
        break;
    }

    double valorAdicionalCombo = 0.0;
    
    // Valor adicional por combo
    switch (tipoCombo) {
      case 'Papas extra':
        valorAdicionalCombo = 0.75;
        break;
      case 'Combo completo (papas + bebida)':
        valorAdicionalCombo = 1.25;
        break;
      // 'Solo producto' no agrega valor, queda en 0.0
    }

    double precioPorUnidad = precioBase + valorAdicionalCombo;
    subtotal = precioPorUnidad * cantidad;
    iva = subtotal * 0.15; // IVA del 15%
    total = subtotal + iva;
  }
}
