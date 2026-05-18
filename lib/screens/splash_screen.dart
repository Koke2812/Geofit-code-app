import 'dart:async';
import 'dart:isolate';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:geofit/screens/home_screen.dart';
import 'package:geofit/models/app_colors.dart';
import 'package:geofit/models/app_dimensions.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
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
    iniciarCargaConHebra();
  }

  @override
  void dispose() {
    animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Center(
        child: FadeTransition(
          opacity: fadeAnim,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/geofit_256x256.png",
                height: AppDimensions.splashLogoHeight,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 30),
              const SizedBox(
                width: AppDimensions.splashLoaderSize,
                height: AppDimensions.splashLoaderSize,
                child: CircularProgressIndicator(
                  color: AppColors.primary,
                  strokeWidth: AppDimensions.splashLoaderStroke,
                ),
              ),
              const SizedBox(height: 15),
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
