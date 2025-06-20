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
  String get selectSession => 'Select a session';

  @override
  String get existingSessions => 'Existing sessions';

  @override
  String get noSessions => 'No sessions found.';

  @override
  String get createSession => 'Create a new session';

  @override
  String get create => 'Create';

  @override
  String get session_idRequired => 'Please enter a session identifier.';

  @override
  String get session_idAlreadyExists => 'This session ID already exists.';

  @override
  String get session_enterIdLabel => 'Enter a session identifier : ';

  @override
  String get session_selectTestMode => 'Select test mode';

  @override
  String sessionInProgress(Object id) {
    return 'Session \"$id\" in progress';
  }

  @override
  String get session_startPreTest => 'Start pre-test';

  @override
  String get session_startTest => 'Start test';

  @override
  String get deleteSession => 'Delete session';

  @override
  String confirmDeleteSession(Object id) {
    return 'Do you really want to delete session « $id » ?';
  }

  @override
  String get delete => 'Delete';

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

  @override
  String get created => 'Created';

  @override
  String get cancel => 'Cancel';
}
