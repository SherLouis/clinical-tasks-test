// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Task Test App';

  @override
  String get homeScreenTitle => 'Home';

  @override
  String get startNewTest => 'New test';

  @override
  String get startNewSession => 'New session';

  @override
  String get chooseTest => 'Choose a test';

  @override
  String get endTest => 'End test';

  @override
  String get closeMenu => 'Close menu';

  @override
  String get previous => 'Previous';

  @override
  String get next => 'Next';

  @override
  String get showMenu => 'Show menu';
}
