import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geofit/l10n/app_localizations.dart';
import 'package:geofit/screens/options/cont_cal.dart';
import 'package:geofit/screens/options/diet_screen.dart';
import 'package:geofit/screens/options/diet_result_screen.dart';
import 'package:geofit/screens/options/historial_screen.dart';
import 'package:geofit/screens/options/call_screen.dart';
import 'package:geofit/screens/geofit_appbar.dart';
import 'package:geofit/models/usuario.dart';
import 'package:geofit/models/app_colors.dart';
import 'package:geofit/models/app_dimensions.dart';
import 'package:geofit/models/app_text_styles.dart';
import 'package:geofit/models/dieta_generator.dart';
import 'package:geofit/database/daos/usuario_dao.dart';
import 'package:geofit/database/daos/info_dieta_dao.dart';

<<<<<<< HEAD
// ─────────────────────────────────────────────
// Pantalla: Menú principal
// ─────────────────────────────────────────────
class MainMenu extends StatefulWidget {
  final Usuario? usuario;

  const MainMenu({super.key, this.usuario});

  @override
  State<MainMenu> createState() => MainMenuEstado();
}

class MainMenuEstado extends State<MainMenu> {
  // ── Variables de estado ──
  double miSaldo = 15.50;
  int paginaActual = 0;
  Usuario? usuarioActual;

  // ── Controladores ──
  final PageController controladorPaginas = PageController();
  late Timer temporizadorCarrusel;

  // ── Servicios ──
  final UsuarioDAO usuarioDAO = UsuarioDAO();

