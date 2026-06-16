import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import '../models/contacto_model.dart';

// contrato (interfaz) que define la operacion de llamada telefonica
// principio de inversion de dependencias (DIP)
abstract class ILlamadaService {
  // lanza una llamada al numero del contacto dado
  // retorna true si se pudo lanzar, false en caso contrario
  Future<bool> llamar(ContactoModel contacto);
}

// implementacion concreta del servicio de llamadas
// usa flutter_phone_direct_caller para realizar la llamada directamente
class LlamadaService implements ILlamadaService {
  // realiza la llamada directa sin pasar por el marcador
  @override
  Future<bool> llamar(ContactoModel contacto) async {
    // intenta realizar la llamada directa
    final exito = await FlutterPhoneDirectCaller.callNumber(contacto.numero);
    
    // retorna el resultado de la operacion (true si se pudo iniciar, false caso contrario)
    return exito ?? false;
  }
}
