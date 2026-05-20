import 'package:flutter/material.dart';
import 'package:geofit/l10n/app_localizations.dart';
import 'package:geofit/screens/home_screen.dart';
import 'package:geofit/screens/money/money_screen.dart';
import 'package:geofit/screens/money/outMoney_screen.dart';
import 'package:geofit/screens/profile_screen.dart';
import 'package:geofit/models/usuario.dart';
import 'package:geofit/models/app_colors.dart';
import 'package:geofit/models/app_dimensions.dart';
import 'package:geofit/models/app_text_styles.dart';

// ─────────────────────────────────────────────
// Widget: Barra superior personalizada de GeoFit
// ─────────────────────────────────────────────
class GeoFitAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double miSaldo;
  final Function(double) actualizarSaldo;
  final Usuario? usuario;
  final Function(Usuario)? onUsuarioActualizado;

  const GeoFitAppBar({
    super.key,
    required this.miSaldo,
    required this.actualizarSaldo,
    this.usuario,
    this.onUsuarioActualizado,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  // ── Formato del saldo ──

  String formatearSaldo(double saldo) {
    if (saldo.abs() >= 1000000) {
      return '${(saldo / 1000000).toStringAsFixed(1)}M €';
    }
    if (saldo.abs() >= 10000) {
      return '${(saldo / 1000).toStringAsFixed(1)}K €';
    }
    return '${saldo.toStringAsFixed(2)} €';
  }

  // ── Construcción de la barra ──

  @override
  Widget build(BuildContext context) {
    final traducciones = AppLocalizations.of(context)!;

    return AppBar(
      title: Text(traducciones.geoFitMenu),
      elevation: 0,
      actions: [
        // ── Menú del carrito (saldo) ──
        PopupMenuButton<String>(
          icon: const Icon(Icons.shopping_cart),
          onSelected: (valor) async {
            if (valor == 'ingresar') {
              final cantidad = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MoneyScreen()),
              );
              if (cantidad != null) actualizarSaldo(cantidad);
            } else if (valor == 'retirar') {
              final cantidadARetirar = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const OutmoneyScreen()),
              );
              if (cantidadARetirar != null) actualizarSaldo(cantidadARetirar);
            }
          },
          itemBuilder: (contexto) => [
            // Saldo actual (no seleccionable)
            PopupMenuItem(
              enabled: false,
              child: Row(
                children: [
                  const Icon(Icons.attach_money, color: AppColors.primary, size: 20),
                  const SizedBox(width: AppDimensions.paddingSmall),
                  Text(
                    "${traducciones.balance}: ${formatearSaldo(miSaldo)}",
                    style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.black),
                  ),
                ],
              ),
            ),
            const PopupMenuDivider(),

            // Opción: Ingresar dinero
            PopupMenuItem(
              value: 'ingresar',
              child: Row(
                children: [
                  const Icon(Icons.add_circle, color: AppColors.primary, size: 20),
                  const SizedBox(width: AppDimensions.paddingSmall),
                  Text(traducciones.depositMoney),
                ],
              ),
            ),
            const PopupMenuDivider(),

            // Opción: Retirar dinero
            PopupMenuItem(
              value: 'retirar',
              child: Row(
                children: [
                  const Icon(Icons.payments, color: AppColors.warning, size: 20),
                  const SizedBox(width: AppDimensions.paddingSmall),
                  Text(traducciones.withdrawMoney),
                ],
              ),
            ),
          ],
        ),

        // ── Menú del perfil ──
        PopupMenuButton<String>(
          icon: const Icon(Icons.person),
          onSelected: (valor) async {
            if (valor == 'perfil') {
              final resultado = await Navigator.push<Usuario>(
                context,
                MaterialPageRoute(builder: (_) => ProfileScreen(usuario: usuario)),
              );
              if (resultado != null && onUsuarioActualizado != null) {
                onUsuarioActualizado!(resultado);
              }
            } else if (valor == 'logout') {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(traducciones.logoutSuccess),
                  duration: const Duration(seconds: 1),
                ),
              );
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const HomeScreen()),
                (ruta) => false,
              );
            }
          },
          itemBuilder: (contexto) => [
            // Opción: Ver perfil
            PopupMenuItem(
              value: 'perfil',
              child: Row(
                children: [
                  const Icon(Icons.account_circle, color: AppColors.primary),
                  const SizedBox(width: AppDimensions.paddingSmall),
                  Text(traducciones.viewProfile),
                ],
              ),
            ),
            const PopupMenuDivider(),

            // Opción: Cerrar sesión
            PopupMenuItem(
              value: 'logout',
              child: Row(
                children: [
                  const Icon(Icons.logout, color: AppColors.error),
                  const SizedBox(width: AppDimensions.paddingSmall),
                  Text(traducciones.logout, style: AppTextStyles.logoutText),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}