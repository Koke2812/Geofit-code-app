import 'package:flutter/material.dart';
import 'package:geofit/l10n/app_localizations.dart';
import 'package:geofit/locale_notifier.dart';
import 'package:geofit/screens/forms/form_create.dart';
import 'package:geofit/screens/forms/form_sign.dart';
import 'package:geofit/models/app_colors.dart';
import 'package:geofit/models/app_dimensions.dart';
import 'package:geofit/models/app_text_styles.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        children: [
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
          Padding(
            padding: const EdgeInsets.only(left: 40, right: 40),
            child: SizedBox(
              width: double.infinity,
              height: AppDimensions.buttonHeight,
              child: ElevatedButton(
                onPressed: () => Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (_) => const FormSign())),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.background,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppDimensions.radiusCard)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.login, color: AppColors.primary),
                    const SizedBox(width: AppDimensions.paddingSmall),
                    Text(t.signIn,
                        style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 16)),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20, left: 40, right: 40),
            child: SizedBox(
              width: double.infinity,
              height: AppDimensions.buttonHeight,
              child: ElevatedButton(
                onPressed: () => Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (_) => const FormCreate())),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.background,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppDimensions.radiusCard)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.person_add, color: AppColors.primary),
                    const SizedBox(width: AppDimensions.paddingSmall),
                    Text(t.createAccount,
                        style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 16)),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 40, top: 20),
            child: ValueListenableBuilder<Locale>(
              valueListenable: localeNotifier,
              builder: (context, currentLocale, _) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${t.language}: ',
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    DropdownButton<String>(
                      value: currentLocale.languageCode,
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
                      onChanged: (value) {
                        if (value != null) {
                          localeNotifier.value = Locale(value);
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