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

  @override
  String get session_enterIdSnack => 'Veuillez saisir un identifiant de session.';

  @override
  String get session_enterIdLabel => 'Entrez un identifiant de session :';

  @override
  String get session_startPreTest => 'Démarrer un pré-test';

  @override
  String get session_startTest => 'Démarrer un test';

  @override
  String get skipImage => 'Passer l\'image';

  @override
  String get testComplete => 'Test terminé';

  @override
  String get noMoreImages => 'Il n\'y a plus d\'image à afficher.';

  @override
  String get ok => 'OK';

  @override
  String get goBack => 'Retour';
}
