import 'package:flutter/material.dart';
import 'package:geofit/l10n/app_localizations.dart';
import 'package:geofit/models/dieta_generator.dart';
import 'package:geofit/models/app_colors.dart';
import 'package:geofit/models/app_dimensions.dart';
import 'package:geofit/models/app_text_styles.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class DietResultScreen extends StatelessWidget {
  final DietaPlan plan;
  const DietResultScreen({super.key, required this.plan});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(backgroundColor: AppColors.white, elevation: 0,
        title: Text(t.yourDietPlan, style: AppTextStyles.appBarTitle), centerTitle: true,
        leading: IconButton(icon: const Icon(Icons.chevron_left, color: AppColors.primary, size: 32),
          onPressed: () => Navigator.popUntil(context, (route) => route.isFirst))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.paddingLarge),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          buildResumenCard(t),
          const SizedBox(height: 20),
          buildMacrosCard(t),
          const SizedBox(height: 20),
          Text(t.mealPlan, style: AppTextStyles.sectionTitle),
          const SizedBox(height: 10),
          ...plan.comidas.map((comida) => buildComidaCard(comida)),
          const SizedBox(height: 20),
          SizedBox(width: double.infinity, height: AppDimensions.buttonHeight, child: ElevatedButton.icon(
            icon: const Icon(Icons.picture_as_pdf, color: AppColors.white),
            label: Text(t.exportPdf, style: AppTextStyles.buttonWhite),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.pdfButton,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusButton))),
            onPressed: () => exportarPDF(context))),
          const SizedBox(height: 40),
        ]),
      ),
    );
  }

  Future<void> exportarPDF(BuildContext context) async {
    final pdf = pw.Document();
    pdf.addPage(pw.MultiPage(pageFormat: PdfPageFormat.a4, margin: const pw.EdgeInsets.all(40),
      build: (pw.Context ctx) => [
        pw.Center(child: pw.Text('PLAN DE DIETA PERSONALIZADO', style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold))),
        pw.SizedBox(height: 8),
        pw.Center(child: pw.Text('Generado por GeoFit', style: const pw.TextStyle(fontSize: 12, color: PdfColors.grey600))),
        pw.SizedBox(height: 20),
        pw.Divider(thickness: 2, color: PdfColors.green),
        pw.SizedBox(height: 15),
        pw.Container(padding: const pw.EdgeInsets.all(15),
          decoration: pw.BoxDecoration(color: PdfColors.green50, borderRadius: pw.BorderRadius.circular(10)),
          child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
            pw.Text('Tu Objetivo', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold, color: PdfColors.green800)),
            pw.SizedBox(height: 5),
            pw.Text(plan.resumenObjetivo, style: const pw.TextStyle(fontSize: 12)),
            pw.SizedBox(height: 10),
            pw.Text('${plan.caloriasObjetivo.toInt()} kcal/dia', style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold, color: PdfColors.green700)),
          ])),
        pw.SizedBox(height: 20),
        pw.Text('Distribucion de Macronutrientes', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 10),
        pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceAround, children: [
          pdfMacroItem('Proteinas', '${plan.proteinasGramos.toInt()}g'),
          pdfMacroItem('Carbohidratos', '${plan.carbohidratosGramos.toInt()}g'),
          pdfMacroItem('Grasas', '${plan.grasasGramos.toInt()}g'),
        ]),
        pw.SizedBox(height: 20), pw.Divider(), pw.SizedBox(height: 10),
        pw.Text('Plan de Comidas', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 10),
        ...plan.comidas.map((comida) => pw.Container(
          margin: const pw.EdgeInsets.only(bottom: 12), padding: const pw.EdgeInsets.all(12),
          decoration: pw.BoxDecoration(color: PdfColors.grey100, borderRadius: pw.BorderRadius.circular(8)),
          child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
            pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
              pw.Text(comida.nombre, style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
              pw.Text('${comida.calorias.toInt()} kcal', style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold, color: PdfColors.green700)),
            ]),
            pw.Text(comida.hora, style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey600)),
            pw.SizedBox(height: 6),
            ...comida.alimentos.map((a) => pw.Padding(padding: const pw.EdgeInsets.only(left: 10, bottom: 3),
              child: pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                pw.Text('• ', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.green)),
                pw.Expanded(child: pw.Text(a, style: const pw.TextStyle(fontSize: 11))),
              ]))),
          ]))),
      ]));
    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save(), name: 'Plan_Dieta_GeoFit');
  }

  pw.Widget pdfMacroItem(String label, String valor) {
    return pw.Column(children: [
      pw.Text(valor, style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold, color: PdfColors.green700)),
      pw.SizedBox(height: 4),
      pw.Text(label, style: const pw.TextStyle(fontSize: 11, color: PdfColors.grey600)),
    ]);
  }

  Widget buildResumenCard(AppLocalizations t) {
    return Container(width: double.infinity, padding: const EdgeInsets.all(AppDimensions.paddingLarge),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [AppColors.gradientStart, AppColors.gradientEnd], begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(t.goalEmoji, style: const TextStyle(color: AppColors.white70, fontSize: 14, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text(plan.resumenObjetivo, style: const TextStyle(color: AppColors.white, fontSize: 16, fontWeight: FontWeight.w500)),
        const SizedBox(height: 15),
        Row(children: [
          const Icon(Icons.local_fire_department, color: AppColors.carbColor, size: 30),
          const SizedBox(width: 10),
          Text("${plan.caloriasObjetivo.toInt()} kcal/día", style: const TextStyle(color: AppColors.white, fontSize: 28, fontWeight: FontWeight.bold)),
        ]),
      ]));
  }

  Widget buildMacrosCard(AppLocalizations t) {
    return Container(padding: const EdgeInsets.all(AppDimensions.paddingLarge),
      decoration: BoxDecoration(color: AppColors.greyLight, borderRadius: BorderRadius.circular(AppDimensions.radiusLarge)),
      child: Column(children: [
        Text(t.macroDistribution, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 15),
        Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          macroItem(t.proteins, "${plan.proteinasGramos.toInt()}g", AppColors.proteinColor, Icons.fitness_center),
          macroItem(t.carbsShort, "${plan.carbohidratosGramos.toInt()}g", AppColors.carbDark, Icons.grain),
          macroItem(t.fats, "${plan.grasasGramos.toInt()}g", AppColors.fatLight, Icons.opacity),
        ]),
      ]));
  }

  Widget macroItem(String label, String valor, Color color, IconData icon) {
    return Column(children: [
      Container(padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: color.withValues(alpha: 0.15), shape: BoxShape.circle),
        child: Icon(icon, color: color, size: 28)),
      const SizedBox(height: 8),
      Text(valor, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
      Text(label, style: const TextStyle(fontSize: 12, color: AppColors.grey)),
    ]);
  }

  Widget buildComidaCard(Comida comida) {
    return Container(margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.all(AppDimensions.paddingMedium),
      decoration: BoxDecoration(color: AppColors.greyLight, borderRadius: BorderRadius.circular(AppDimensions.radiusCard + 4)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Row(children: [const Icon(Icons.restaurant, color: AppColors.primary, size: 20), const SizedBox(width: 8),
            Text(comida.nombre, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16))]),
          Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(AppDimensions.radiusSmall)),
            child: Text("${comida.calorias.toInt()} kcal", style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 12))),
        ]),
        const SizedBox(height: 4),
        Text(comida.hora, style: const TextStyle(color: AppColors.grey, fontSize: 12)),
        const SizedBox(height: 8),
        ...comida.alimentos.map((a) => Padding(padding: const EdgeInsets.only(left: 8, bottom: 4),
          child: Row(children: [
            Container(width: 5, height: 5, decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle)),
            const SizedBox(width: 8),
            Expanded(child: Text(a, style: const TextStyle(fontSize: 14))),
          ]))),
      ]));
  }
}