  // ── Imágenes del carrusel ──
  final List<String> imagenes = [
=======
class MainMenu extends StatefulWidget {
  final Usuario? usuario;
  const MainMenu({super.key, this.usuario});
  @override
  State<MainMenu> createState() => MainMenuState();
}

class MainMenuState extends State<MainMenu> {
  double miSaldo = 15.50;
  final PageController pageController = PageController();
  int currentPage = 0;
  late Timer timer;
  Usuario? usuarioActual;
  final UsuarioDAO usuarioDAO = UsuarioDAO();

  final List<String> images = [
>>>>>>> dd4388feed10aea6a261b8f796f4e238ac56b83d
    'assets/images/carousel_1.png',
    'assets/images/carousel_2.png',
    'assets/images/carousel_3.png',
  ];

<<<<<<< HEAD
  // ── Ciclo de vida ──

=======
>>>>>>> dd4388feed10aea6a261b8f796f4e238ac56b83d
  @override
  void initState() {
    super.initState();
    usuarioActual = widget.usuario;
    cargarSaldo();
<<<<<<< HEAD

    temporizadorCarrusel = Timer.periodic(
      const Duration(seconds: 5),
      (Timer temporizador) {
        if (paginaActual < imagenes.length - 1) {
          paginaActual++;
        } else {
          paginaActual = 0;
        }

        if (controladorPaginas.hasClients) {
          controladorPaginas.animateToPage(
            paginaActual,
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOut,
          );
        }
      },
    );
  }

  @override
  void dispose() {
    temporizadorCarrusel.cancel();
    controladorPaginas.dispose();
    super.dispose();
  }

  // ── Métodos de datos ──

  Future<void> cargarSaldo() async {
    if (usuarioActual?.id != null) {
      final saldo = await usuarioDAO.getSaldoByUserId(usuarioActual!.id!);
      setState(() {
        miSaldo = saldo;
      });
    }
  }

  void actualizarSaldo(double cantidad) async {
    final nuevoSaldo = miSaldo + cantidad;
    setState(() {
      miSaldo = nuevoSaldo;
    });

    if (usuarioActual?.id != null) {
      await usuarioDAO.updateSaldo(usuarioActual!.id!, nuevoSaldo);
    }
  }

  // ── Lógica de pago premium ──

  void gestionarPagoPremium(BuildContext contexto) async {
    final traducciones = AppLocalizations.of(contexto)!;

    // Si ya pagó, mostrar dieta guardada
    if (usuarioActual?.dietaPagada == true) {
      await mostrarDietaGuardada(contexto);
      return;
    }

    // Diálogo de confirmación de compra
    showDialog(
      context: contexto,
      barrierDismissible: false,
      builder: (BuildContext contextoDialogo) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
          ),
          title: Text(traducciones.confirmPurchase),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 15),
              Text(traducciones.purchaseQuestion),
              const SizedBox(height: 10),
              Text(
                '${traducciones.availableBalance}: ${miSaldo.toStringAsFixed(2)}€',
                style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.grey),
              ),
            ],
          ),
          actions: [
            // Botón cancelar
            TextButton(
              onPressed: () => Navigator.pop(contextoDialogo),
              child: Text(traducciones.no, style: const TextStyle(color: AppColors.error)),
            ),

            // Botón confirmar
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                ),
              ),
              onPressed: () async {
                if (miSaldo >= AppDimensions.dietCost) {
                  Navigator.pop(contextoDialogo);
                  actualizarSaldo(-AppDimensions.dietCost);

                  if (usuarioActual?.id != null) {
                    await usuarioDAO.updateDietaPagada(usuarioActual!.id!, true);
                    setState(() {
                      usuarioActual = Usuario(
                        id: usuarioActual!.id,
                        usuario: usuarioActual!.usuario,
                        contrasena: usuarioActual!.contrasena,
                        saldo: miSaldo,
                        dietaPagada: true,
                      );
                    });
                  }

                  Navigator.push(
                    contexto,
                    MaterialPageRoute(builder: (_) => DietScreen(usuario: usuarioActual)),
                  );
                } else {
                  Navigator.pop(contextoDialogo);
                  ScaffoldMessenger.of(contexto).showSnackBar(
                    SnackBar(
                      content: Text(traducciones.insufficientBalance),
                      backgroundColor: AppColors.warning,
                    ),
                  );
                }
              },
              child: Text(traducciones.yesPay, style: const TextStyle(color: AppColors.white)),
            ),
          ],
        );
      },
    );
  }

  Future<void> mostrarDietaGuardada(BuildContext contexto) async {
    final informacionDietaDAO = InfoDisenoDietaDAO();
    final informacion = await informacionDietaDAO.getByUsuarioId(usuarioActual!.id!);

    if (informacion != null) {
      final plan = DietaGenerator.generar(informacion);
      Navigator.push(
        contexto,
        MaterialPageRoute(builder: (_) => DietResultScreen(plan: plan)),
      );
    } else {
      Navigator.push(
        contexto,
        MaterialPageRoute(builder: (_) => DietScreen(usuario: usuarioActual)),
      );
    }
  }

  // ── Construcción de la interfaz ──

  @override
  Widget build(BuildContext context) {
    final traducciones = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: GeoFitAppBar(
        miSaldo: miSaldo,
        actualizarSaldo: actualizarSaldo,
        usuario: usuarioActual,
        onUsuarioActualizado: (usuario) => setState(() => usuarioActual = usuario),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: Column(
            children: [
              // ── Saludo de bienvenida ──
              if (usuarioActual != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: Row(
                    children: [
                      Text(traducciones.welcome, style: AppTextStyles.welcomeText),
                      Text(usuarioActual!.usuario, style: AppTextStyles.welcomeName),
                    ],
                  ),
                ),

              const SizedBox(height: 10),

              // ── Carrusel de imágenes ──
              SizedBox(
                height: AppDimensions.carouselHeight,
                child: PageView.builder(
                  controller: controladorPaginas,
                  itemCount: imagenes.length,
                  itemBuilder: (contexto, indice) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
                      image: DecorationImage(
                        image: AssetImage(imagenes[indice]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // ── Primera fila de opciones ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: elementoMenu(
                        Icons.local_fire_department,
                        traducciones.countCalories,
                        null,
                        null,
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => ContCal(usuario: usuarioActual)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: elementoMenu(
                        Icons.assignment,
                        traducciones.planDiet,
                        traducciones.premium,
                        AppColors.premiumTag,
                        () => gestionarPagoPremium(context),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ── Segunda fila de opciones ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: elementoMenu(
                        Icons.history,
                        traducciones.viewHistory,
                        null,
                        null,
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => HistorialScreen(usuario: usuarioActual)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: elementoMenu(
                        Icons.support_agent,
                        traducciones.personalAdvice,
                        traducciones.comingSoon,
                        AppColors.comingSoon,
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const CallScreen()),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
=======
    timer = Timer.periodic(const Duration(seconds: 5), (Timer t) {
      if (currentPage < images.length - 1) { currentPage++; } else { currentPage = 0; }
      if (pageController.hasClients) {
        pageController.animateToPage(currentPage, duration: const Duration(milliseconds: 600), curve: Curves.easeInOut);
      }
    });
  }

  Future<void> cargarSaldo() async {
    if (usuarioActual?.id != null) {
      final saldo = await usuarioDAO.getSaldoByUserId(usuarioActual!.id!);
      setState(() { miSaldo = saldo; });
    }
  }

  @override
  void dispose() { timer.cancel(); pageController.dispose(); super.dispose(); }

  void actualizarSaldo(double cantidad) async {
    final nuevoSaldo = miSaldo + cantidad;
    setState(() { miSaldo = nuevoSaldo; });
    if (usuarioActual?.id != null) await usuarioDAO.updateSaldo(usuarioActual!.id!, nuevoSaldo);
  }

  void gestionarPagoPremium(BuildContext context) async {
    final t = AppLocalizations.of(context)!;
    if (usuarioActual?.dietaPagada == true) { await mostrarDietaGuardada(context); return; }
    showDialog(context: context, barrierDismissible: false, builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusLarge)),
        title: Text(t.confirmPurchase),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          const SizedBox(height: 15),
          Text(t.purchaseQuestion),
          const SizedBox(height: 10),
          Text('${t.availableBalance}: ${miSaldo.toStringAsFixed(2)}€', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.grey)),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(t.no, style: const TextStyle(color: AppColors.error))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusSmall))),
            onPressed: () async {
              if (miSaldo >= AppDimensions.dietCost) {
                Navigator.pop(context);
                actualizarSaldo(-AppDimensions.dietCost);
                if (usuarioActual?.id != null) {
                  await usuarioDAO.updateDietaPagada(usuarioActual!.id!, true);
                  setState(() { usuarioActual = Usuario(id: usuarioActual!.id, usuario: usuarioActual!.usuario, contrasena: usuarioActual!.contrasena, saldo: miSaldo, dietaPagada: true); });
                }
                Navigator.push(context, MaterialPageRoute(builder: (context) => DietScreen(usuario: usuarioActual)));
              } else {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t.insufficientBalance), backgroundColor: AppColors.warning));
              }
            },
            child: Text(t.yesPay, style: const TextStyle(color: AppColors.white)),
          ),
        ],
      );
    });
  }

  Future<void> mostrarDietaGuardada(BuildContext context) async {
    final infoDietaDAO = InfoDisenoDietaDAO();
    final info = await infoDietaDAO.getByUsuarioId(usuarioActual!.id!);
    if (info != null) {
      final plan = DietaGenerator.generar(info);
      Navigator.push(context, MaterialPageRoute(builder: (context) => DietResultScreen(plan: plan)));
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (context) => DietScreen(usuario: usuarioActual)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: GeoFitAppBar(miSaldo: miSaldo, actualizarSaldo: actualizarSaldo, usuario: usuarioActual, onUsuarioActualizado: (u) => setState(() => usuarioActual = u)),
      body: SingleChildScrollView(
        child: Padding(padding: const EdgeInsets.only(top: 5.0), child: Column(children: [
          if (usuarioActual != null)
            Padding(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5), child: Row(children: [
              Text(t.welcome, style: AppTextStyles.welcomeText),
              Text(usuarioActual!.usuario, style: AppTextStyles.welcomeName),
            ])),
          const SizedBox(height: 10),
          SizedBox(height: AppDimensions.carouselHeight, child: PageView.builder(
            controller: pageController, itemCount: images.length,
            itemBuilder: (context, index) => Container(margin: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
                image: DecorationImage(image: AssetImage(images[index]), fit: BoxFit.cover))),
          )),
          const SizedBox(height: 40),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: Row(children: [
            Expanded(child: menuItem(Icons.local_fire_department, t.countCalories, null, null,
                () => Navigator.push(context, MaterialPageRoute(builder: (context) => ContCal(usuario: usuarioActual))))),
            const SizedBox(width: 15),
            Expanded(child: menuItem(Icons.assignment, t.planDiet, t.premium, AppColors.premiumTag,
                () => gestionarPagoPremium(context))),
          ])),
          const SizedBox(height: 20),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: Row(children: [
            Expanded(child: menuItem(Icons.history, t.viewHistory, null, null,
                () => Navigator.push(context, MaterialPageRoute(builder: (context) => HistorialScreen(usuario: usuarioActual))))),
            const SizedBox(width: 15),
            Expanded(child: menuItem(Icons.support_agent, t.personalAdvice, t.comingSoon, AppColors.comingSoon,
                () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CallScreen())))),
          ])),
          const SizedBox(height: 40),
        ])),
