import 'package:flutter/material.dart';
import '../models/correo_model.dart';
import '../services/correo_service.dart';

// viewmodel para la pantalla de correo electronico
// gestiona el estado y la logica de envio de correos (SRP)
class CorreoViewModel extends ChangeNotifier {
  // servicio de correo inyectado por constructor (DIP)
  final ICorreoService _correoService;

  // indica si hay una operacion en curso
  bool _cargando = false;

  // mensaje de estado actual para el usuario
  String _mensajeEstado = '';

  // controladores de texto para los campos del formulario
  final TextEditingController destinatarioController = TextEditingController();
  final TextEditingController asuntoController = TextEditingController();
  final TextEditingController cuerpoController = TextEditingController();

  // constructor que recibe el servicio mediante inyeccion de dependencias
  CorreoViewModel({required ICorreoService correoService})
      : _correoService = correoService;

  // getter para saber si hay una operacion en curso
  bool get cargando => _cargando;

  // getter para el mensaje de estado actual
  String get mensajeEstado => _mensajeEstado;

  // abre la app de correo con los datos ingresados en el formulario usando Future
  Future<void> abrirCorreo() async {
    // valida que el destinatario no este vacio
    if (destinatarioController.text.trim().isEmpty) {
      _mensajeEstado = 'ingresa un destinatario valido';
      notifyListeners();
      return;
    }

    // crea el modelo con los datos del formulario
    final correo = CorreoModel(
      destinatario: destinatarioController.text.trim(),
      asunto: asuntoController.text.trim(),
      cuerpo: cuerpoController.text.trim(),
    );

    // marca que la operacion esta en curso
    _cargando = true;
    _mensajeEstado = 'abriendo app de correo...';
    notifyListeners();

    // llama al servicio y espera el resultado
    final exito = await _correoService.enviarCorreo(correo);

    // actualiza el mensaje segun el resultado
    _mensajeEstado = exito
        ? 'app de correo abierta correctamente'
        : 'no se pudo abrir la app de correo';

    // marca que la operacion termino
    _cargando = false;
    notifyListeners();
  }

  // limpia los campos del formulario
  void limpiarCampos() {
    destinatarioController.clear();
    asuntoController.clear();
    cuerpoController.clear();
    _mensajeEstado = '';
    notifyListeners();
  }

  // libera los recursos de los controladores al destruir el viewmodel
  @override
  void dispose() {
    destinatarioController.dispose();
    asuntoController.dispose();
    cuerpoController.dispose();
    super.dispose();
  }
}
