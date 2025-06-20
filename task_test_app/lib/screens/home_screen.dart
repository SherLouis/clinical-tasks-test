import 'package:flutter/material.dart';
import 'package:task_test_app/l10n/app_localizations.dart';
import 'package:task_test_app/screens/session_select_screen.dart';
import 'package:task_test_app/utils/app_sizes.dart';
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
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TestSelectionScreen()),
              ),
              child: Text(
                AppLocalizations.of(context)!.startNewTest,
                style: TextStyle(fontSize: AppSizes.fontSize(context)),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SessionSelectScreen()),
                );
              },
              child: Text(
                AppLocalizations.of(context)!.startNewSession,
                style: TextStyle(fontSize: AppSizes.fontSize(context)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
