import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_gu.dart';

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
    Locale('gu'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'GAAMHAUL'**
  String get appTitle;

  /// No description provided for @customerAppSubtitle.
  ///
  /// In en, this message translates to:
  /// **'વાહન સાથી'**
  String get customerAppSubtitle;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @gujarati.
  ///
  /// In en, this message translates to:
  /// **'ગુજરાતી'**
  String get gujarati;

  /// No description provided for @bookVehicleCta.
  ///
  /// In en, this message translates to:
  /// **'Book a Vehicle'**
  String get bookVehicleCta;

  /// No description provided for @bookVehicleSub.
  ///
  /// In en, this message translates to:
  /// **'Fast and reliable local transport'**
  String get bookVehicleSub;

  /// No description provided for @stepVehicleTitle.
  ///
  /// In en, this message translates to:
  /// **'What do you need?'**
  String get stepVehicleTitle;

  /// No description provided for @stepVehicleSub.
  ///
  /// In en, this message translates to:
  /// **'Select the best vehicle for your haul'**
  String get stepVehicleSub;

  /// No description provided for @stepWorkTitle.
  ///
  /// In en, this message translates to:
  /// **'What are you using the vehicle for?'**
  String get stepWorkTitle;

  /// No description provided for @stepWorkSub.
  ///
  /// In en, this message translates to:
  /// **'Helps us match you with the right Saathi'**
  String get stepWorkSub;

  /// No description provided for @stepPickupTitle.
  ///
  /// In en, this message translates to:
  /// **'Where should we pick it up?'**
  String get stepPickupTitle;

  /// No description provided for @stepDropTitle.
  ///
  /// In en, this message translates to:
  /// **'Where should we take it?'**
  String get stepDropTitle;

  /// No description provided for @stepWhenTitle.
  ///
  /// In en, this message translates to:
  /// **'When do you need the vehicle?'**
  String get stepWhenTitle;

  /// No description provided for @stepDurationTitle.
  ///
  /// In en, this message translates to:
  /// **'How long do you need it?'**
  String get stepDurationTitle;

  /// No description provided for @stepReviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Review your haul'**
  String get stepReviewTitle;

  /// No description provided for @actionContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get actionContinue;

  /// No description provided for @actionBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get actionBack;

  /// No description provided for @actionFindVehicle.
  ///
  /// In en, this message translates to:
  /// **'Find My Vehicle'**
  String get actionFindVehicle;

  /// No description provided for @vehiclePickupName.
  ///
  /// In en, this message translates to:
  /// **'Pickup'**
  String get vehiclePickupName;

  /// No description provided for @vehiclePickupDesc.
  ///
  /// In en, this message translates to:
  /// **'Good for construction materials, farm goods and shop deliveries'**
  String get vehiclePickupDesc;

  /// No description provided for @vehicleMiniTruckName.
  ///
  /// In en, this message translates to:
  /// **'Mini Truck'**
  String get vehicleMiniTruckName;

  /// No description provided for @vehicleMiniTruckDesc.
  ///
  /// In en, this message translates to:
  /// **'Perfect for small to medium shifting and goods transport'**
  String get vehicleMiniTruckDesc;

  /// No description provided for @vehicleTempoName.
  ///
  /// In en, this message translates to:
  /// **'Tempo'**
  String get vehicleTempoName;

  /// No description provided for @vehicleTempoDesc.
  ///
  /// In en, this message translates to:
  /// **'Ideal for fast local deliveries and small items'**
  String get vehicleTempoDesc;

  /// No description provided for @vehicleELoaderName.
  ///
  /// In en, this message translates to:
  /// **'E-Loader'**
  String get vehicleELoaderName;

  /// No description provided for @vehicleELoaderDesc.
  ///
  /// In en, this message translates to:
  /// **'Eco-friendly transport for narrow village roads'**
  String get vehicleELoaderDesc;

  /// No description provided for @vehicleTractorName.
  ///
  /// In en, this message translates to:
  /// **'Tractor'**
  String get vehicleTractorName;

  /// No description provided for @vehicleTractorDesc.
  ///
  /// In en, this message translates to:
  /// **'Heavy-duty power for farm work and heavy materials'**
  String get vehicleTractorDesc;

  /// No description provided for @workFarm.
  ///
  /// In en, this message translates to:
  /// **'Farm'**
  String get workFarm;

  /// No description provided for @workNursery.
  ///
  /// In en, this message translates to:
  /// **'Nursery'**
  String get workNursery;

  /// No description provided for @workConstruction.
  ///
  /// In en, this message translates to:
  /// **'Construction'**
  String get workConstruction;

  /// No description provided for @workShifting.
  ///
  /// In en, this message translates to:
  /// **'Shifting'**
  String get workShifting;

  /// No description provided for @workShop.
  ///
  /// In en, this message translates to:
  /// **'Shop'**
  String get workShop;

  /// No description provided for @workOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get workOther;

  /// No description provided for @durationOneHour.
  ///
  /// In en, this message translates to:
  /// **'1 Hour'**
  String get durationOneHour;

  /// No description provided for @durationTwoHours.
  ///
  /// In en, this message translates to:
  /// **'2 Hours'**
  String get durationTwoHours;

  /// No description provided for @durationHalfDay.
  ///
  /// In en, this message translates to:
  /// **'Half Day'**
  String get durationHalfDay;

  /// No description provided for @durationFullDay.
  ///
  /// In en, this message translates to:
  /// **'Full Day'**
  String get durationFullDay;

  /// No description provided for @estimatedFare.
  ///
  /// In en, this message translates to:
  /// **'ESTIMATED FARE'**
  String get estimatedFare;

  /// No description provided for @fareDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'Final price may vary based on the actual work and agreement with the Saathi.'**
  String get fareDisclaimer;

  /// No description provided for @findingSaathiTitle.
  ///
  /// In en, this message translates to:
  /// **'Finding a Vahan Saathi'**
  String get findingSaathiTitle;

  /// No description provided for @findingSaathiSub.
  ///
  /// In en, this message translates to:
  /// **'Looking for available vehicles near you...'**
  String get findingSaathiSub;

  /// No description provided for @haulConfirmed.
  ///
  /// In en, this message translates to:
  /// **'HAUL CONFIRMED'**
  String get haulConfirmed;

  /// No description provided for @callSaathi.
  ///
  /// In en, this message translates to:
  /// **'CALL SAATHI'**
  String get callSaathi;

  /// No description provided for @whatsappSaathi.
  ///
  /// In en, this message translates to:
  /// **'WHATSAPP'**
  String get whatsappSaathi;

  /// No description provided for @editLabel.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get editLabel;
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
      <String>['en', 'gu'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'gu':
      return AppLocalizationsGu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
