import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../viewmodels/correo_viewmodel.dart';
import '../widgets/gmail_widget.dart';
import '../models/correo_model.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<CorreoViewModel>(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: const Color(0xFFF0F9FF),
      appBar: AppBar(
        title: Text(
          'Andys Mail',
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        actions: [
          if (vm.currentUser != null) ...[
            IconButton(
              icon: const Icon(Icons.refresh_rounded),
              onPressed: () => vm.fetchEmails(),
            ),
            IconButton(
              icon: const Icon(Icons.logout_rounded),
              onPressed: () => vm.handleSignOut(),
            ),
          ],
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: vm.currentUser == null
            ? _buildSignInScreen(context, vm)
            : Column(
                children: [
                  Expanded(
                    child: GmailWidget(
                      onBuscarTap: () => _mostrarBuscador(context),
                      onRedactarTap: () => _mostrarRedactar(context),
                      onNoLeidosTap: () => vm.marcarTodosLeidos(),
                      onCorreoTap: (correo) => _mostrarDetalleCorreo(context, correo),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  void _mostrarDetalleCorreo(BuildContext context, Correo correo) {
    final vm = Provider.of<CorreoViewModel>(context, listen: false);
    
    // Marcar como leído al abrir
    if (correo.noLeido) {
      vm.marcarLeido(correo.id);
    }

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: () async {
                  final success = await vm.eliminarCorreo(correo.id);
                  if (success) {
                    Navigator.pop(context); // Cerrar detalle
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Correo movido a la papelera'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                },
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  correo.asunto,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 25),
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      child: Text(correo.remitente[0].toUpperCase(), style: const TextStyle(color: Colors.white)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            correo.remitente,
                            style: GoogleFonts.lato(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          Text(
                            'para mí',
                            style: GoogleFonts.lato(color: Colors.grey, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      correo.fecha.contains(',') ? correo.fecha.split(',').first : correo.fecha,
                      style: GoogleFonts.lato(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Text(
                  correo.cuerpo,
                  style: GoogleFonts.lato(
                    fontSize: 16,
                    height: 1.6,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSignInScreen(BuildContext context, CorreoViewModel vm) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.email_outlined, size: 100, color: colorScheme.primary),
            const SizedBox(height: 30),
            Text(
              'Bienvenido a tu correo',
              style: GoogleFonts.playfairDisplay(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 15),
            Text(
              'Conecta tu cuenta de Gmail para empezar a gestionar tus mensajes con elegancia.',
              style: GoogleFonts.lato(fontSize: 16, color: Colors.black54),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: () => vm.handleSignIn(),
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              icon: const Icon(Icons.login),
              label: Text(
                'Iniciar sesión con Google',
                style: GoogleFonts.lato(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _mostrarBuscador(BuildContext context) {
    final vm = Provider.of<CorreoViewModel>(context, listen: false);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              autofocus: true,
              onChanged: (value) => vm.setSearchQuery(value),
              decoration: InputDecoration(
                hintText: 'Buscar por remitente o asunto...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    vm.setSearchQuery('');
                    Navigator.pop(context);
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                filled: true,
                fillColor: Colors.grey[50],
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'La lista se filtrará automáticamente',
              style: GoogleFonts.lato(fontSize: 12, color: Colors.grey),
            )
          ],
        ),
      ),
    );
  }

  void _mostrarRedactar(BuildContext context) {
    final vm = Provider.of<CorreoViewModel>(context, listen: false);
    final toController = TextEditingController();
    final subjectController = TextEditingController();
    final bodyController = TextEditingController();

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Nuevo Mensaje', style: GoogleFonts.playfairDisplay(fontWeight: FontWeight.bold)),
            leading: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.send_rounded, color: Color(0xFF0288D1)),
                onPressed: () async {
                  if (toController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Por favor, ingresa un destinatario')),
                    );
                    return;
                  }

                  // Mostrar indicador de carga
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => const Center(child: CircularProgressIndicator()),
                  );

                  final success = await vm.sendEmail(
                    toController.text,
                    subjectController.text,
                    bodyController.text,
                  );

                  Navigator.pop(context); // Quitar el progress indicator

                  if (success) {
                    Navigator.pop(context); // Cerrar pantalla de redactar
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Mensaje enviado con éxito'),
                        backgroundColor: Colors.green[700],
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Error al enviar el mensaje. Revisa los permisos.'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                TextField(
                  controller: toController,
                  decoration: InputDecoration(
                    labelText: 'Para',
                    labelStyle: GoogleFonts.lato(color: Colors.grey),
                    focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF0288D1))),
                  ),
                  style: GoogleFonts.lato(),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: subjectController,
                  decoration: InputDecoration(
                    labelText: 'Asunto',
                    labelStyle: GoogleFonts.lato(color: Colors.grey),
                    focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF0288D1))),
                  ),
                  style: GoogleFonts.lato(),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: TextField(
                    controller: bodyController,
                    maxLines: null,
                    expands: true,
                    textAlignVertical: TextAlignVertical.top,
                    decoration: InputDecoration(
                      hintText: 'Escribe tu mensaje aquí...',
                      hintStyle: GoogleFonts.lato(color: Colors.grey[400]),
                      border: InputBorder.none,
                    ),
                    style: GoogleFonts.lato(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
