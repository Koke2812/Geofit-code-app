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

  String formatearSaldo(double saldo) {
    if (saldo.abs() >= 1000000) return '${(saldo / 1000000).toStringAsFixed(1)}M €';
    if (saldo.abs() >= 10000) return '${(saldo / 1000).toStringAsFixed(1)}K €';
    return '${saldo.toStringAsFixed(2)} €';
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return AppBar(
      title: Text(t.geoFitMenu),
      elevation: 0,
      actions: [
        PopupMenuButton<String>(
          icon: const Icon(Icons.shopping_cart),
          onSelected: (value) async {
            if (value == 'ingresar') {
              final cantidad = await Navigator.push(context, MaterialPageRoute(builder: (context) => const MoneyScreen()));
              if (cantidad != null) actualizarSaldo(cantidad);
            } else if (value == 'retirar') {
              final cantidadARetirar = await Navigator.push(context, MaterialPageRoute(builder: (context) => const OutmoneyScreen()));
              if (cantidadARetirar != null) actualizarSaldo(cantidadARetirar);
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              enabled: false,
              child: Row(children: [
                const Icon(Icons.attach_money, color: AppColors.primary, size: 20),
                const SizedBox(width: AppDimensions.paddingSmall),
                Text("${t.balance}: ${formatearSaldo(miSaldo)}", style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.black)),
              ]),
            ),
            const PopupMenuDivider(),
            PopupMenuItem(value: 'ingresar', child: Row(children: [
              const Icon(Icons.add_circle, color: AppColors.primary, size: 20),
              const SizedBox(width: AppDimensions.paddingSmall),
              Text(t.depositMoney),
            ])),
            const PopupMenuDivider(),
            PopupMenuItem(value: 'retirar', child: Row(children: [
              const Icon(Icons.payments, color: AppColors.warning, size: 20),
              const SizedBox(width: AppDimensions.paddingSmall),
              Text(t.withdrawMoney),
            ])),
          ],
        ),
        PopupMenuButton<String>(
          icon: const Icon(Icons.person),
          onSelected: (value) async {
            if (value == 'perfil') {
              final resultado = await Navigator.push<Usuario>(context, MaterialPageRoute(builder: (context) => ProfileScreen(usuario: usuario)));
              if (resultado != null && onUsuarioActualizado != null) onUsuarioActualizado!(resultado);
            } else if (value == 'logout') {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t.logoutSuccess), duration: const Duration(seconds: 1)));
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const HomeScreen()), (route) => false);
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(value: 'perfil', child: Row(children: [
              const Icon(Icons.account_circle, color: AppColors.primary),
              const SizedBox(width: AppDimensions.paddingSmall),
              Text(t.viewProfile),
            ])),
            const PopupMenuDivider(),
            PopupMenuItem(value: 'logout', child: Row(children: [
              const Icon(Icons.logout, color: AppColors.error),
              const SizedBox(width: AppDimensions.paddingSmall),
              Text(t.logout, style: AppTextStyles.logoutText),
            ])),
          ],
        ),
      ],
    );
  }
}