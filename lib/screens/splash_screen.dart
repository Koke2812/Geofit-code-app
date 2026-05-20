import 'dart:async';
import 'dart:isolate';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:geofit/screens/home_screen.dart';
import 'package:geofit/models/app_colors.dart';
import 'package:geofit/models/app_dimensions.dart';

// ─────────────────────────────────────────────
// Pantalla: Splash (carga inicial)
// ─────────────────────────────────────────────
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => SplashScreenEstado();
}

class SplashScreenEstado extends State<SplashScreen>
    with SingleTickerProviderStateMixin {

  // ── Animaciones ──
  late AnimationController controladorAnimacion;
  late Animation<double> animacionOpacidad;

  // ── Estado ──
  String mensajeCarga = "Inicializando...";

  // ── Método estático para ejecutar en Isolate ──

  static int calcularCargaEnIsolate(int semilla) {
    final aleatorio = Random(semilla);
    final duracionMs = (aleatorio.nextInt(4) + 1) * 1000;
    int resultado = 0;
    final cronometro = Stopwatch()..start();

    while (cronometro.elapsedMilliseconds < duracionMs) {
      resultado += aleatorio.nextInt(100);
    }

    cronometro.stop();
    return resultado;
  }

  // ── Carga asíncrona con Isolate (hebra) ──

  Future<void> iniciarCargaConHebra() async {
    setState(() => mensajeCarga = "Cargando recursos...");

    final puertoRecepcion = ReceivePort();

    final hebra = await Isolate.spawn(
      (SendPort puertoEnvio) {
        final resultado = calcularCargaEnIsolate(
          DateTime.now().millisecondsSinceEpoch,
        );
        puertoEnvio.send(resultado);
      },
      puertoRecepcion.sendPort,
    );

    await puertoRecepcion.first;
    hebra.kill(priority: Isolate.immediate);
    puertoRecepcion.close();

    if (mounted) {
      setState(() => mensajeCarga = "¡Listo!");
      await Future.delayed(const Duration(milliseconds: 300));

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      }
    }
  }

  // ── Ciclo de vida ──

  @override
  void initState() {
    super.initState();

    controladorAnimacion = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    animacionOpacidad = CurvedAnimation(
      parent: controladorAnimacion,
      curve: Curves.easeIn,
    );

    controladorAnimacion.forward();
    iniciarCargaConHebra();
  }

  @override
  void dispose() {
    controladorAnimacion.dispose();
    super.dispose();
  }

  // ── Construcción de la interfaz ──

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Center(
        child: FadeTransition(
          opacity: animacionOpacidad,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              Image.asset(
                "assets/images/geofit_256x256.png",
                height: AppDimensions.splashLogoHeight,
                fit: BoxFit.contain,
              ),

              const SizedBox(height: 30),

              // Indicador de carga
              const SizedBox(
                width: AppDimensions.splashLoaderSize,
                height: AppDimensions.splashLoaderSize,
                child: CircularProgressIndicator(
                  color: AppColors.primary,
                  strokeWidth: AppDimensions.splashLoaderStroke,
                ),
              ),

              const SizedBox(height: 15),

              // Mensaje de carga
              Text(
                mensajeCarga,
                style: const TextStyle(
                  color: AppColors.grey,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
