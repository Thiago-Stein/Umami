import 'package:flutter/material.dart';
import 'Cores.dart';
import 'PaginaPrincipal.dart';

class Principal extends StatelessWidget {
  const Principal({super.key});

  @override
  Widget build(BuildContext context) {
    final formaBotao = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    );

    return MaterialApp(
      title: 'Umami',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Cores.fundo,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Cores.vinho,
          primary: Cores.vinho,
          onPrimary: Colors.white,
          secondary: Cores.vinhoEscuro,
          tertiary: Cores.vermelhoVivo,
          error: Cores.vermelhoEscuro,
          surface: Cores.fundo,
        ),
        dividerTheme: const DividerThemeData(color: Cores.borda, thickness: 1),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: Cores.vinho,
            foregroundColor: Colors.white,
            overlayColor: Cores.vinhoEscuro,
            minimumSize: const Size.fromHeight(52),
            shape: formaBotao,
            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: Cores.vinho,
            overlayColor: Cores.vinhoEscuro,
            side: const BorderSide(color: Cores.vinho, width: 1.5),
            minimumSize: const Size.fromHeight(52),
            shape: formaBotao,
            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
        ),
        navigationBarTheme: const NavigationBarThemeData(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          indicatorColor: Cores.destaqueSuave,
        ),
      ),
      home: const PaginaPrincipal(),
    );
  }
}