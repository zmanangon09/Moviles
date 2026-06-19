import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// pantalla de informacion sobre la aplicacion
// es stateless porque no maneja estado mutable
class InfoView extends StatelessWidget {
  const InfoView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A),

      appBar: AppBar(
        title: Text(
          'Informacion',
          style: GoogleFonts.lora(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF0D1B2A),
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF4FC3F7)),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // logo de la aplicacion
            Container(
              margin: const EdgeInsets.symmetric(vertical: 24),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF1B2A3D),
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFF4FC3F7).withValues(alpha: 0.4),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF4FC3F7).withValues(alpha: 0.15),
                    blurRadius: 20,
                    spreadRadius: 4,
                  ),
                ],
              ),
              child: const Icon(
                Icons.info_rounded,
                size: 64,
                color: Color(0xFF4FC3F7),
              ),
            ),

            // nombre de la aplicacion
            Text(
              'Comunicaciones App',
              style: GoogleFonts.lora(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 8),

            // version de la aplicacion
            Text(
              'Version 1.0.0',
              style: GoogleFonts.lora(
                fontSize: 14,
                color: const Color(0xFF90CAF9),
                fontStyle: FontStyle.italic,
              ),
            ),

            const SizedBox(height: 32),

            // tarjetas con informacion sobre las funcionalidades
            _buildSeccionInfo(
              titulo: 'Llamadas Telefonicas',
              descripcion:
                  'Realiza llamadas directamente desde la aplicacion usando la app nativa del dispositivo. Selecciona un contacto y pulsa el boton de llamada.',
              icono: Icons.phone_rounded,
            ),

            const SizedBox(height: 16),

            _buildSeccionInfo(
              titulo: 'Correo Electronico',
              descripcion:
                  'Abre tu aplicacion de correo favorita con el destinatario, asunto y mensaje pre-rellenados. Compatible con Gmail, Outlook y mas.',
              icono: Icons.email_rounded,
            ),

            const SizedBox(height: 16),

            // tarjeta de tecnologias usadas
            _buildSeccionInfo(
              titulo: 'Tecnologias Usadas',
              descripcion:
                  'Flutter · url_launcher · google_fonts\nArquitectura MVVM · Principios SOLID\nNavegacion con pushNamed',
              icono: Icons.code_rounded,
            ),

            const SizedBox(height: 32),

            // pie de pagina con autor
            Text(
              'Desarrollado con Flutter',
              style: GoogleFonts.lora(
                fontSize: 13,
                color: const Color(0xFF546E7A),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // widget privado que construye una tarjeta de informacion
  Widget _buildSeccionInfo({
    required String titulo,
    required String descripcion,
    required IconData icono,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1B2A3D),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF4FC3F7).withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // icono de la seccion
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF4FC3F7).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icono, color: const Color(0xFF4FC3F7), size: 24),
          ),

          const SizedBox(width: 16),

          // textos de la seccion
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: GoogleFonts.lora(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  descripcion,
                  style: GoogleFonts.lora(
                    fontSize: 13,
                    color: const Color(0xFF90CAF9),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
