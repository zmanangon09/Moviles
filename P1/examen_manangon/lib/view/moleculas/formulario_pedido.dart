import 'package:flutter/material.dart';
import '../../controller/comida_controlador.dart';
import '../atomos/boton_personalizado.dart';
import '../atomos/campos_texto_personalizado.dart';
import '../atomos/selector_simple.dart';

class FormularioPedido extends StatefulWidget {
  final ComidaControlador controlador;
  final Function(String, String, String, String) onSubmit;

  const FormularioPedido({
    super.key,
    required this.controlador,
    required this.onSubmit,
  });

  @override
  State<FormularioPedido> createState() => _FormularioPedidoState();
}

class _FormularioPedidoState extends State<FormularioPedido> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _clienteController = TextEditingController();
  final TextEditingController _cantidadController = TextEditingController();

  String _productoSeleccionado = 'Hamburguesa';
  String _comboSeleccionado = 'Solo producto';

  final List<String> productos = ['Hamburguesa', 'Salchipapa', 'Hot Dog'];
  final List<String> combos = ['Solo producto', 'Papas extra', 'Combo completo (papas + bebida)'];

  void _enviarFormulario() {
    if (_formKey.currentState!.validate()) {
      widget.onSubmit(
        _clienteController.text,
        _productoSeleccionado,
        _comboSeleccionado,
        _cantidadController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CamposTextoPersonalizado(
            label: 'Nombre del cliente',
            icon: Icons.person,
            controller: _clienteController,
            validator: widget.controlador.validarCliente,
          ),
          const SizedBox(height: 16),
          SelectorSimple(
            label: 'Producto',
            value: _productoSeleccionado,
            items: productos,
            onChanged: (val) {
              if (val != null) {
                setState(() => _productoSeleccionado = val);
              }
            },
          ),
          const SizedBox(height: 16),
          SelectorSimple(
            label: 'Tipo de combo',
            value: _comboSeleccionado,
            items: combos,
            onChanged: (val) {
              if (val != null) {
                setState(() => _comboSeleccionado = val);
              }
            },
          ),
          const SizedBox(height: 16),
          CamposTextoPersonalizado(
            label: 'Cantidad',
            icon: Icons.numbers,
            controller: _cantidadController,
            keyboardType: TextInputType.number,
            validator: widget.controlador.validarCantidad,
          ),
          const SizedBox(height: 32),
          BotonPersonalizado(
            text: 'Generar Nota de Venta',
            onPressed: _enviarFormulario,
          ),
        ],
      ),
    );
  }
}
