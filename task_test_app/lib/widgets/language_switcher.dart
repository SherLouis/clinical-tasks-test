import 'package:flutter/material.dart';
import 'package:task_test_app/app.dart';

class LanguageSwitcher extends StatelessWidget {
  const LanguageSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<Locale>(
      icon: const Icon(Icons.language_outlined),
      tooltip: 'Change language',
      onSelected: (Locale locale) {
        TaskTestApp.of(context)?.setLocale(locale);
      },
      itemBuilder: (BuildContext context) {
        final currentLocale = Localizations.localeOf(context);
        return <PopupMenuEntry<Locale>>[
          PopupMenuItem<Locale>(
            value: const Locale('en'),
            child: Row(
              children: [
                const Text('English'),
                if (currentLocale.languageCode == 'en') ...[
                  const Spacer(),
                  const Icon(Icons.check, size: 16),
                ],
              ],
            ),
          ),
          PopupMenuItem<Locale>(
            value: const Locale('fr'),
            child: Row(
              children: [
                const Text('Français'),
                if (currentLocale.languageCode == 'fr') ...[
                  const Spacer(),
                  const Icon(Icons.check, size: 16),
                ],
              ],
            ),
          ),
        ];
      },
    );
  }
}
