import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geofit/l10n/app_localizations.dart';
import 'package:geofit/screens/geofit_appbar.dart';
import 'package:geofit/database/daos/alimento_dao.dart';
import 'package:geofit/database/daos/historial_dao.dart';
import 'package:geofit/models/alimento.dart';
import 'package:geofit/models/historial.dart';
import 'package:geofit/models/usuario.dart';
import 'package:geofit/models/app_colors.dart';
import 'package:geofit/models/app_dimensions.dart';

// ─────────────────────────────────────────────
// Modelo auxiliar: representa un alimento añadido a la lista
// ─────────────────────────────────────────────
class AlimentoEnLista {
  final String nombre;
  final double gramos;
  final double calorias;
  final double proteina;
  final double carbohidratos;
  final double grasas;

  AlimentoEnLista({
    required this.nombre,
    required this.gramos,
    required this.calorias,
    required this.proteina,
    required this.carbohidratos,
    required this.grasas,
  });
}

// ─────────────────────────────────────────────
// Pantalla: Contador de Calorías
// ─────────────────────────────────────────────
class ContCal extends StatefulWidget {
  final Usuario? usuario;

  const ContCal({super.key, this.usuario});

  @override
  State<ContCal> createState() => ContCalEstado();
}

class ContCalEstado extends State<ContCal> {
  // ── Variables de estado ──
  double miSaldo = 15.50;

  final AlimentoDAO alimentoDAO = AlimentoDAO();
  final HistorialDAO historialDAO = HistorialDAO();

  List<Alimento> alimentosDisponibles = [];
  Alimento? alimentoSeleccionado;
  final TextEditingController controladorGramos = TextEditingController();
  List<AlimentoEnLista> listaAlimentos = [];

  // ── Ciclo de vida ──

  @override
  void initState() {
    super.initState();
    cargarAlimentos();
  }

  // ── Métodos de datos ──

  Future<void> cargarAlimentos() async {
    final alimentos = await alimentoDAO.getAllAlimentos();
    setState(() {
      alimentosDisponibles = alimentos;
    });
  }

  void actualizarSaldo(double cantidad) {
    setState(() {
      miSaldo += cantidad;
    });
  }

  // ── Utilidades de UI ──

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

  // ── Lógica de lista de alimentos ──

  void agregarALista() {
    final traducciones = AppLocalizations.of(context)!;

    if (alimentoSeleccionado == null) {
      mostrarSnackBar(traducciones.selectFoodFirst, color: AppColors.warning);
      return;
    }

    if (controladorGramos.text.trim().isEmpty) {
      mostrarSnackBar(traducciones.enterGrams);
      return;
    }

    final double? gramos = double.tryParse(controladorGramos.text.trim());

    if (gramos == null) {
      mostrarSnackBar(traducciones.onlyNumbersGrams);
      return;
    }
    if (gramos < 0) {
      mostrarSnackBar(traducciones.noNegativeGrams);
      return;
    }
    if (gramos == 0) {
      mostrarSnackBar(traducciones.noZeroGrams);
      return;
    }

    final factorProporcional = gramos / 100.0;

    final elemento = AlimentoEnLista(
      nombre: alimentoSeleccionado!.nombre,
      gramos: gramos,
      calorias: alimentoSeleccionado!.calorias * factorProporcional,
      proteina: alimentoSeleccionado!.proteina * factorProporcional,
      carbohidratos: alimentoSeleccionado!.carbohidratos * factorProporcional,
      grasas: alimentoSeleccionado!.grasas * factorProporcional,
    );

    setState(() {
      listaAlimentos.add(elemento);
      controladorGramos.clear();
      alimentoSeleccionado = null;
    });
  }

  void eliminarDeLista(int indice) {
    setState(() {
      listaAlimentos.removeAt(indice);
    });
  }

  // ── Cálculo y guardado ──

