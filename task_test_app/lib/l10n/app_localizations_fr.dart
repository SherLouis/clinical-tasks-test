// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Testeur de tâches';

  @override
  String get homeScreenTitle => 'Accueil';

  @override
  String get startNewTest => 'Nouveau test';

  @override
  String get startNewSession => 'Nouvelle session';

  @override
  String get chooseTest => 'Choisir un test';

  @override
  String get endTest => 'Terminer le test';

  @override
  String get closeMenu => 'Fermer le menu';

  @override
  String get previous => 'Précédent';

  @override
  String get next => 'Suivant';

  @override
  String get showMenu => 'Afficher le menu';
}
