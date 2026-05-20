import 'package:flutter/material.dart';
import 'package:geofit/l10n/app_localizations.dart';
import 'package:geofit/database/daos/historial_dao.dart';
import 'package:geofit/models/historial.dart';
import 'package:geofit/models/usuario.dart';
import 'package:geofit/models/app_colors.dart';
import 'package:geofit/models/app_dimensions.dart';
import 'package:geofit/models/app_text_styles.dart';

class HistorialScreen extends StatefulWidget {
  final Usuario? usuario;
  const HistorialScreen({super.key, this.usuario});
  @override
  State<HistorialScreen> createState() => HistorialScreenState();
}

class HistorialScreenState extends State<HistorialScreen> {
  final HistorialDAO historialDAO = HistorialDAO();
  bool cargando = true;
  List<Historial> resultados = [];

  @override
  void initState() { super.initState(); cargarHistorial(); }

  Future<void> cargarHistorial() async {
    if (widget.usuario?.id == null) { setState(() => cargando = false); return; }
    final res = await historialDAO.getHistorialByUsuarioId(widget.usuario!.id!);
    setState(() { resultados = res; cargando = false; });
  }

  Future<void> eliminarRegistro(Historial h) async {
    final t = AppLocalizations.of(context)!;
    final confirmar = await showDialog<bool>(context: context, builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusCard + 4)),
      title: Text(t.deleteRecord),
      content: Text('${t.confirmDeleteRecord} ${formatearFecha(h.fecha)}?'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context, false), child: Text(t.cancel)),
        ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
          onPressed: () => Navigator.pop(context, true), child: Text(t.delete, style: const TextStyle(color: AppColors.white))),
      ]));
    if (confirmar == true && h.id != null) {
      await historialDAO.deleteHistorial(h.id!);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Row(children: [const Icon(Icons.check_circle, color: AppColors.white, size: 20), const SizedBox(width: AppDimensions.paddingSmall), Text(t.recordDeleted)]),
        backgroundColor: AppColors.primary, behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusSmall)),
        margin: const EdgeInsets.all(AppDimensions.snackBarMargin)));
      await cargarHistorial();
    }
  }

  Future<void> eliminarTodo() async {
    final t = AppLocalizations.of(context)!;
    if (resultados.isEmpty) return;
    final confirmar = await showDialog<bool>(context: context, builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusCard + 4)),
      title: Row(children: [const Icon(Icons.warning_amber_rounded, color: AppColors.error), const SizedBox(width: 8), Text(t.deleteAll)]),
      content: Text(t.confirmDeleteAll),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context, false), child: Text(t.cancel)),
        ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
          onPressed: () => Navigator.pop(context, true), child: Text(t.deleteAll, style: const TextStyle(color: AppColors.white))),
      ]));
    if (confirmar == true && widget.usuario?.id != null) {
      await historialDAO.deleteAllHistorialByUsuario(widget.usuario!.id!);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Row(children: [const Icon(Icons.check_circle, color: AppColors.white, size: 20), const SizedBox(width: AppDimensions.paddingSmall), Text(t.historyDeleted)]),
        backgroundColor: AppColors.primary, behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusSmall)),
        margin: const EdgeInsets.all(AppDimensions.snackBarMargin)));
      await cargarHistorial();
    }
  }

  String formatearFecha(String fechaIso) {
    try {
      final fecha = DateTime.parse(fechaIso);
      return '${fecha.day.toString().padLeft(2, '0')}/${fecha.month.toString().padLeft(2, '0')}/${fecha.year} ${fecha.hour.toString().padLeft(2, '0')}:${fecha.minute.toString().padLeft(2, '0')}';
    } catch (_) { return fechaIso; }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(backgroundColor: AppColors.white, elevation: 0,
        title: Text(t.myHistory, style: AppTextStyles.appBarTitle),
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios, color: AppColors.primary), onPressed: () => Navigator.pop(context)),
        actions: [if (resultados.isNotEmpty) IconButton(icon: const Icon(Icons.delete_sweep, color: AppColors.error), tooltip: t.deleteAllHistory, onPressed: eliminarTodo)]),
      body: Padding(padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(width: double.infinity, padding: const EdgeInsets.all(AppDimensions.paddingLarge),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [AppColors.greenLight, AppColors.greenMedium], begin: Alignment.topLeft, end: Alignment.bottomRight),
            borderRadius: BorderRadius.circular(AppDimensions.radiusCard + 4)),
          child: Row(children: [
            Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.2), shape: BoxShape.circle),
              child: const Icon(Icons.timeline, color: AppColors.primary, size: 28)),
            const SizedBox(width: 15),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(t.yourNutritionalHistory, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textPrimary)),
              const SizedBox(height: 4),
              Text(t.reviewAllRecords, style: TextStyle(color: AppColors.greyText, fontSize: 13)),
            ])),
          ])),
        const SizedBox(height: 15),
        if (!cargando && resultados.isNotEmpty)
          Padding(padding: const EdgeInsets.only(bottom: 10),
            child: Text("${resultados.length} ${resultados.length != 1 ? t.records : t.record}",
              style: TextStyle(color: AppColors.greyHint, fontSize: 13, fontWeight: FontWeight.w500))),
        Expanded(child: cargando
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : resultados.isEmpty
            ? buildEstadoVacio(Icons.history_toggle_off, t.noRecordsYet)
            : ListView.builder(itemCount: resultados.length, itemBuilder: (context, index) => buildHistorialCard(resultados[index], t))),
        const SizedBox(height: 20),
      ])),
    );
  }

  Widget buildEstadoVacio(IconData icon, String mensaje) {
    return Container(width: double.infinity,
      decoration: BoxDecoration(border: Border.all(color: AppColors.greyBorder), borderRadius: BorderRadius.circular(AppDimensions.radiusLarge)),
      child: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(icon, size: 60, color: AppColors.greyBorder),
        const SizedBox(height: 10),
        Text(mensaje, textAlign: TextAlign.center, style: TextStyle(color: AppColors.greyText, fontSize: 16, fontWeight: FontWeight.w500)),
      ])));
  }

  Widget buildHistorialCard(Historial h, AppLocalizations t) {
    return Card(margin: const EdgeInsets.only(bottom: 12), elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusCard + 4)),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        leading: const CircleAvatar(backgroundColor: AppColors.primary, child: Icon(Icons.restaurant, color: AppColors.white, size: 20)),
        title: Text(formatearFecha(h.fecha), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        subtitle: Text('${h.caloriasTotales.toStringAsFixed(1)} kcal', style: const TextStyle(color: AppColors.calorieColor, fontWeight: FontWeight.w600)),
        children: [
          const Divider(),
          macroRow(Icons.local_fire_department, t.calories, '${h.caloriasTotales.toStringAsFixed(1)} kcal', AppColors.calorieColor),
          macroRow(Icons.fitness_center, t.proteins, '${h.proteinasTotales.toStringAsFixed(1)} g', AppColors.error),
          macroRow(Icons.grain, t.carbs, '${h.carbohidratosTotales.toStringAsFixed(1)} g', AppColors.carbColor),
          macroRow(Icons.water_drop, t.fats, '${h.grasasTotales.toStringAsFixed(1)} g', AppColors.fatColor),
          if (h.detalle.isNotEmpty) ...[
            const SizedBox(height: 10), const Divider(), const SizedBox(height: 4),
            Text(t.foodDetail, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.grey)),
            const SizedBox(height: 6),
            Container(width: double.infinity, padding: const EdgeInsets.all(AppDimensions.paddingSmall),
              decoration: BoxDecoration(color: AppColors.greyLightest, borderRadius: BorderRadius.circular(AppDimensions.radiusSmall)),
              child: Text(h.detalle, style: TextStyle(fontSize: 12, color: AppColors.greyDark))),
          ],
          const SizedBox(height: 10),
          Align(alignment: Alignment.centerRight, child: TextButton.icon(
            icon: const Icon(Icons.delete_outline, color: AppColors.error, size: 18),
            label: Text(t.delete, style: const TextStyle(color: AppColors.error, fontSize: 13)),
            onPressed: () => eliminarRegistro(h))),
        ]));
  }

  Widget macroRow(IconData icon, String label, String value, Color color) {
    return Padding(padding: const EdgeInsets.symmetric(vertical: 3), child: Row(children: [
      Icon(icon, size: 18, color: color), const SizedBox(width: 8),
      Text('$label: ', style: const TextStyle(fontSize: 13)),
      Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: color)),
    ]));
  }
}
