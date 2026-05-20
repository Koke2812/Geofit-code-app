import 'dart:async';
import 'dart:isolate';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:geofit/screens/home_screen.dart';
import 'package:geofit/models/app_colors.dart';
import 'package:geofit/models/app_dimensions.dart';

<<<<<<< HEAD
// ─────────────────────────────────────────────
// Pantalla: Splash (carga inicial)
// ─────────────────────────────────────────────
=======
>>>>>>> dd4388feed10aea6a261b8f796f4e238ac56b83d
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
<<<<<<< HEAD
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
=======
  State<SplashScreen> createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController animController;
  late Animation<double> fadeAnim;
  String mensajeCarga = "Inicializando...";

  static int calcularCargaEnIsolate(int semilla) {
    final random = Random(semilla);
    final duracionMs = (random.nextInt(4) + 1) * 1000;
    int resultado = 0;
    final stopwatch = Stopwatch()..start();
    while (stopwatch.elapsedMilliseconds < duracionMs) {
      resultado += random.nextInt(100);
    }
    stopwatch.stop();
    return resultado;
  }

  Future<void> iniciarCargaConHebra() async {
    setState(() => mensajeCarga = "Cargando recursos...");

    final receivePort = ReceivePort();
    final isolate = await Isolate.spawn(
      (SendPort sendPort) {
        final resultado = calcularCargaEnIsolate(DateTime.now().millisecondsSinceEpoch);
        sendPort.send(resultado);
      },
      receivePort.sendPort,
    );

    await receivePort.first;
    isolate.kill(priority: Isolate.immediate);
    receivePort.close();
>>>>>>> dd4388feed10aea6a261b8f796f4e238ac56b83d

    if (mounted) {
      setState(() => mensajeCarga = "¡Listo!");
      await Future.delayed(const Duration(milliseconds: 300));
<<<<<<< HEAD

=======
>>>>>>> dd4388feed10aea6a261b8f796f4e238ac56b83d
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      }
    }
  }

<<<<<<< HEAD
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
=======
  @override
  void initState() {
    super.initState();
    animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    fadeAnim = CurvedAnimation(
      parent: animController,
      curve: Curves.easeIn,
    );
    animController.forward();
>>>>>>> dd4388feed10aea6a261b8f796f4e238ac56b83d
    iniciarCargaConHebra();
  }

  @override
  void dispose() {
<<<<<<< HEAD
    controladorAnimacion.dispose();
    super.dispose();
  }

  // ── Construcción de la interfaz ──

=======
    animController.dispose();
    super.dispose();
  }

>>>>>>> dd4388feed10aea6a261b8f796f4e238ac56b83d
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Center(
        child: FadeTransition(
<<<<<<< HEAD
          opacity: animacionOpacidad,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
=======
          opacity: fadeAnim,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
>>>>>>> dd4388feed10aea6a261b8f796f4e238ac56b83d
              Image.asset(
                "assets/images/geofit_256x256.png",
                height: AppDimensions.splashLogoHeight,
                fit: BoxFit.contain,
              ),
<<<<<<< HEAD

              const SizedBox(height: 30),

              // Indicador de carga
=======
              const SizedBox(height: 30),
>>>>>>> dd4388feed10aea6a261b8f796f4e238ac56b83d
              const SizedBox(
                width: AppDimensions.splashLoaderSize,
                height: AppDimensions.splashLoaderSize,
                child: CircularProgressIndicator(
                  color: AppColors.primary,
                  strokeWidth: AppDimensions.splashLoaderStroke,
                ),
              ),
<<<<<<< HEAD

              const SizedBox(height: 15),

              // Mensaje de carga
=======
              const SizedBox(height: 15),
>>>>>>> dd4388feed10aea6a261b8f796f4e238ac56b83d
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
