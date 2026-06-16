import 'package:url_launcher/url_launcher.dart';
import '../models/correo_model.dart';

// contrato (interfaz) para el servicio de correo electronico
// principio de inversion de dependencias (DIP)
abstract class ICorreoService {
  // abre la aplicacion de correo con los datos del modelo
  // retorna true si se pudo abrir, false si no
  Future<bool> enviarCorreo(CorreoModel correo);
}

// implementacion concreta del servicio de correo
// usa url_launcher con el esquema mailto: para abrir la app nativa
class CorreoService implements ICorreoService {
  // abre la app de correo del dispositivo con destinatario, asunto y cuerpo
  @override
  Future<bool> enviarCorreo(CorreoModel correo) async {
    // construye la uri con el esquema mailto: y los parametros del correo
    final uri = Uri(
      scheme: 'mailto',
      path: correo.destinatario,
      queryParameters: {
        'subject': correo.asunto,
        'body': correo.cuerpo,
      },
    );

    // verifica si el dispositivo puede manejar el esquema mailto
    final puedeAbrir = await canLaunchUrl(uri);

    if (puedeAbrir) {
      // lanza la aplicacion de correo nativa
      return launchUrl(uri);
    }

    // retorna false si no hay app de correo disponible
    return false;
  }
}
