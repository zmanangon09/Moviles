import 'package:flutter/material.dart';
import '../models/contacto_model.dart';
import '../services/llamada_service.dart';

// viewmodel para la pantalla de llamadas
// gestiona el estado y la logica de negocio de las llamadas (SRP)
class LlamadaViewModel extends ChangeNotifier {
  // servicio de llamadas inyectado por constructor (DIP)
  final ILlamadaService _llamadaService;

  // indica si se esta procesando una llamada
  bool _cargando = false;

  // mensaje de estado para mostrar al usuario
  String _mensajeEstado = '';

  // lista de contactos predefinidos para llamar
  final List<ContactoModel> _contactos = const [
    ContactoModel(nombre: 'Soporte tecnico', numero: '+593987654321'),
    ContactoModel(nombre: 'Emergencias', numero: '911'),
    ContactoModel(nombre: 'Informacion', numero: '104'),
    ContactoModel(nombre: 'Amigo Juan', numero: '+593991234567'),
    ContactoModel(nombre: "Zaith", numero: "+593967951982")

  ];

  // constructor que recibe el servicio mediante inyeccion de dependencias
  LlamadaViewModel({required ILlamadaService llamadaService})
      : _llamadaService = llamadaService;

  // getter para saber si hay una operacion en curso
  bool get cargando => _cargando;

  // getter para obtener el mensaje de estado actual
  String get mensajeEstado => _mensajeEstado;

  // getter para obtener la lista de contactos
  List<ContactoModel> get contactos => _contactos;

  // inicia una llamada al contacto seleccionado usando Future
  Future<void> realizarLlamada(ContactoModel contacto) async {
    // marca que se esta procesando la llamada
    _cargando = true;
    _mensajeEstado = 'iniciando llamada a ${contacto.nombre}...';
    notifyListeners();

    // llama al servicio y espera el resultado
    final exito = await _llamadaService.llamar(contacto);

    // actualiza el mensaje segun el resultado de la operacion
    _mensajeEstado = exito
        ? 'llamada a ${contacto.nombre} iniciada'
        : 'no se pudo iniciar la llamada';

    // marca que la operacion termino
    _cargando = false;
    notifyListeners();
  }
}
