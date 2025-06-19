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

  @override
  String get session_enterIdSnack => 'Please enter a session identifier.';

  @override
  String get session_enterIdLabel => 'Enter a session identifier : ';

  @override
  String get session_startPreTest => 'Start pre-test';

  @override
  String get session_startTest => 'Start test';

  @override
  String get skipImage => 'Skip image';

  @override
  String get testComplete => 'Test complete';

  @override
  String get noMoreImages => 'There are no more images to display.';

  @override
  String get ok => 'OK';

  @override
  String get goBack => 'Back';
}
