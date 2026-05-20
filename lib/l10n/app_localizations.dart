import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
  ];

  /// No description provided for @signIn.
  ///
  /// In es, this message translates to:
  /// **'Iniciar Sesión'**
  String get signIn;

  /// No description provided for @createAccount.
  ///
  /// In es, this message translates to:
  /// **'Crear Cuenta'**
  String get createAccount;

  /// No description provided for @mainMenu.
  ///
  /// In es, this message translates to:
  /// **'Menú Principal'**
  String get mainMenu;

  /// No description provided for @language.
  ///
  /// In es, this message translates to:
  /// **'Idioma'**
  String get language;

  /// No description provided for @goBack.
  ///
  /// In es, this message translates to:
  /// **'Volver atrás'**
  String get goBack;

  /// No description provided for @nameUser.
  ///
  /// In es, this message translates to:
  /// **'Nombre / Usuario'**
  String get nameUser;

  /// No description provided for @password.
  ///
  /// In es, this message translates to:
  /// **'Contraseña'**
  String get password;

  /// No description provided for @repeatPassword.
  ///
  /// In es, this message translates to:
  /// **'Repetir Contraseña'**
  String get repeatPassword;

  /// No description provided for @maxCharsHint.
  ///
  /// In es, this message translates to:
  /// **'Máx 10 carac. (A, a, 1)'**
  String get maxCharsHint;

  /// No description provided for @mustMatchPassword.
  ///
  /// In es, this message translates to:
  /// **'Debe coincidir con la contraseña'**
  String get mustMatchPassword;

  /// No description provided for @signInButton.
  ///
  /// In es, this message translates to:
  /// **'INICIAR SESIÓN'**
  String get signInButton;

  /// No description provided for @createAccountButton.
  ///
  /// In es, this message translates to:
  /// **'CREAR CUENTA'**
  String get createAccountButton;

  /// No description provided for @userInvalid.
  ///
  /// In es, this message translates to:
  /// **'El usuario no cumple los requisitos (1 mayúscula, 1 minúscula, 1 número, máx 10 caract.)'**
  String get userInvalid;

  /// No description provided for @passInvalid.
  ///
  /// In es, this message translates to:
  /// **'La contraseña no cumple los requisitos (1 mayúscula, 1 minúscula, 1 número, máx 10 caract.)'**
  String get passInvalid;

  /// No description provided for @passNoMatch.
  ///
  /// In es, this message translates to:
  /// **'Las contraseñas no coinciden'**
  String get passNoMatch;

  /// No description provided for @userOrPassWrong.
  ///
  /// In es, this message translates to:
  /// **'Usuario o contraseña incorrectos'**
  String get userOrPassWrong;

  /// No description provided for @userAlreadyExists.
  ///
  /// In es, this message translates to:
  /// **'El nombre de usuario ya está en uso'**
  String get userAlreadyExists;

  /// No description provided for @accountCreated.
  ///
  /// In es, this message translates to:
  /// **'Cuenta creada con éxito'**
  String get accountCreated;

  /// No description provided for @reqNotMet.
  ///
  /// In es, this message translates to:
  /// **'No cumple los requisitos'**
  String get reqNotMet;

  /// No description provided for @noMatch.
  ///
  /// In es, this message translates to:
  /// **'No coinciden'**
  String get noMatch;

  /// No description provided for @geoFitMenu.
  ///
  /// In es, this message translates to:
  /// **'GeoFit Menu'**
  String get geoFitMenu;

  /// No description provided for @balance.
  ///
  /// In es, this message translates to:
  /// **'Saldo'**
  String get balance;

  /// No description provided for @depositMoney.
  ///
  /// In es, this message translates to:
  /// **'Ingresar dinero'**
  String get depositMoney;

  /// No description provided for @withdrawMoney.
  ///
  /// In es, this message translates to:
  /// **'Retirar dinero'**
  String get withdrawMoney;

  /// No description provided for @viewProfile.
  ///
  /// In es, this message translates to:
  /// **'Ver perfil'**
  String get viewProfile;

  /// No description provided for @logout.
  ///
  /// In es, this message translates to:
  /// **'Cerrar sesión'**
  String get logout;

  /// No description provided for @logoutSuccess.
  ///
  /// In es, this message translates to:
  /// **'Has cerrado sesión correctamente.'**
  String get logoutSuccess;

  /// No description provided for @welcome.
  ///
  /// In es, this message translates to:
  /// **'Bienvenido, '**
  String get welcome;

  /// No description provided for @countCalories.
  ///
  /// In es, this message translates to:
  /// **'Contar Calorías'**
  String get countCalories;

  /// No description provided for @planDiet.
  ///
  /// In es, this message translates to:
  /// **'Planificar Dieta'**
  String get planDiet;

  /// No description provided for @premium.
  ///
  /// In es, this message translates to:
  /// **'PREMIUM'**
  String get premium;

  /// No description provided for @comingSoon.
  ///
  /// In es, this message translates to:
  /// **'PROXIMAMENTE'**
  String get comingSoon;

  /// No description provided for @viewHistory.
  ///
  /// In es, this message translates to:
  /// **'Ver Historial'**
  String get viewHistory;

  /// No description provided for @personalAdvice.
  ///
  /// In es, this message translates to:
  /// **'Asesoría Personalizada'**
  String get personalAdvice;

  /// No description provided for @confirmPurchase.
  ///
  /// In es, this message translates to:
  /// **'Confirmar Compra'**
  String get confirmPurchase;

  /// No description provided for @purchaseQuestion.
  ///
  /// In es, this message translates to:
  /// **'¿Deseas pagar 2,99€ para desbloquear la Planificación de Dieta?'**
  String get purchaseQuestion;

  /// No description provided for @availableBalance.
  ///
  /// In es, this message translates to:
  /// **'Saldo disponible'**
  String get availableBalance;

  /// No description provided for @no.
  ///
  /// In es, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @yesPay.
  ///
  /// In es, this message translates to:
  /// **'Sí, pagar'**
  String get yesPay;

  /// No description provided for @insufficientBalance.
  ///
  /// In es, this message translates to:
  /// **'No tienes saldo suficiente para esta acción.'**
  String get insufficientBalance;

  /// No description provided for @myProfile.
  ///
  /// In es, this message translates to:
  /// **'Mi Perfil'**
  String get myProfile;

  /// No description provided for @changeProfilePhoto.
  ///
  /// In es, this message translates to:
  /// **'Cambiar foto de perfil'**
  String get changeProfilePhoto;

  /// No description provided for @takePhoto.
  ///
  /// In es, this message translates to:
  /// **'Tomar foto'**
  String get takePhoto;

  /// No description provided for @useDeviceCamera.
  ///
  /// In es, this message translates to:
  /// **'Usar la cámara del dispositivo'**
  String get useDeviceCamera;

  /// No description provided for @chooseGallery.
  ///
  /// In es, this message translates to:
  /// **'Elegir de galería'**
  String get chooseGallery;

  /// No description provided for @selectExistingImage.
  ///
  /// In es, this message translates to:
  /// **'Seleccionar una imagen existente'**
  String get selectExistingImage;

  /// No description provided for @deletePhoto.
  ///
  /// In es, this message translates to:
  /// **'Eliminar foto'**
  String get deletePhoto;

  /// No description provided for @tapToChangePhoto.
  ///
  /// In es, this message translates to:
  /// **'Toca para cambiar la foto'**
  String get tapToChangePhoto;

  /// No description provided for @user.
  ///
  /// In es, this message translates to:
  /// **'Usuario'**
  String get user;

  /// No description provided for @saveChanges.
  ///
  /// In es, this message translates to:
  /// **'Guardar Cambios'**
  String get saveChanges;

  /// No description provided for @profileUpdated.
  ///
  /// In es, this message translates to:
  /// **'Perfil actualizado'**
  String get profileUpdated;

  /// No description provided for @depositTitle.
  ///
  /// In es, this message translates to:
  /// **'Ingresar Dinero'**
  String get depositTitle;

  /// No description provided for @amountEuro.
  ///
  /// In es, this message translates to:
  /// **'Cantidad €'**
  String get amountEuro;

  /// No description provided for @confirm.
  ///
  /// In es, this message translates to:
  /// **'Confirmar'**
  String get confirm;

  /// No description provided for @withdrawTitle.
  ///
  /// In es, this message translates to:
  /// **'Retirar Dinero'**
  String get withdrawTitle;

  /// No description provided for @amountToWithdraw.
  ///
  /// In es, this message translates to:
  /// **'Cantidad a retirar €'**
  String get amountToWithdraw;

  /// No description provided for @confirmWithdraw.
  ///
  /// In es, this message translates to:
  /// **'Confirmar Retiro'**
  String get confirmWithdraw;

  /// No description provided for @enterAmount.
  ///
  /// In es, this message translates to:
  /// **'Introduce una cantidad'**
  String get enterAmount;

  /// No description provided for @enterWithdrawAmount.
  ///
  /// In es, this message translates to:
  /// **'Introduce una cantidad a retirar'**
  String get enterWithdrawAmount;

  /// No description provided for @onlyNumbers.
  ///
  /// In es, this message translates to:
  /// **'Solo se permiten números'**
  String get onlyNumbers;

  /// No description provided for @noNegative.
  ///
  /// In es, this message translates to:
  /// **'No se permiten cantidades negativas'**
  String get noNegative;

  /// No description provided for @mustBeGreaterZero.
  ///
  /// In es, this message translates to:
  /// **'La cantidad debe ser mayor que 0'**
  String get mustBeGreaterZero;

  /// No description provided for @maxAmount.
  ///
  /// In es, this message translates to:
  /// **'La cantidad máxima es 999.999,99€'**
  String get maxAmount;

  /// No description provided for @selectProduct.
  ///
  /// In es, this message translates to:
  /// **'Selecciona un producto'**
  String get selectProduct;

  /// No description provided for @grams.
  ///
  /// In es, this message translates to:
  /// **'Gramos'**
  String get grams;

  /// No description provided for @addToList.
  ///
  /// In es, this message translates to:
  /// **'Añadir a lista'**
  String get addToList;

  /// No description provided for @noFoodsAdded.
  ///
  /// In es, this message translates to:
  /// **'No hay alimentos añadidos'**
  String get noFoodsAdded;

  /// No description provided for @calculateMacros.
  ///
  /// In es, this message translates to:
  /// **'Calcular Calorías / Macronutrientes'**
  String get calculateMacros;

  /// No description provided for @selectFoodFirst.
  ///
  /// In es, this message translates to:
  /// **'Selecciona un alimento primero'**
  String get selectFoodFirst;

  /// No description provided for @enterGrams.
  ///
  /// In es, this message translates to:
  /// **'Introduce los gramos del alimento'**
  String get enterGrams;

  /// No description provided for @onlyNumbersGrams.
  ///
  /// In es, this message translates to:
  /// **'Solo se permiten números en el campo de gramos'**
  String get onlyNumbersGrams;

  /// No description provided for @noNegativeGrams.
  ///
  /// In es, this message translates to:
  /// **'No es válido poner números negativos'**
  String get noNegativeGrams;

  /// No description provided for @noZeroGrams.
  ///
  /// In es, this message translates to:
  /// **'No es posible poner 0 gramos'**
  String get noZeroGrams;

  /// No description provided for @addAtLeastOne.
  ///
  /// In es, this message translates to:
  /// **'Añade al menos un alimento a la lista'**
  String get addAtLeastOne;

  /// No description provided for @mustLoginHistory.
  ///
  /// In es, this message translates to:
  /// **'Debes iniciar sesión para guardar el historial'**
  String get mustLoginHistory;

  /// No description provided for @nutritionalSummary.
  ///
  /// In es, this message translates to:
  /// **'Resumen Nutricional'**
  String get nutritionalSummary;

  /// No description provided for @savedInHistory.
  ///
  /// In es, this message translates to:
  /// **'Guardado en historial'**
  String get savedInHistory;

  /// No description provided for @foodsAdded.
  ///
  /// In es, this message translates to:
  /// **'Alimentos añadidos:'**
  String get foodsAdded;

  /// No description provided for @totals.
  ///
  /// In es, this message translates to:
  /// **'TOTALES'**
  String get totals;

  /// No description provided for @calories.
  ///
  /// In es, this message translates to:
  /// **'Calorías'**
  String get calories;

  /// No description provided for @proteins.
  ///
  /// In es, this message translates to:
  /// **'Proteínas'**
  String get proteins;

  /// No description provided for @carbs.
  ///
  /// In es, this message translates to:
  /// **'Carbohidratos'**
  String get carbs;

  /// No description provided for @fats.
  ///
  /// In es, this message translates to:
  /// **'Grasas'**
  String get fats;

  /// No description provided for @accept.
  ///
  /// In es, this message translates to:
  /// **'Aceptar'**
  String get accept;

  /// No description provided for @dietConfig.
  ///
  /// In es, this message translates to:
  /// **'CONFIGURACIÓN DIETA'**
  String get dietConfig;

  /// No description provided for @male.
  ///
  /// In es, this message translates to:
  /// **'HOMBRE'**
  String get male;

  /// No description provided for @female.
  ///
  /// In es, this message translates to:
  /// **'MUJER'**
  String get female;

  /// No description provided for @height.
  ///
  /// In es, this message translates to:
  /// **'ALTURA'**
  String get height;

  /// No description provided for @cm.
  ///
  /// In es, this message translates to:
  /// **'CM'**
  String get cm;

  /// No description provided for @weight.
  ///
  /// In es, this message translates to:
  /// **'PESO'**
  String get weight;

  /// No description provided for @age.
  ///
  /// In es, this message translates to:
  /// **'EDAD'**
  String get age;

  /// No description provided for @lastSteps.
  ///
  /// In es, this message translates to:
  /// **'Últimos pasos'**
  String get lastSteps;

  /// No description provided for @customizeEffort.
  ///
  /// In es, this message translates to:
  /// **'Personaliza tu nivel de esfuerzo y meta.'**
  String get customizeEffort;

  /// No description provided for @activityLevel.
  ///
  /// In es, this message translates to:
  /// **'Nivel de Actividad'**
  String get activityLevel;

  /// No description provided for @yourGoal.
  ///
  /// In es, this message translates to:
  /// **'Tu Objetivo'**
  String get yourGoal;

  /// No description provided for @select.
  ///
  /// In es, this message translates to:
  /// **'Seleccionar...'**
  String get select;

  /// No description provided for @days12.
  ///
  /// In es, this message translates to:
  /// **'1-2 días'**
  String get days12;

  /// No description provided for @days34.
  ///
  /// In es, this message translates to:
  /// **'3-4 días'**
  String get days34;

  /// No description provided for @days4plus.
  ///
  /// In es, this message translates to:
  /// **'+4 días'**
  String get days4plus;

  /// No description provided for @loseWeight.
  ///
  /// In es, this message translates to:
  /// **'Bajar peso'**
  String get loseWeight;

  /// No description provided for @gainWeight.
  ///
  /// In es, this message translates to:
  /// **'Subir peso'**
  String get gainWeight;

  /// No description provided for @maintainWeight.
  ///
  /// In es, this message translates to:
  /// **'Mantener peso'**
  String get maintainWeight;

  /// No description provided for @next.
  ///
  /// In es, this message translates to:
  /// **'SIGUIENTE'**
  String get next;

  /// No description provided for @generateDiet.
  ///
  /// In es, this message translates to:
  /// **'GENERAR MI DIETA'**
  String get generateDiet;

  /// No description provided for @selectActivityAndGoal.
  ///
  /// In es, this message translates to:
  /// **'Selecciona nivel de actividad y objetivo.'**
  String get selectActivityAndGoal;

  /// No description provided for @yourDietPlan.
  ///
  /// In es, this message translates to:
  /// **'TU PLAN DE DIETA'**
  String get yourDietPlan;

  /// No description provided for @goalEmoji.
  ///
  /// In es, this message translates to:
  /// **'Tu Objetivo'**
  String get goalEmoji;

  /// No description provided for @mealPlan.
  ///
  /// In es, this message translates to:
  /// **'Plan de Comidas'**
  String get mealPlan;

  /// No description provided for @exportPdf.
  ///
  /// In es, this message translates to:
  /// **'EXPORTAR A PDF'**
  String get exportPdf;

  /// No description provided for @macroDistribution.
  ///
  /// In es, this message translates to:
  /// **'Distribución de Macronutrientes'**
  String get macroDistribution;

  /// No description provided for @carbsShort.
  ///
  /// In es, this message translates to:
  /// **'Carbos'**
  String get carbsShort;

  /// No description provided for @myHistory.
  ///
  /// In es, this message translates to:
  /// **'Mi Historial'**
  String get myHistory;

  /// No description provided for @deleteAllHistory.
  ///
  /// In es, this message translates to:
  /// **'Borrar todo el historial'**
  String get deleteAllHistory;

  /// No description provided for @yourNutritionalHistory.
  ///
  /// In es, this message translates to:
  /// **'Tu Historial Nutricional'**
  String get yourNutritionalHistory;

  /// No description provided for @reviewAllRecords.
  ///
  /// In es, this message translates to:
  /// **'Revisa todos tus registros de calorías y macronutrientes'**
  String get reviewAllRecords;

  /// No description provided for @record.
  ///
  /// In es, this message translates to:
  /// **'registro'**
  String get record;

  /// No description provided for @records.
  ///
  /// In es, this message translates to:
  /// **'registros'**
  String get records;

  /// No description provided for @deleteRecord.
  ///
  /// In es, this message translates to:
  /// **'Eliminar registro'**
  String get deleteRecord;

  /// No description provided for @cancel.
  ///
  /// In es, this message translates to:
  /// **'Cancelar'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In es, this message translates to:
  /// **'Eliminar'**
  String get delete;

  /// No description provided for @deleteAll.
  ///
  /// In es, this message translates to:
  /// **'Borrar todo'**
  String get deleteAll;

  /// No description provided for @confirmDeleteRecord.
  ///
  /// In es, this message translates to:
  /// **'¿Estás seguro de que quieres eliminar el registro del'**
  String get confirmDeleteRecord;

  /// No description provided for @confirmDeleteAll.
  ///
  /// In es, this message translates to:
  /// **'¿Estás seguro de que quieres eliminar TODO tu historial? Esta acción no se puede deshacer.'**
  String get confirmDeleteAll;

  /// No description provided for @recordDeleted.
  ///
  /// In es, this message translates to:
  /// **'Registro eliminado'**
  String get recordDeleted;

  /// No description provided for @historyDeleted.
  ///
  /// In es, this message translates to:
  /// **'Historial eliminado por completo'**
  String get historyDeleted;

  /// No description provided for @foodDetail.
  ///
  /// In es, this message translates to:
  /// **'Detalle de alimentos:'**
  String get foodDetail;

  /// No description provided for @noRecordsYet.
  ///
  /// In es, this message translates to:
  /// **'Aún no tienes registros\nComienza a contar calorías para verlos aquí'**
  String get noRecordsYet;

  /// No description provided for @workingOnIt.
  ///
  /// In es, this message translates to:
  /// **'¡Estamos trabajando en ello!'**
  String get workingOnIt;

  /// No description provided for @comingSoonMessage.
  ///
  /// In es, this message translates to:
  /// **'La función de Asesoría Personalizada estará disponible muy pronto para ayudarte a alcanzar tus metas de forma directa.\n\n¡Gracias por tu paciencia y por formar parte de GeoFit!'**
  String get comingSoonMessage;

  /// No description provided for @backToMenu.
  ///
  /// In es, this message translates to:
  /// **'VOLVER AL MENÚ'**
  String get backToMenu;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
