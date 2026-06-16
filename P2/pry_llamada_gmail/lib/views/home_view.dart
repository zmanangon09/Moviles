import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// pantalla de inicio que actua como contenedor del BottomNavigationBar
// es stateful porque gestiona el indice de la pestaña activa
class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  // indice de la pestaña actualmente seleccionada
  int _indiceActual = 0;

  // lista de rutas nombradas para cada pestaña del navigation bar
  static const List<String> _rutas = [
    '/inicio',
    '/llamadas',
    '/correo',
    '/info',
  ];

  // navega a la ruta correspondiente usando pushNamed
  void _alCambiarPestana(int indice) {
    if (indice == _indiceActual) return;

    setState(() {
      _indiceActual = indice;
    });

    // navega usando pushNamed para mantener el historial de navegacion
    Navigator.pushNamed(context, _rutas[indice]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // barra de navegacion inferior con 4 opciones
      bottomNavigationBar: BottomNavigationBar(
        // indice de la pestaña activa
        currentIndex: _indiceActual,

        // callback cuando el usuario toca una pestaña
        onTap: _alCambiarPestana,

        // tipo fixed para mostrar todas las etiquetas visibles
        type: BottomNavigationBarType.fixed,

        // colores de azul marino para la paleta
        backgroundColor: const Color(0xFF0D1B2A),
        selectedItemColor: const Color(0xFF4FC3F7),
        unselectedItemColor: const Color(0xFF546E7A),

        // estilo de etiquetas con fuente Lora
        selectedLabelStyle: GoogleFonts.lora(
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.lora(fontSize: 10),

        // las 4 pestanas de navegacion
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.phone_rounded),
            label: 'Llamadas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.email_rounded),
            label: 'Correo',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info_rounded),
            label: 'Info',
          ),
        ],
      ),

      // cuerpo de la pantalla de inicio con bienvenida
      body: Container(
        // gradiente de fondo en azul marino
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0D1B2A),
              Color(0xFF1B2A3D),
              Color(0xFF0A3055),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // icono principal de la aplicacion
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4FC3F7).withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF4FC3F7).withValues(alpha: 0.4),
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Icons.smartphone_rounded,
                    size: 64,
                    color: Color(0xFF4FC3F7),
                  ),
                ),

                const SizedBox(height: 32),

                // titulo de bienvenida con fuente Lora
                Text(
                  'MAIL & CALL',
                  style: GoogleFonts.lora(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.2,
                  ),
                ),

                const SizedBox(height: 8),

                // subtitulo descriptivo
                Text(
                  'Llamadas y correo desde un solo lugar',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lora(
                    fontSize: 14,
                    color: const Color(0xFF90CAF9),
                    fontStyle: FontStyle.italic,
                  ),
                ),

                const SizedBox(height: 48),

                // tarjeta de acceso rapido a llamadas
                _buildTarjetaAcceso(
                  context,
                  icono: Icons.phone_rounded,
                  titulo: 'Realizar Llamadas',
                  descripcion: 'Llama a tus contactos rapidamente',
                  ruta: '/llamadas',
                ),

                const SizedBox(height: 16),

                // tarjeta de acceso rapido a correo
                _buildTarjetaAcceso(
                  context,
                  icono: Icons.email_rounded,
                  titulo: 'Enviar Correo',
                  descripcion: 'Abre tu app de correo electronico',
                  ruta: '/correo',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // widget privado que construye una tarjeta de acceso rapido
  Widget _buildTarjetaAcceso(
    BuildContext context, {
    required IconData icono,
    required String titulo,
    required String descripcion,
    required String ruta,
  }) {
    return GestureDetector(
      // navega a la ruta usando pushNamed al tocar la tarjeta
      onTap: () => Navigator.pushNamed(context, ruta),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 32),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF1B2A3D),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFF4FC3F7).withValues(alpha: 0.3),
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF4FC3F7).withValues(alpha: 0.1),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // icono de la tarjeta
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF4FC3F7).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icono, color: const Color(0xFF4FC3F7), size: 28),
            ),

            const SizedBox(width: 16),

            // textos de titulo y descripcion
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    style: GoogleFonts.lora(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    descripcion,
                    style: GoogleFonts.lora(
                      fontSize: 12,
                      color: const Color(0xFF90CAF9),
                    ),
                  ),
                ],
              ),
            ),

            // flecha indicadora de navegacion
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Color(0xFF4FC3F7),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
