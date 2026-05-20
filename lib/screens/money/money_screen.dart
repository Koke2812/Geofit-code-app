import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geofit/l10n/app_localizations.dart';
import 'package:geofit/models/app_colors.dart';
import 'package:geofit/models/app_dimensions.dart';

// ─────────────────────────────────────────────
// Pantalla: Ingresar dinero
// ─────────────────────────────────────────────
class MoneyScreen extends StatefulWidget {
  const MoneyScreen({super.key});

  @override
  State<MoneyScreen> createState() => MoneyScreenEstado();
}

class MoneyScreenEstado extends State<MoneyScreen> {
  // ── Controlador de texto ──
  final controladorCantidad = TextEditingController();

  // ── SnackBar personalizado ──

  void mostrarSnackBar(String mensaje, {Color color = AppColors.error}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: AppColors.white, size: 20),
            const SizedBox(width: AppDimensions.paddingSmall),
            Expanded(child: Text(mensaje)),
          ],
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
        ),
        margin: const EdgeInsets.all(AppDimensions.snackBarMargin),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // ── Lógica de confirmación ──

  void confirmarIngreso() {
    final traducciones = AppLocalizations.of(context)!;
    final texto = controladorCantidad.text.trim();

    if (texto.isEmpty) {
      mostrarSnackBar(traducciones.enterAmount);
      return;
    }

    final valor = double.tryParse(texto);

    if (valor == null) {
      mostrarSnackBar(traducciones.onlyNumbers);
      return;
    }
    if (valor < 0) {
      mostrarSnackBar(traducciones.noNegative);
      return;
    }
    if (valor == 0) {
      mostrarSnackBar(traducciones.mustBeGreaterZero);
      return;
    }
    if (valor > AppDimensions.maxMoney) {
      mostrarSnackBar(traducciones.maxAmount);
      return;
    }

    Navigator.pop(context, valor);
  }

  // ── Ciclo de vida ──

  @override
  void dispose() {
    controladorCantidad.dispose();
    super.dispose();
  }

  // ── Construcción de la interfaz ──

  @override
  Widget build(BuildContext context) {
    final traducciones = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(traducciones.depositTitle)),
      body: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingBody),
        child: Column(
          children: [
            // Campo de cantidad
            TextField(
              controller: controladorCantidad,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
              decoration: InputDecoration(
                labelText: traducciones.amountEuro,
                border: const OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            // Botón confirmar
            ElevatedButton(
              onPressed: confirmarIngreso,
              child: Text(traducciones.confirm),
            ),
          ],
        ),
      ),
    );
  }
}
