import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:task_test_app/l10n/app_localizations.dart';
import 'screens/home_screen.dart';

class TaskTestApp extends StatelessWidget {
  const TaskTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task test',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en'), Locale('fr')],
      localeResolutionCallback: (locale, supportedLocales) {
        // Utilise la locale du device si possible
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale?.languageCode) {
            return supportedLocale;
          }
        }
        return supportedLocales.first;
      },
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.blue,
      ),
      home: const HomeScreen(),
      builder: (context, child) {
        return Title(
          title: AppLocalizations.of(context)!.appTitle,
          color: Colors.blue,
          child: child!,
        );
      },
    );
  }
}
