import 'package:flutter/material.dart';
import 'package:geofit/l10n/app_localizations.dart';
import 'package:geofit/models/usuario.dart';
import 'package:geofit/models/info_dieta.dart';
import 'package:geofit/models/dieta_generator.dart';
import 'package:geofit/models/app_colors.dart';
import 'package:geofit/models/app_dimensions.dart';
import 'package:geofit/models/app_text_styles.dart';
import 'package:geofit/database/daos/info_dieta_dao.dart';
import 'package:geofit/screens/options/diet_result_screen.dart';

class DietScreen extends StatefulWidget {
  final Usuario? usuario;
  const DietScreen({super.key, this.usuario});
  @override
  State<DietScreen> createState() => DietScreenState();
}

class DietScreenState extends State<DietScreen> {
  String genero = 'HOMBRE';
  double altura = 175;
  int peso = 80;
  int edad = 30;
  bool mostrarSegundaFase = false;
  String? nivelActividad;
  String? objetivo;
  final InfoDisenoDietaDAO infoDietaDAO = InfoDisenoDietaDAO();

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(backgroundColor: AppColors.white, elevation: 0,
        title: Text(t.dietConfig, style: AppTextStyles.appBarTitle), centerTitle: true,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios, color: AppColors.primary),
          onPressed: () { if (mostrarSegundaFase) { setState(() => mostrarSegundaFase = false); } else { Navigator.pop(context); } })),
      body: Column(children: [
        Expanded(child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(children: [
            !mostrarSegundaFase ? buildFase1(t) : buildFase2(t),
            const SizedBox(height: 20),
            buildBottomButton(t),
            const SizedBox(height: 20),
          ]))),
      ]),
    );
  }

  Widget buildFase1(AppLocalizations t) {
    return Column(children: [
      Row(children: [
        Expanded(child: cardGenero(t.male, Icons.male, 'HOMBRE')),
        const SizedBox(width: 15),
        Expanded(child: cardGenero(t.female, Icons.female, 'MUJER')),
      ]),
      const SizedBox(height: 20),
      cardAltura(t),
      const SizedBox(height: 20),
      Row(children: [
        Expanded(child: cardIncrementar(t.weight, peso, (v) => setState(() => peso = v))),
        const SizedBox(width: 15),
        Expanded(child: cardIncrementar(t.age, edad, (v) => setState(() => edad = v))),
      ]),
    ]);
  }

  Widget buildFase2(AppLocalizations t) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const SizedBox(height: 20),
      Text(t.lastSteps, style: AppTextStyles.heading),
      Text(t.customizeEffort),
      const SizedBox(height: 30),
      cardSelector(t.activityLevel, Icons.directions_run,
          [t.days12, t.days34, t.days4plus], nivelActividad,
          (val) => setState(() => nivelActividad = val), t),
      const SizedBox(height: 20),
      cardSelector(t.yourGoal, Icons.track_changes,
          [t.loseWeight, t.gainWeight, t.maintainWeight], objetivo,
          (val) => setState(() => objetivo = val), t),
    ]);
  }

  Widget cardGenero(String label, IconData icon, String valor) {
    bool activo = genero == valor;
    return GestureDetector(
      onTap: () => setState(() => genero = valor),
      child: Container(height: AppDimensions.menuCardHeight,
        decoration: BoxDecoration(color: activo ? AppColors.primary.withValues(alpha: 0.1) : AppColors.greyLight,
          borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
          border: Border.all(color: activo ? AppColors.primary : Colors.transparent, width: AppDimensions.borderWidth)),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(icon, size: 60, color: activo ? AppColors.primary : AppColors.greyText),
          Text(label, style: TextStyle(color: activo ? AppColors.primary : AppColors.greyDark, fontWeight: FontWeight.bold)),
        ])),
    );
  }

  Widget cardAltura(AppLocalizations t) {
    return Container(padding: const EdgeInsets.all(AppDimensions.paddingLarge),
      decoration: BoxDecoration(color: AppColors.greyLight, borderRadius: BorderRadius.circular(AppDimensions.radiusLarge)),
      child: Column(children: [
        Text(t.height, style: const TextStyle(color: AppColors.grey, fontWeight: FontWeight.bold)),
        Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.baseline, textBaseline: TextBaseline.alphabetic, children: [
          Text("${altura.toInt()}", style: const TextStyle(fontSize: 45, fontWeight: FontWeight.bold)),
          Text(" ${t.cm}", style: const TextStyle(color: AppColors.grey, fontWeight: FontWeight.bold)),
        ]),
        Slider(value: altura, min: 100, max: 230, activeColor: AppColors.primary,
          inactiveColor: AppColors.primary.withValues(alpha: 0.2),
          onChanged: (val) => setState(() => altura = val)),
      ]));
  }

  Widget cardIncrementar(String label, int valor, Function(int) onUpdate) {
    return Container(padding: const EdgeInsets.all(AppDimensions.paddingLarge),
      decoration: BoxDecoration(color: AppColors.greyLight, borderRadius: BorderRadius.circular(AppDimensions.radiusLarge)),
      child: Column(children: [
        Text(label, style: const TextStyle(color: AppColors.grey, fontWeight: FontWeight.bold)),
        Text("$valor", style: const TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          btnCircular(Icons.remove, () => onUpdate(valor - 1)),
          const SizedBox(width: 15),
          btnCircular(Icons.add, () => onUpdate(valor + 1)),
        ]),
      ]));
  }

  Widget btnCircular(IconData icon, VoidCallback tap) {
    return InkWell(onTap: tap, child: Container(padding: const EdgeInsets.all(AppDimensions.paddingSmall),
      decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
      child: Icon(icon, color: AppColors.white, size: 25)));
  }

  Widget cardSelector(String title, IconData icon, List<String> opciones, String? selected, Function(String?) onChange, AppLocalizations t) {
    return Container(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(color: AppColors.greyLight, borderRadius: BorderRadius.circular(AppDimensions.radiusLarge)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [Icon(icon, color: AppColors.primary, size: 20), const SizedBox(width: 10),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary))]),
        DropdownButtonHideUnderline(child: DropdownButton<String>(isExpanded: true, value: selected,
          hint: Text(t.select),
          items: opciones.map((o) => DropdownMenuItem(value: o, child: Text(o))).toList(),
          onChanged: onChange)),
      ]));
  }

  Widget buildBottomButton(AppLocalizations t) {
    return Container(width: double.infinity, height: AppDimensions.buttonHeightLarge,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusButton))),
        onPressed: () async {
          if (!mostrarSegundaFase) { setState(() => mostrarSegundaFase = true); } else {
            if (nivelActividad != null && objetivo != null) {
              final actividadMap = {t.days12: '1-2 días', t.days34: '3-4 días', t.days4plus: '+4 días'};
              final objetivoMap = {t.loseWeight: 'Bajar peso', t.gainWeight: 'Subir peso', t.maintainWeight: 'Mantener peso'};
              final infoDieta = InfoDisenoDieta(idUsuario: widget.usuario?.id ?? 0, edad: edad, altura: altura, peso: peso.toDouble(),
                sexo: genero, objetivo: objetivoMap[objetivo!] ?? objetivo!, nivelActividad: actividadMap[nivelActividad!] ?? nivelActividad!);
              await infoDietaDAO.insertOrUpdate(infoDieta);
              final plan = DietaGenerator.generar(infoDieta);
              Navigator.push(context, MaterialPageRoute(builder: (context) => DietResultScreen(plan: plan)));
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t.selectActivityAndGoal), backgroundColor: AppColors.warning));
            }
          }
        },
        child: Text(!mostrarSegundaFase ? t.next : t.generateDiet, style: AppTextStyles.buttonWhiteLarge),
      ));
  }
}
