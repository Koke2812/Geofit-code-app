import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:geofit/l10n/app_localizations.dart';
import 'package:geofit/locale_notifier.dart';
import 'package:geofit/screens/splash_screen.dart';
import 'database/database_geo.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseGeo.instance.database;
  runApp(const GeoFitApp());
}

class GeoFitApp extends StatelessWidget {
  const GeoFitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Locale>(
      valueListenable: localeNotifier,
      builder: (context, locale, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'GeoFit',
          locale: locale,
          supportedLocales: const [
            Locale('es'),
            Locale('en'),
          ],
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: const SplashScreen(),
        );
      },
    );
  }
}