import 'package:flutter/material.dart';
import 'package:task_test_app/l10n/app_localizations.dart';
import 'package:task_test_app/screens/session_select_screen.dart';
import 'package:task_test_app/services/session_manager.dart';
import 'package:task_test_app/utils/app_sizes.dart';
import 'package:task_test_app/widgets/language_switcher.dart';
import 'test_selection_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.homeScreenTitle,
          style: TextStyle(fontSize: AppSizes.fontSize(context)),
        ),
        actions: const [
          LanguageSwitcher(),
          SizedBox(width: 8),
        ],
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox.square(
              dimension: 200,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(20),
                  ),
                  backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                  foregroundColor: Theme.of(context).colorScheme.onSecondaryContainer,
                  textStyle: TextStyle(
                    fontSize: AppSizes.fontSize(context) + 4,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () => {
                  SessionManager().endSession(),
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const TestSelectionScreen(),
                    ),
                  ),
                },
                child: Text(
                  AppLocalizations.of(context)!.startNewTest,
                  style: TextStyle(fontSize: AppSizes.fontSize(context)),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(width: 20),
            SizedBox.square(
              dimension: 200,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(20),
                  ),
                  backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                  foregroundColor: Theme.of(context).colorScheme.onSecondaryContainer,
                  textStyle: TextStyle(
                    fontSize: AppSizes.fontSize(context) + 4,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const SessionSelectScreen(),
                    ),
                  );
                },
                child: Text(
                  AppLocalizations.of(context)!.startNewSession,
                  style: TextStyle(fontSize: AppSizes.fontSize(context)),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
