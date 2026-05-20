import 'package:flutter/material.dart';
import 'package:geofit/l10n/app_localizations.dart';
import 'package:geofit/locale_notifier.dart';
import 'package:geofit/screens/forms/form_create.dart';
import 'package:geofit/screens/forms/form_sign.dart';
import 'package:geofit/models/app_colors.dart';
import 'package:geofit/models/app_dimensions.dart';
<<<<<<< HEAD

// ─────────────────────────────────────────────
// Pantalla: Inicio (login / registro)
// ─────────────────────────────────────────────
=======
import 'package:geofit/models/app_text_styles.dart';

>>>>>>> dd4388feed10aea6a261b8f796f4e238ac56b83d
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    final traducciones = AppLocalizations.of(context)!;
=======
    final t = AppLocalizations.of(context)!;
>>>>>>> dd4388feed10aea6a261b8f796f4e238ac56b83d

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        children: [
<<<<<<< HEAD
          // ── Logo ──
=======
>>>>>>> dd4388feed10aea6a261b8f796f4e238ac56b83d
          Padding(
            padding: const EdgeInsets.only(top: 150),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/geofit_256x256.png",
                  height: AppDimensions.logoHeight,
                  fit: BoxFit.contain,
                ),
              ],
            ),
          ),
<<<<<<< HEAD

          // ── Botón: Iniciar sesión ──
=======
>>>>>>> dd4388feed10aea6a261b8f796f4e238ac56b83d
          Padding(
            padding: const EdgeInsets.only(left: 40, right: 40),
            child: SizedBox(
              width: double.infinity,
              height: AppDimensions.buttonHeight,
              child: ElevatedButton(
<<<<<<< HEAD
                onPressed: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const FormSign()),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.background,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
                  ),
=======
                onPressed: () => Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (_) => const FormSign())),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.background,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppDimensions.radiusCard)),
>>>>>>> dd4388feed10aea6a261b8f796f4e238ac56b83d
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.login, color: AppColors.primary),
                    const SizedBox(width: AppDimensions.paddingSmall),
<<<<<<< HEAD
                    Text(
                      traducciones.signIn,
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
=======
                    Text(t.signIn,
                        style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 16)),
>>>>>>> dd4388feed10aea6a261b8f796f4e238ac56b83d
                  ],
                ),
              ),
            ),
          ),
<<<<<<< HEAD

          // ── Botón: Crear cuenta ──
=======
>>>>>>> dd4388feed10aea6a261b8f796f4e238ac56b83d
          Padding(
            padding: const EdgeInsets.only(top: 20, left: 40, right: 40),
            child: SizedBox(
              width: double.infinity,
              height: AppDimensions.buttonHeight,
              child: ElevatedButton(
<<<<<<< HEAD
                onPressed: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const FormCreate()),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.background,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
                  ),
=======
                onPressed: () => Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (_) => const FormCreate())),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.background,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppDimensions.radiusCard)),
>>>>>>> dd4388feed10aea6a261b8f796f4e238ac56b83d
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.person_add, color: AppColors.primary),
                    const SizedBox(width: AppDimensions.paddingSmall),
<<<<<<< HEAD
                    Text(
                      traducciones.createAccount,
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
=======
                    Text(t.createAccount,
                        style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 16)),
>>>>>>> dd4388feed10aea6a261b8f796f4e238ac56b83d
                  ],
                ),
              ),
            ),
          ),
<<<<<<< HEAD

          // ── Selector de idioma ──
=======
>>>>>>> dd4388feed10aea6a261b8f796f4e238ac56b83d
          Padding(
            padding: const EdgeInsets.only(bottom: 40, top: 20),
            child: ValueListenableBuilder<Locale>(
              valueListenable: localeNotifier,
<<<<<<< HEAD
              builder: (contexto, idiomaActual, _) {
=======
              builder: (context, currentLocale, _) {
>>>>>>> dd4388feed10aea6a261b8f796f4e238ac56b83d
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
<<<<<<< HEAD
                      '${traducciones.language}: ',
=======
                      '${t.language}: ',
>>>>>>> dd4388feed10aea6a261b8f796f4e238ac56b83d
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    DropdownButton<String>(
<<<<<<< HEAD
                      value: idiomaActual.languageCode,
=======
                      value: currentLocale.languageCode,
>>>>>>> dd4388feed10aea6a261b8f796f4e238ac56b83d
                      underline: const SizedBox(),
                      borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                      items: const [
                        DropdownMenuItem(
                          value: 'es',
                          child: Row(
                            children: [
                              Text('🇪🇸', style: TextStyle(fontSize: 20)),
                              SizedBox(width: 8),
                              Text('Español'),
                            ],
                          ),
                        ),
                        DropdownMenuItem(
                          value: 'en',
                          child: Row(
                            children: [
                              Text('🇬🇧', style: TextStyle(fontSize: 20)),
                              SizedBox(width: 8),
                              Text('English'),
                            ],
                          ),
                        ),
                      ],
<<<<<<< HEAD
                      onChanged: (valor) {
                        if (valor != null) {
                          localeNotifier.value = Locale(valor);
=======
                      onChanged: (value) {
                        if (value != null) {
                          localeNotifier.value = Locale(value);
>>>>>>> dd4388feed10aea6a261b8f796f4e238ac56b83d
                        }
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}