import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geofit/l10n/app_localizations.dart';
import 'package:geofit/models/app_colors.dart';
import 'package:geofit/models/app_dimensions.dart';

class MoneyScreen extends StatefulWidget {
  const MoneyScreen({super.key});
  @override
  State<MoneyScreen> createState() => MoneyScreenState();
}

class MoneyScreenState extends State<MoneyScreen> {
  final controller = TextEditingController();

  void mostrarSnackBar(String mensaje, {Color color = AppColors.error}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(children: [const Icon(Icons.warning_amber_rounded, color: AppColors.white, size: 20), const SizedBox(width: AppDimensions.paddingSmall), Expanded(child: Text(mensaje))]),
      backgroundColor: color, behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusSmall)),
      margin: const EdgeInsets.all(AppDimensions.snackBarMargin), duration: const Duration(seconds: 3)));
  }

  void confirmarIngreso() {
    final t = AppLocalizations.of(context)!;
    final texto = controller.text.trim();
    if (texto.isEmpty) { mostrarSnackBar(t.enterAmount); return; }
    final valor = double.tryParse(texto);
    if (valor == null) { mostrarSnackBar(t.onlyNumbers); return; }
    if (valor < 0) { mostrarSnackBar(t.noNegative); return; }
    if (valor == 0) { mostrarSnackBar(t.mustBeGreaterZero); return; }
    if (valor > AppDimensions.maxMoney) { mostrarSnackBar(t.maxAmount); return; }
    Navigator.pop(context, valor);
  }

  @override
  void dispose() { controller.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(t.depositTitle)),
      body: Padding(padding: const EdgeInsets.all(AppDimensions.paddingBody), child: Column(children: [
        TextField(controller: controller, keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
          decoration: InputDecoration(labelText: t.amountEuro, border: const OutlineInputBorder())),
        const SizedBox(height: 20),
        ElevatedButton(onPressed: confirmarIngreso, child: Text(t.confirm)),
      ])),
    );
  }
}