  Future<void> mostrarPopupCalculo() async {
    final traducciones = AppLocalizations.of(context)!;

    if (listaAlimentos.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(traducciones.addAtLeastOne),
          backgroundColor: AppColors.warning,
        ),
      );
      return;
    }

    if (widget.usuario == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(traducciones.mustLoginHistory),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    double totalCalorias = 0;
    double totalProteinas = 0;
    double totalCarbohidratos = 0;
    double totalGrasas = 0;

    for (final elemento in listaAlimentos) {
      totalCalorias += elemento.calorias;
      totalProteinas += elemento.proteina;
      totalCarbohidratos += elemento.carbohidratos;
      totalGrasas += elemento.grasas;
    }

    await guardarEnHistorial(totalCalorias, totalProteinas, totalCarbohidratos, totalGrasas);

    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext contextoDialogo) {
        final textos = AppLocalizations.of(contextoDialogo)!;

        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
          ),

          // ── Título del diálogo ──
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Icon(Icons.restaurant_menu, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      textos.nutritionalSummary,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.greenLight,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
                  border: Border.all(color: AppColors.primary),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.check_circle, color: AppColors.primary, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      textos.savedInHistory,
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // ── Contenido del diálogo ──
          content: SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    textos.foodsAdded,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: AppColors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Lista de alimentos añadidos
                  ...listaAlimentos.map(
                    (elemento) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Container(
                        padding: const EdgeInsets.all(AppDimensions.paddingSmall),
                        decoration: BoxDecoration(
                          color: AppColors.greyLightest,
                          borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                          border: Border.all(color: AppColors.greyBorderLight),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${elemento.nombre} — ${elemento.gramos.toStringAsFixed(0)}g',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Cal: ${elemento.calorias.toStringAsFixed(1)} · '
                              'Prot: ${elemento.proteina.toStringAsFixed(1)}g · '
                              'Carb: ${elemento.carbohidratos.toStringAsFixed(1)}g · '
                              '${textos.fats}: ${elemento.grasas.toStringAsFixed(1)}g',
                              style: TextStyle(fontSize: 11, color: AppColors.greyText),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),
                  const Divider(thickness: 2),
                  const SizedBox(height: 8),

                  // Totales
                  Text(
                    textos.totals,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 10),

                  filaTotales(Icons.local_fire_department, textos.calories,
                      '${totalCalorias.toStringAsFixed(1)} kcal', AppColors.calorieColor),
                  filaTotales(Icons.fitness_center, textos.proteins,
                      '${totalProteinas.toStringAsFixed(1)} g', AppColors.error),
                  filaTotales(Icons.grain, textos.carbs,
                      '${totalCarbohidratos.toStringAsFixed(1)} g', AppColors.carbColor),
                  filaTotales(Icons.water_drop, textos.fats,
                      '${totalGrasas.toStringAsFixed(1)} g', AppColors.fatColor),
                ],
              ),
            ),
          ),

          // ── Acciones ──
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                ),
              ),
              onPressed: () {
                Navigator.pop(contextoDialogo);
                setState(() {
                  listaAlimentos.clear();
                });
              },
              child: Text(
                textos.accept,
                style: const TextStyle(color: AppColors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  // ── Widget auxiliar: fila de totales ──

  Widget filaTotales(IconData icono, String etiqueta, String valor, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icono, size: 20, color: color),
          const SizedBox(width: 8),
          Text('$etiqueta: ', style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
          Text(valor, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: color)),
        ],
      ),
    );
  }

  // ── Persistencia en historial ──

  Future<void> guardarEnHistorial(
    double calorias,
    double proteinas,
    double carbohidratos,
    double grasas,
  ) async {
    final lineasDetalle = listaAlimentos.map(
      (elemento) =>
          '${elemento.nombre} (${elemento.gramos.toStringAsFixed(0)}g): '
          '${elemento.calorias.toStringAsFixed(1)} kcal, '
          '${elemento.proteina.toStringAsFixed(1)}g prot, '
          '${elemento.carbohidratos.toStringAsFixed(1)}g carb, '
          '${elemento.grasas.toStringAsFixed(1)}g grasas',
    ).join('\n');

    final historial = Historial(
      idUsuario: widget.usuario!.id!,
      caloriasTotales: calorias,
      proteinasTotales: proteinas,
      carbohidratosTotales: carbohidratos,
      grasasTotales: grasas,
      detalle: lineasDetalle,
      fecha: DateTime.now().toIso8601String(),
    );

    await historialDAO.insertHistorial(historial);
  }

  // ── Construcción de la interfaz ──

  @override
  Widget build(BuildContext context) {
    final traducciones = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: GeoFitAppBar(miSaldo: miSaldo, actualizarSaldo: actualizarSaldo),
      body: Padding(
        padding: const EdgeInsets.only(
          bottom: AppDimensions.paddingMedium,
          left: AppDimensions.paddingMedium,
          right: AppDimensions.paddingMedium,
        ),
        child: Column(
          children: [
            // ── Selector de alimento ──
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: DropdownButtonFormField<Alimento>(
                initialValue: alimentoSeleccionado,
                hint: Text(traducciones.selectProduct),
                decoration: const InputDecoration(border: OutlineInputBorder()),
                items: alimentosDisponibles.map(
                  (alimento) => DropdownMenuItem(
                    value: alimento,
                    child: Text('${alimento.nombre}  (${alimento.calorias.toStringAsFixed(0)} kcal/100g)'),
                  ),
                ).toList(),
                onChanged: (valor) {
                  setState(() {
                    alimentoSeleccionado = valor;
                  });
                },
              ),
            ),

            const SizedBox(height: 20),

            // ── Campo de gramos ──
            TextField(
              controller: controladorGramos,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
              decoration: InputDecoration(
                labelText: traducciones.grams,
                border: const OutlineInputBorder(),
              ),
            ),

            // ── Botón añadir ──
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: ElevatedButton(
                onPressed: agregarALista,
                child: Text(
                  traducciones.addToList,
                  style: const TextStyle(color: AppColors.primary),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // ── Lista de alimentos añadidos ──
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppDimensions.paddingSmall),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: listaAlimentos.isEmpty
                      ? Center(child: Text(traducciones.noFoodsAdded))
                      : ListView.builder(
                          itemCount: listaAlimentos.length,
                          itemBuilder: (contexto, indice) {
                            final elemento = listaAlimentos[indice];
                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              child: ListTile(
                                leading: const Icon(Icons.restaurant, color: AppColors.primary),
                                title: Text(
                                  elemento.nombre,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  '${elemento.gramos.toStringAsFixed(0)} g',
                                  style: TextStyle(fontSize: 13, color: AppColors.greyText),
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete, color: AppColors.error),
                                  onPressed: () => eliminarDeLista(indice),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ),
            ),

            const SizedBox(height: 25),

            // ── Botón calcular macros ──
            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: SizedBox(
                width: double.infinity,
                height: AppDimensions.buttonHeightSmall,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
                    ),
                  ),
                  onPressed: () => mostrarPopupCalculo(),
                  child: Text(
                    traducciones.calculateMacros,
                    style: const TextStyle(
                      color: AppColors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
