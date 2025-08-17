import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

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
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Task Test App'**
  String get appTitle;

  /// No description provided for @homeScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeScreenTitle;

  /// No description provided for @startNewTest.
  ///
  /// In en, this message translates to:
  /// **'New test'**
  String get startNewTest;

  /// No description provided for @startNewSession.
  ///
  /// In en, this message translates to:
  /// **'New session'**
  String get startNewSession;

  /// No description provided for @chooseTest.
  ///
  /// In en, this message translates to:
  /// **'Choose a test'**
  String get chooseTest;

  /// No description provided for @endTest.
  ///
  /// In en, this message translates to:
  /// **'End test'**
  String get endTest;

  /// No description provided for @closeMenu.
  ///
  /// In en, this message translates to:
  /// **'Close menu'**
  String get closeMenu;

  /// No description provided for @previous.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get previous;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @showMenu.
  ///
  /// In en, this message translates to:
  /// **'Show menu'**
  String get showMenu;

  /// No description provided for @selectSession.
  ///
  /// In en, this message translates to:
  /// **'Select a session'**
  String get selectSession;

  /// No description provided for @existingSessions.
  ///
  /// In en, this message translates to:
  /// **'Existing sessions'**
  String get existingSessions;

  /// No description provided for @noSessions.
  ///
  /// In en, this message translates to:
  /// **'No sessions found.'**
  String get noSessions;

  /// No description provided for @createSession.
  ///
  /// In en, this message translates to:
  /// **'Create a new session'**
  String get createSession;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @session_idRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter a session identifier.'**
  String get session_idRequired;

  /// No description provided for @session_idAlreadyExists.
  ///
  /// In en, this message translates to:
  /// **'This session ID already exists.'**
  String get session_idAlreadyExists;

  /// No description provided for @session_enterIdLabel.
  ///
  /// In en, this message translates to:
  /// **'Enter a session identifier : '**
  String get session_enterIdLabel;

  /// No description provided for @sessionInProgress.
  ///
  /// In en, this message translates to:
  /// **'Session \"{id}\" in progress'**
  String sessionInProgress(Object id);

  /// No description provided for @session_startPreTest.
  ///
  /// In en, this message translates to:
  /// **'Start pre-test'**
  String get session_startPreTest;

  /// No description provided for @session_startTest.
  ///
  /// In en, this message translates to:
  /// **'Start test'**
  String get session_startTest;

  /// No description provided for @deleteSession.
  ///
  /// In en, this message translates to:
  /// **'Delete session'**
  String get deleteSession;

  /// No description provided for @confirmDeleteSession.
  ///
  /// In en, this message translates to:
  /// **'Do you really want to delete session « {id} » ?'**
  String confirmDeleteSession(Object id);

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @skipImage.
  ///
  /// In en, this message translates to:
  /// **'Skip image'**
  String get skipImage;

  /// No description provided for @testComplete.
  ///
  /// In en, this message translates to:
  /// **'Test complete'**
  String get testComplete;

  /// No description provided for @noMoreImages.
  ///
  /// In en, this message translates to:
  /// **'There are no more images to display.'**
  String get noMoreImages;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @goBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get goBack;

  /// No description provided for @created.
  ///
  /// In en, this message translates to:
  /// **'Created'**
  String get created;

  /// No description provided for @restore.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get restore;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @testHistory.
  ///
  /// In en, this message translates to:
  /// **'Test history'**
  String get testHistory;

  /// No description provided for @noCompletedTest.
  ///
  /// In en, this message translates to:
  /// **'No completed tests for this session'**
  String get noCompletedTest;

  /// No description provided for @startTest.
  ///
  /// In en, this message translates to:
  /// **'Start test'**
  String get startTest;

  /// No description provided for @startPreTest.
  ///
  /// In en, this message translates to:
  /// **'Start pre-test'**
  String get startPreTest;

  /// No description provided for @showInstructions.
  ///
  /// In en, this message translates to:
  /// **'Show instructions'**
  String get showInstructions;

  /// No description provided for @showComplementary.
  ///
  /// In en, this message translates to:
  /// **'Show complementary material'**
  String get showComplementary;

  /// No description provided for @testOptions.
  ///
  /// In en, this message translates to:
  /// **'Test options'**
  String get testOptions;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'fr': return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
