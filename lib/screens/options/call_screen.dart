import 'package:flutter/material.dart';
import 'package:geofit/l10n/app_localizations.dart';
import 'package:geofit/models/app_colors.dart';
import 'package:geofit/models/app_dimensions.dart';

class CallScreen extends StatelessWidget {
  const CallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(backgroundColor: AppColors.white, elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios, color: AppColors.primary), onPressed: () => Navigator.pop(context))),
      body: Padding(padding: const EdgeInsets.symmetric(horizontal: 30.0), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(padding: const EdgeInsets.all(AppDimensions.paddingLarge),
          decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), shape: BoxShape.circle),
          child: const Icon(Icons.construction_rounded, size: 80, color: AppColors.primary)),
        const SizedBox(height: 30),
        Text(t.workingOnIt, textAlign: TextAlign.center, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.black)),
        const SizedBox(height: 15),
        Text(t.comingSoonMessage, textAlign: TextAlign.center, style: TextStyle(fontSize: 16, color: AppColors.greyText, height: 1.5)),
        const SizedBox(height: 40),
        SizedBox(width: double.infinity, child: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusButton)),
            padding: const EdgeInsets.symmetric(vertical: 15)),
          onPressed: () => Navigator.pop(context),
          child: Text(t.backToMenu, style: const TextStyle(color: AppColors.white, fontWeight: FontWeight.bold, fontSize: 16)))),
      ])),
    );
  }
}
