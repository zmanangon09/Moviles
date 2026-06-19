class Correo {
  final String id;
  final String remitente;
  final String asunto;
  final String cuerpo;
  final String fecha;
  bool noLeido;

  Correo({
    required this.id,
    required this.remitente,
    required this.asunto,
    required this.cuerpo,
    required this.fecha,
    this.noLeido = true,
  });
}