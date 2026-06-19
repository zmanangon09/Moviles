import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'viewmodels/correo_viewmodel.dart';
import 'views/home_page.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => CorreoViewModel(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gmail Clone',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFB3E5FC), // Celeste
          primary: const Color(0xFF0288D1),
          secondary: const Color(0xFF03A9F4),
          surface: Colors.white,
        ),
        textTheme: GoogleFonts.latoTextTheme(
          Theme.of(context).textTheme,
        ).copyWith(
          titleLarge: GoogleFonts.playfairDisplay(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: const Color(0xFF01579B),
          ),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: GoogleFonts.playfairDisplay(
            color: const Color(0xFF01579B),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: const IconThemeData(color: Color(0xFF01579B)),
        ),
      ),
      home: HomePage(),
    );
  }
}