>>>>>>> dd4388feed10aea6a261b8f796f4e238ac56b83d
      ),
    );
  }

<<<<<<< HEAD
  // ── Widget reutilizable: tarjeta de menú ──

  Widget elementoMenu(
    IconData icono,
    String etiqueta,
    String? etiquetaExtra,
    Color? colorEtiqueta,
    VoidCallback alPulsar,
  ) {
    return GestureDetector(
      onTap: alPulsar,
      child: Container(
        height: AppDimensions.menuCardHeight,
        decoration: BoxDecoration(
          color: AppColors.greyLight,
          borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
          boxShadow: const [
            BoxShadow(color: AppColors.shadow, blurRadius: 5, offset: Offset(0, 2)),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icono, size: 35, color: AppColors.primary),
            const SizedBox(height: 8),
            Text(
              etiqueta,
              textAlign: TextAlign.center,
              style: AppTextStyles.menuItemLabel,
            ),
            if (etiquetaExtra != null) ...[
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: colorEtiqueta,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(etiquetaExtra, style: AppTextStyles.tagText),
              ),
            ],
          ],
        ),
      ),
    );
=======
  Widget menuItem(IconData icon, String label, String? tag, Color? tagCol, VoidCallback tap) {
    return GestureDetector(onTap: tap, child: Container(
      height: AppDimensions.menuCardHeight,
      decoration: BoxDecoration(color: AppColors.greyLight, borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
        boxShadow: const [BoxShadow(color: AppColors.shadow, blurRadius: 5, offset: Offset(0, 2))]),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(icon, size: 35, color: AppColors.primary),
        const SizedBox(height: 8),
        Text(label, textAlign: TextAlign.center, style: AppTextStyles.menuItemLabel),
        if (tag != null) ...[
          const SizedBox(height: 6),
          Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(color: tagCol, borderRadius: BorderRadius.circular(5)),
            child: Text(tag, style: AppTextStyles.tagText)),
        ],
      ]),
    ));
>>>>>>> dd4388feed10aea6a261b8f796f4e238ac56b83d
  }
}
