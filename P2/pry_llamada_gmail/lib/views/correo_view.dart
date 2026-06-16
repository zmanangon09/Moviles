import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../viewmodels/correo_viewmodel.dart';
import '../services/correo_service.dart';

// pantalla de envio de correo electronico
// es stateful porque maneja los controladores y el estado del viewmodel
class CorreoView extends StatefulWidget {
  const CorreoView({super.key});

  @override
  State<CorreoView> createState() => _CorreoViewState();
}

class _CorreoViewState extends State<CorreoView> {
  // viewmodel que gestiona la logica del correo con su servicio inyectado
  late final CorreoViewModel _viewModel;

  // llave para validar el formulario
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    // crea el viewmodel inyectando el servicio concreto (DIP)
    _viewModel = CorreoViewModel(
      correoService: CorreoService(),
    );

    // escucha los cambios del viewmodel para actualizar la ui
    _viewModel.addListener(_alActualizar);
  }

  // callback que reconstruye la ui cuando el viewmodel cambia
  void _alActualizar() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    // elimina el listener y libera recursos
    _viewModel.removeListener(_alActualizar);
    _viewModel.dispose();
    super.dispose();
  }

  // valida el formulario y llama al viewmodel para abrir el correo
  Future<void> _alEnviarCorreo() async {
    // valida los campos del formulario antes de continuar
    if (_formKey.currentState?.validate() ?? false) {
      await _viewModel.abrirCorreo();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A),

      appBar: AppBar(
        title: Text(
          'Correo Electronico',
          style: GoogleFonts.lora(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF0D1B2A),
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF4FC3F7)),
        centerTitle: true,

        // boton para limpiar el formulario
        actions: [
          IconButton(
            onPressed: _viewModel.limpiarCampos,
            icon: const Icon(Icons.clear_all_rounded),
            color: const Color(0xFF4FC3F7),
            tooltip: 'limpiar campos',
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // icono decorativo de correo
              Center(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4FC3F7).withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF4FC3F7).withValues(alpha: 0.4),
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Icons.email_rounded,
                    size: 48,
                    color: Color(0xFF4FC3F7),
                  ),
                ),
              ),

              // campo de destinatario
              _buildCampoTexto(
                controlador: _viewModel.destinatarioController,
                etiqueta: 'Destinatario',
                icono: Icons.person_rounded,
                tipo: TextInputType.emailAddress,
                validador: (valor) {
                  if (valor == null || valor.trim().isEmpty) {
                    return 'el destinatario es obligatorio';
                  }
                  if (!valor.contains('@')) {
                    return 'ingresa un correo valido';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // campo de asunto
              _buildCampoTexto(
                controlador: _viewModel.asuntoController,
                etiqueta: 'Asunto',
                icono: Icons.subject_rounded,
                tipo: TextInputType.text,
                validador: null,
              ),

              const SizedBox(height: 16),

              // campo del cuerpo del correo con multiples lineas
              _buildCampoTexto(
                controlador: _viewModel.cuerpoController,
                etiqueta: 'Mensaje',
                icono: Icons.message_rounded,
                tipo: TextInputType.multiline,
                maxLineas: 5,
                validador: null,
              ),

              const SizedBox(height: 24),

              // mensaje de estado del viewmodel
              if (_viewModel.mensajeEstado.isNotEmpty)
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1B2A3D),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFF4FC3F7).withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    _viewModel.mensajeEstado,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lora(
                      color: const Color(0xFF90CAF9),
                      fontSize: 13,
                    ),
                  ),
                ),

              // boton principal para abrir el correo
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: _viewModel.cargando ? null : _alEnviarCorreo,
                  icon: _viewModel.cargando
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(Icons.send_rounded),
                  label: Text(
                    _viewModel.cargando ? 'abriendo...' : 'Abrir App de Correo',
                    style: GoogleFonts.lora(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1565C0),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                    shadowColor: const Color(0xFF4FC3F7).withValues(alpha: 0.3),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // widget privado que construye un campo de texto con estilo consistente
  Widget _buildCampoTexto({
    required TextEditingController controlador,
    required String etiqueta,
    required IconData icono,
    required TextInputType tipo,
    int maxLineas = 1,
    String? Function(String?)? validador,
  }) {
    return TextFormField(
      controller: controlador,
      keyboardType: tipo,
      maxLines: maxLineas,
      style: GoogleFonts.lora(color: Colors.white),
      validator: validador,
      decoration: InputDecoration(
        labelText: etiqueta,
        labelStyle: GoogleFonts.lora(color: const Color(0xFF90CAF9)),
        prefixIcon: Icon(icono, color: const Color(0xFF4FC3F7)),
        filled: true,
        fillColor: const Color(0xFF1B2A3D),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: const Color(0xFF4FC3F7).withValues(alpha: 0.2),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color(0xFF4FC3F7),
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent, width: 2),
        ),
        errorStyle: GoogleFonts.lora(color: Colors.redAccent),
      ),
    );
  }
}
