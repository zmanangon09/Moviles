import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../viewmodels/correo_viewmodel.dart';
import '../models/correo_model.dart';

class GmailWidget extends StatelessWidget {
  final VoidCallback onBuscarTap;
  final VoidCallback onRedactarTap;
  final VoidCallback onNoLeidosTap;
  final Function(Correo) onCorreoTap;

  const GmailWidget({
    Key? key,
    required this.onBuscarTap,
    required this.onRedactarTap,
    required this.onNoLeidosTap,
    required this.onCorreoTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<CorreoViewModel>(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        children: [
          const SizedBox(height: 20),
          // Barra de búsqueda elegante
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: GestureDetector(
              onTap: onBuscarTap,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: colorScheme.primary.withOpacity(0.1)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.search, color: colorScheme.primary),
                    const SizedBox(width: 12),
                    Text(
                      'Buscar en tu bandeja...',
                      style: GoogleFonts.lato(
                        color: colorScheme.primary.withOpacity(0.7),
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Botones de acción
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: onNoLeidosTap,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: vm.noLeidos > 0 ? colorScheme.primary : Colors.grey[200],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          vm.noLeidos > 0 ? Icons.mark_email_unread : Icons.mark_email_read,
                          color: vm.noLeidos > 0 ? Colors.white : Colors.grey[600],
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Pendientes: ${vm.noLeidos}',
                          style: GoogleFonts.lato(
                            color: vm.noLeidos > 0 ? Colors.white : Colors.grey[600],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: onRedactarTap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.secondary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  icon: const Icon(Icons.add, size: 20),
                  label: Text(
                    'Nuevo',
                    style: GoogleFonts.lato(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 15.0),
            child: Divider(indent: 20, endIndent: 20, thickness: 0.5),
          ),

          // Lista de correos
          Expanded(
            child: vm.isLoading 
              ? const Center(child: CircularProgressIndicator())
              : vm.correos.isEmpty
                ? Center(
                    child: Text(
                      'No tienes correos',
                      style: GoogleFonts.lato(color: Colors.grey),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    itemCount: vm.correos.length,
                    separatorBuilder: (context, index) => const Divider(
                      height: 1,
                      indent: 70,
                      color: Color(0xFFF1F1F1),
                    ),
                    itemBuilder: (context, index) {
                      final correo = vm.correos[index];
                      return ListTile(
                        onTap: () => onCorreoTap(correo),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                        leading: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [colorScheme.primary, colorScheme.secondary],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              correo.remitente[0].toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                        title: Text(
                          correo.remitente,
                          style: GoogleFonts.lato(
                            fontWeight: correo.noLeido ? FontWeight.w900 : FontWeight.normal,
                            fontSize: 16,
                            color: correo.noLeido ? Colors.black87 : Colors.black54,
                          ),
                        ),
                        subtitle: Text(
                          correo.asunto,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.lato(
                            fontWeight: correo.noLeido ? FontWeight.w600 : FontWeight.normal,
                            color: correo.noLeido ? Colors.black54 : Colors.grey,
                          ),
                        ),
                        trailing: correo.noLeido
                            ? Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: colorScheme.primary,
                                  shape: BoxShape.circle,
                                ),
                              )
                            : const Icon(Icons.chevron_right, color: Colors.grey, size: 16),
                      );
                    },
                  ),
          )
        ],
      ),
    );
  }
}
