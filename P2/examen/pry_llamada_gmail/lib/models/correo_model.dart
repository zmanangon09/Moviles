// modelo que representa un correo electronico con sus campos basicos
class CorreoModel {
  // direccion de correo del destinatario
  final String destinatario;

  // asunto del correo
  final String asunto;

  // cuerpo o contenido del correo
  final String cuerpo;

  // constructor con parametros requeridos
  const CorreoModel({
    required this.destinatario,
    required this.asunto,
    required this.cuerpo,
  });
}
