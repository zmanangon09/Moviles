import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/contacto_model.dart';
import '../viewmodels/llamada_viewmodel.dart';
import '../services/llamada_service.dart';

// pantalla de llamadas telefonicas
// es stateful porque escucha los cambios del viewmodel
class LlamadaView extends StatefulWidget {
  const LlamadaView({super.key});

  @override
  State<LlamadaView> createState() => _LlamadaViewState();
}

class _LlamadaViewState extends State<LlamadaView> {
  // viewmodel que gestiona la logica de llamadas con su servicio inyectado
  late final LlamadaViewModel _viewModel;

  @override
  void initState() {
    super.initState();

    // crea el viewmodel inyectando el servicio concreto (DIP)
    _viewModel = LlamadaViewModel(
      llamadaService: LlamadaService(),
    );

    // escucha los cambios del viewmodel para reconstruir la ui
    _viewModel.addListener(_alActualizar);
  }

  // callback que llama a setState cuando el viewmodel notifica cambios
  void _alActualizar() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    // elimina el listener y libera recursos al destruir el widget
    _viewModel.removeListener(_alActualizar);
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // fondo con gradiente azul marino
      backgroundColor: const Color(0xFF0D1B2A),

      appBar: AppBar(
        // barra superior con titulo en fuente Lora
        title: Text(
          'Llamadas',
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

      body: Column(
        children: [
          // indicador de carga o mensaje de estado
          _buildEncabezado(),

          // lista de contactos disponibles para llamar
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _viewModel.contactos.length,
              itemBuilder: (context, indice) {
                final contacto = _viewModel.contactos[indice];
                return _buildTarjetaContacto(contacto);
              },
            ),
          ),
        ],
      ),
    );
  }

  // construye el encabezado con estado de la llamada actual
  Widget _buildEncabezado() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1B2A3D),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF4FC3F7).withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          // icono de telefono animado
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF4FC3F7).withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _viewModel.cargando
                  ? Icons.phone_in_talk_rounded
                  : Icons.phone_rounded,
              color: const Color(0xFF4FC3F7),
              size: 24,
            ),
          ),

          const SizedBox(width: 12),

          // texto de estado o instruccion
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Estado de llamada',
                  style: GoogleFonts.lora(
                    fontSize: 12,
                    color: const Color(0xFF90CAF9),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _viewModel.mensajeEstado.isEmpty
                      ? 'selecciona un contacto para llamar'
                      : _viewModel.mensajeEstado,
                  style: GoogleFonts.lora(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // indicador de carga cuando hay una llamada en proceso
          if (_viewModel.cargando)
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                color: Color(0xFF4FC3F7),
                strokeWidth: 2,
              ),
            ),
        ],
      ),
    );
  }

  // construye la tarjeta de un contacto con boton de llamada
  Widget _buildTarjetaContacto(ContactoModel contacto) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1B2A3D),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF4FC3F7).withValues(alpha: 0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),

        // avatar del contacto con inicial del nombre
        leading: CircleAvatar(
          backgroundColor: const Color(0xFF4FC3F7).withValues(alpha: 0.2),
          child: Text(
            contacto.nombre[0].toUpperCase(),
            style: GoogleFonts.lora(
              color: const Color(0xFF4FC3F7),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        // nombre del contacto
        title: Text(
          contacto.nombre,
          style: GoogleFonts.lora(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),

        // numero de telefono del contacto
        subtitle: Text(
          contacto.numero,
          style: GoogleFonts.lora(
            color: const Color(0xFF90CAF9),
            fontSize: 13,
          ),
        ),

        // boton de llamada que usa el viewmodel con Future
        trailing: IconButton(
          onPressed: _viewModel.cargando
              ? null
              : () => _viewModel.realizarLlamada(contacto),
          icon: const Icon(Icons.call_rounded),
          color: const Color(0xFF4FC3F7),
          style: IconButton.styleFrom(
            backgroundColor: const Color(0xFF4FC3F7).withValues(alpha: 0.15),
          ),
        ),
      ),
    );
  }
}
